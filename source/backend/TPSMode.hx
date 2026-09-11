package backend;

import flixel.FlxG;

/**
	TPS Mode - FrameCore Engine
	Controla la frecuencia de actualización de la lógica del juego (ticks por segundo),
	de forma independiente al framerate de render.

	Modos:
	  - Sync    : la lógica corre 1 tick por frame (comportamiento clásico de Psych/HaxeFlixel).
	  - Fixed   : la lógica intenta mantener un TPS fijo definido por el usuario.
	  - Dynamic : el TPS se ajusta solo según el FPS real, entre un mínimo y un máximo.
**/
class TPSMode
{
	/** TPS real medido en el último segundo **/
	public static var currentTPS(default, null):Int = 0;

	/** TPS que el sistema está intentando mantener ahora mismo (0 = sync con el render) **/
	public static var appliedTPS(default, null):Int = 0;

	/** Límites duros para que nadie se mate poniendo 999999 **/
	public static inline var MIN_TPS:Int = 15;
	public static inline var MAX_TPS:Int = 1000;

	// medición
	static var tickCount:Int = 0;
	static var lastMeasure:Float = 0;

	// dynamic
	static var fpsAverage:Float = 60;
	static var lastSwitch:Float = 0;

	public static function getMode():String
	{
		var mode:String = ClientPrefs.data.tpsMode;
		return (mode == null) ? 'Sync' : mode;
	}

	/**
		TPS objetivo para este frame. Devuelve 0 si hay que correr en modo Sync
		(un tick por frame, sin acumulador).
	**/
	public static function targetTPS():Float
	{
		var result:Float = 0;
		switch (getMode())
		{
			case 'Fixed':
				result = clampTPS(ClientPrefs.data.tpsFixed);

			case 'Dynamic':
				result = dynamicTarget();

			default: // 'Sync'
				result = 0;
		}
		appliedTPS = Std.int(result);
		return result;
	}

	/**
		Media móvil del FPS + histéresis para que el TPS no salte en cada frame.
	**/
	static function dynamicTarget():Float
	{
		var now:Float = haxe.Timer.stamp();
		var fps:Float = (FPSCounterRef() > 0) ? FPSCounterRef() : FlxG.drawFramerate;

		// media móvil exponencial
		fpsAverage = fpsAverage + (fps - fpsAverage) * 0.05;

		var min:Int = clampTPS(ClientPrefs.data.tpsDynamicMin);
		var max:Int = clampTPS(ClientPrefs.data.tpsDynamicMax);
		if (min > max)
		{
			var tmp:Int = min;
			min = max;
			max = tmp;
		}

		var wanted:Float = Math.max(min, Math.min(max, fpsAverage));

		// histéresis: solo cambiamos si la diferencia es significativa (>10%)
		// y pasaron al menos 0.5s desde el último cambio.
		if (appliedTPS < min || appliedTPS > max) return wanted;
		if (appliedTPS <= 0) return wanted;

		var diff:Float = Math.abs(wanted - appliedTPS) / appliedTPS;
		if (diff > 0.10 && (now - lastSwitch) > 0.5)
		{
			lastSwitch = now;
			return wanted;
		}
		return appliedTPS;
	}

	// FPS real (del contador de debug si existe, si no el del engine)
	static inline function FPSCounterRef():Float
	{
		#if !mobile
		if (Main.fpsVar != null) return Main.fpsVar.currentFPS;
		#end
		return 0;
	}

	public static inline function clampTPS(value:Int):Int
	{
		if (value < MIN_TPS) return MIN_TPS;
		if (value > MAX_TPS) return MAX_TPS;
		return value;
	}

	/** Lo llama FrameCoreGame en cada tick de lógica **/
	public static function countTick():Void
	{
		tickCount++;
		var now:Float = haxe.Timer.stamp();
		if (lastMeasure == 0) lastMeasure = now;
		if (now - lastMeasure >= 1)
		{
			currentTPS = Math.round(tickCount / (now - lastMeasure));
			tickCount = 0;
			lastMeasure = now;
		}
	}

	/** Texto para mostrar en el FPSCounter / menús **/
	public static function getDisplayString():String
	{
		switch (getMode())
		{
			case 'Fixed': return '${currentTPS} (Fixed ${clampTPS(ClientPrefs.data.tpsFixed)})';
			case 'Dynamic': return '${currentTPS} (Dynamic ${appliedTPS})';
			default: return '${currentTPS} (Sync)';
		}
	}
}
