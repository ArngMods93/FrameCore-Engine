package options;

import objects.Character;

class GraphicsSettingsSubState extends BaseOptionsMenu
{
	var antialiasingOption:Int;
	var boyfriend:Character = null;
	public function new()
	{
		title = Language.getPhrase('graphics_menu', 'Graphics Settings');
		rpcTitle = 'Graphics Settings Menu'; //for Discord Rich Presence

		boyfriend = new Character(840, 170, 'bf', true);
		boyfriend.setGraphicSize(Std.int(boyfriend.width * 0.75));
		boyfriend.updateHitbox();
		boyfriend.dance();
		boyfriend.animation.finishCallback = function (name:String) boyfriend.dance();
		boyfriend.visible = false;

		//I'd suggest using "Low Quality" as an example for making your own option since it is the simplest here
		var option:Option = new Option('Low Quality', //Name
			'If checked, disables some background details,\ndecreases loading times and improves performance.', //Description
			'lowQuality', //Save data variable name
			BOOL); //Variable type
		addOption(option);

		var option:Option = new Option('Anti-Aliasing',
			'If unchecked, disables anti-aliasing, increases performance\nat the cost of sharper visuals.',
			'antialiasing',
			BOOL);
		option.onChange = onChangeAntiAliasing; //Changing onChange is only needed if you want to make a special interaction after it changes the value
		addOption(option);
		antialiasingOption = optionsArray.length-1;

		var option:Option = new Option('Shaders', //Name
			"If unchecked, disables shaders.\nIt's used for some visual effects, and also CPU intensive for weaker PCs.", //Description
			'shaders',
			BOOL);
		addOption(option);

		var option:Option = new Option('GPU Caching', //Name
			"If checked, allows the GPU to be used for caching textures, decreasing RAM usage.\nDon't turn this on if you have a shitty Graphics Card.", //Description
			'cacheOnGPU',
			BOOL);
		addOption(option);

		var option:Option = new Option('Colorblind Filter',
			'Applies a colorblindness simulation filter to the whole screen.',
			'colorblindMode',
			STRING,
			backend.ColorAccessibility.options);
		option.onChange = onChangeColorblind;
		addOption(option);

		#if !html5 //Apparently other framerates isn't correctly supported on Browser? Probably it has some V-Sync shit enabled by default, idk
		var option:Option = new Option('Framerate',
			"Pretty self explanatory, isn't it?",
			'framerate',
			INT);
		addOption(option);

		final refreshRate:Int = FlxG.stage.application.window.displayMode.refreshRate;
		option.minValue = 60;
		option.maxValue = 240;
		option.defaultValue = Std.int(FlxMath.bound(refreshRate, option.minValue, option.maxValue));
		option.displayFormat = '%v FPS';
		option.onChange = onChangeFramerate;
		#end

		var option:Option = new Option('TPS Mode',
			"How the game logic's updates.\nSync: 1 tick per frame (classic).\nFixed: Fixed TPS.\nDynamic: Adjusts automatically, It depends off framerate.",
			'tpsMode',
			STRING,
			['Sync', 'Fixed', 'Dynamic']);
		addOption(option);

		var option:Option = new Option('Fixed TPS',
			'Change TPS manually when TPS mode is Fixed.',
			'tpsFixed',
			INT);
		option.minValue = backend.TPSMode.MIN_TPS;
		option.maxValue = backend.TPSMode.MAX_TPS;
		option.defaultValue = 60;
		option.displayFormat = '%v TPS';
		addOption(option);

		var option:Option = new Option('Dynamic TPS (Min)',
			'Minium TPS when TPS mode is dynamic.',
			'tpsDynamicMin',
			INT);
		option.minValue = backend.TPSMode.MIN_TPS;
		option.maxValue = backend.TPSMode.MAX_TPS;
		option.defaultValue = 60;
		option.displayFormat = '%v TPS';
		addOption(option);

		var option:Option = new Option('Dynamic TPS (Max)',
			'Maximum TPS when TPS mode is dynamic.',
			'tpsDynamicMax',
			INT);
		option.minValue = backend.TPSMode.MIN_TPS;
		option.maxValue = backend.TPSMode.MAX_TPS;
		option.defaultValue = 240;
		option.displayFormat = '%v TPS';
		addOption(option);

		var option:Option = new Option('Show TPS',
			'If checked, it displays the actual TPS below the FPS counter.',
			'showTPS',
			BOOL);
		addOption(option);

		super();
		insert(1, boyfriend);
	}

	function onChangeAntiAliasing()
	{
		for (sprite in members)
		{
			var sprite:FlxSprite = cast sprite;
			if(sprite != null && (sprite is FlxSprite) && !(sprite is FlxText)) {
				sprite.antialiasing = ClientPrefs.data.antialiasing;
			}
		}
	}

	function onChangeColorblind()
	{
		backend.ColorAccessibility.apply(ClientPrefs.data.colorblindMode);
	}

	function onChangeFramerate()
	{
		if(ClientPrefs.data.framerate > FlxG.drawFramerate)
		{
			FlxG.updateFramerate = ClientPrefs.data.framerate;
			FlxG.drawFramerate = ClientPrefs.data.framerate;
		}
		else
		{
			FlxG.drawFramerate = ClientPrefs.data.framerate;
			FlxG.updateFramerate = ClientPrefs.data.framerate;
		}
	}

	override function changeSelection(change:Int = 0)
	{
		super.changeSelection(change);
		boyfriend.visible = (antialiasingOption == curSelected);
	}
}