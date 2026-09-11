package backend;

import flixel.FlxG;
import openfl.filters.ColorMatrixFilter;

class ColorAccessibility {
	public static var options:Array<String> = [
		'None',
		'Protanopia',
		'Protanomaly',
		'Deuteranopia',
		'Deuteranomaly',
		'Tritanopia',
		'Tritanomaly',
		'Achromatopsia',
		'Achromatomaly'
	];

	public static function apply(mode:String) {
		#if !flash
		var matrix:Array<Float> = getMatrixForMode(mode);

		if (matrix == null || mode == 'None' || mode == null) {
			FlxG.game.setFilters([]);
		} else {
			var filter = new ColorMatrixFilter(matrix);
			FlxG.game.setFilters([filter]);
		}
		#end
	}

	private static function getMatrixForMode(mode:String):Array<Float> {
		return switch (mode) {
			case 'Protanopia':
				[
					0.56667, 0.43333, 0.00000, 0, 0,
					0.55833, 0.44167, 0.00000, 0, 0,
					0.00000, 0.24167, 0.75833, 0, 0,
					0.00000, 0.00000, 0.00000, 1, 0
				];
			case 'Protanomaly':
				[
					0.81667, 0.18333, 0.00000, 0, 0,
					0.33333, 0.66667, 0.00000, 0, 0,
					0.00000, 0.12500, 0.87500, 0, 0,
					0.00000, 0.00000, 0.00000, 1, 0
				];
			case 'Deuteranopia':
				[
					0.62500, 0.37500, 0.00000, 0, 0,
					0.70000, 0.30000, 0.00000, 0, 0,
					0.00000, 0.30000, 0.70000, 0, 0,
					0.00000, 0.00000, 0.00000, 1, 0
				];
			case 'Deuteranomaly':
				[
					0.80000, 0.20000, 0.00000, 0, 0,
					0.25833, 0.74167, 0.00000, 0, 0,
					0.00000, 0.14167, 0.85833, 0, 0,
					0.00000, 0.00000, 0.00000, 1, 0
				];
			case 'Tritanopia':
				[
					0.95000, 0.05000, 0.00000, 0, 0,
					0.00000, 0.43333, 0.56667, 0, 0,
					0.00000, 0.47500, 0.52500, 0, 0,
					0.00000, 0.00000, 0.00000, 1, 0
				];
			case 'Tritanomaly':
				[
					0.96667, 0.03333, 0.00000, 0, 0,
					0.00000, 0.73333, 0.26667, 0, 0,
					0.00000, 0.18333, 0.81667, 0, 0,
					0.00000, 0.00000, 0.00000, 1, 0
				];
			case 'Achromatopsia':
				[
					0.29900, 0.58700, 0.11400, 0, 0,
					0.29900, 0.58700, 0.11400, 0, 0,
					0.29900, 0.58700, 0.11400, 0, 0,
					0.00000, 0.00000, 0.00000, 1, 0
				];
			case 'Achromatomaly':
				[
					0.61800, 0.32000, 0.06200, 0, 0,
					0.16300, 0.77500, 0.06200, 0, 0,
					0.16300, 0.32000, 0.51600, 0, 0,
					0.00000, 0.00000, 0.00000, 1, 0
				];
			default: null;
		}
	}
}