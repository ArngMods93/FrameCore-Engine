package debug;

import flixel.FlxG;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.system.System;
import openfl.system.Capabilities;

/**
	The FPS class provides an easy-to-use monitor to display
	the current frame rate of an OpenFL project
**/
class FPSCounter extends TextField
{
	/**
		The current frame rate, expressed using frames-per-second
	**/
	public var currentFPS(default, null):Int;

	/**
		The current memory usage (WARNING: this is NOT your total program memory usage, rather it shows the garbage collector memory)
	**/
	public var memoryMegas(get, never):Float;

	@:noCompletion private var times:Array<Float>;

	/**
		Nombre del engine que se muestra debajo del contador de FPS
	**/
	public static var engineName:String = "FrameCore Engine";

	/**
		Versión del engine que se muestra en el contador de FPS.
		OJO: se define acá a mano, NO se lee del project.xml,
		para que siempre coincida con lo que se muestra en el Main Menu.
	**/
	public static var engineVersion:String = "1.5";

	/**
		Texto extra que se le pega al final de la versión, ej: "(Beta)"
		Dejalo en "" si no querés nada ahí
	**/
	public static var engineTag:String = "(Beta)";

	public function new(x:Float = 10, y:Float = 10, color:Int = 0x000000)
	{
		super();

		this.x = x;
		this.y = y;

		currentFPS = 0;
		selectable = false;
		mouseEnabled = false;
		defaultTextFormat = new TextFormat("_sans", 14, color);
		autoSize = LEFT;
		multiline = true;
		text = "FPS: ";

		times = [];
	}

	var deltaTimeout:Float = 0.0;

	// Event Handlers
	private override function __enterFrame(deltaTime:Float):Void
	{
		final now:Float = haxe.Timer.stamp() * 1000;
		times.push(now);
		while (times[0] < now - 1000) times.shift();
		// prevents the overlay from updating every frame, why would you need to anyways @crowplexus
		if (deltaTimeout < 50) {
			deltaTimeout += deltaTime;
			return;
		}

		currentFPS = times.length < FlxG.updateFramerate ? times.length : FlxG.updateFramerate;		
		updateText();
		deltaTimeout = 0.0;
	}

	public dynamic function updateText():Void { // so people can override it in hscript
		text = 'FPS: ${currentFPS}'
		+ '\nMemory: ${flixel.util.FlxStringUtil.formatBytes(memoryMegas)}'
		+ '\n${getEngineVersionString()}'
		+ '\nOS: ${getOSString()}';

		textColor = 0xFFFFFFFF;
		if (currentFPS < FlxG.drawFramerate * 0.5)
			textColor = 0xFFFF0000;
	}

	/**
		Arma el texto "FrameCore Engine v1.0 (Beta)" usando la
		versión hardcodeada en engineVersion (NO lee project.xml).
	**/
	public static function getEngineVersionString():String
	{
		var result:String = '${engineName} v${engineVersion}';
		if (engineTag != null && engineTag.length > 0)
			result += ' ${engineTag}';

		return result;
	}

	/**
		Devuelve el nombre del sistema operativo (ej: "Windows 8.1", "Mac OS X 10.15", "Linux")
		usando Capabilities.os de OpenFL, que ya trae el detalle de versión en Windows.
	**/
	public static function getOSString():String
	{
		var os:String = Capabilities.os;
		return (os != null && os.length > 0) ? os : "Unknown";
	}

	inline function get_memoryMegas():Float
		return cpp.vm.Gc.memInfo64(cpp.vm.Gc.MEM_INFO_USAGE);
}
