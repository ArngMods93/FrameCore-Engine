package backend;

import flixel.FlxGame;

/**
	FrameCoreGame - subclase de FlxGame que desacopla el tick de lógica del frame de render.
	Toda la lógica pasa por `step()`, así que scripts, tweens, notas y stages heredan
	el sub-delta correcto sin tocar PlayState ni Note.hx.
**/
class FrameCoreGame extends FlxGame
{
	public static var instance:FrameCoreGame;

	/** Tope de ticks de lógica por frame, para no entrar en spiral of death **/
	public var maxSubSteps:Int = 8;

	var tpsAccumulator:Float = 0;

	public function new(gameWidth:Int = 0, gameHeight:Int = 0, ?initialState:Dynamic, updateFramerate:Int = 60, drawFramerate:Int = 60,
			skipSplash:Bool = false, startFullscreen:Bool = false)
	{
		super(gameWidth, gameHeight, cast initialState, updateFramerate, drawFramerate, skipSplash, startFullscreen);
		instance = this;
	}

	override function step():Void
	{
		var target:Float = TPSMode.targetTPS();

		// Modo Sync: comportamiento original, 1 tick por frame
		if (target <= 0)
		{
			TPSMode.countTick();
			super.step();
			return;
		}

		@:privateAccess var frameMS:Float = _elapsedMS;
		@:privateAccess if (frameMS <= 0) frameMS = _stepMS;

		var tickMS:Float = 1000 / target;
		tpsAccumulator += frameMS;

		// clamp del acumulador (lag spikes / alt-tab)
		var maxAccum:Float = tickMS * maxSubSteps;
		if (tpsAccumulator > maxAccum) tpsAccumulator = maxAccum;

		var steps:Int = 0;
		while (tpsAccumulator >= tickMS && steps < maxSubSteps)
		{
			tpsAccumulator -= tickMS;
			steps++;

			// el delta que va a ver TODO el juego en este tick
			@:privateAccess _elapsedMS = tickMS;
			TPSMode.countTick();
			super.step();
		}

		// restauramos el delta real del frame para que el resto del engine no se confunda
		@:privateAccess _elapsedMS = frameMS;
	}
}
