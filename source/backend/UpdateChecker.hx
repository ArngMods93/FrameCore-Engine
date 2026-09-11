package backend;

#if CHECK_FOR_UPDATES
import haxe.Http;
import haxe.Json;
#if sys
import sys.thread.Thread;
#end
#end

/**
 * Checks the FrameCore Engine GitHub repo for a newer release than
 * the one currently running, and lets MainMenuState know once it's done.
 *
 * Only does anything on desktop + officialBuild (CHECK_FOR_UPDATES define)
 * and only if the player has "Check for Updates" turned on in Options.
 *
 * The actual HTTP request runs on a background thread so it can NEVER
 * freeze the main menu, even if the player has no internet or GitHub
 * takes forever to respond.
 */
class UpdateChecker
{
	static inline var API_URL:String = 'https://api.github.com/repos/ArngMods93/FrameCore-Engine/releases/latest';

	public static var checked(default, null):Bool = false;
	public static var updateAvailable(default, null):Bool = false;
	public static var latestVersion(default, null):String = null;

	/**
	 * Kicks off the check in the background. Safe to call even if
	 * CHECK_FOR_UPDATES isn't defined or the pref is off - it'll just no-op.
	 * `currentVersion` should be something like "1.5-beta-fix3".
	 */
	public static function check(currentVersion:String):Void
	{
		#if CHECK_FOR_UPDATES
		if (checked || !ClientPrefs.data.checkForUpdates)
			return;

		#if sys
		Thread.create(() -> doRequest(currentVersion));
		#else
		doRequest(currentVersion);
		#end
		#end
	}

	#if CHECK_FOR_UPDATES
	static function doRequest(currentVersion:String):Void
	{
		var http = new Http(API_URL);
		http.onData = function(data:String)
		{
			try
			{
				var json:Dynamic = Json.parse(data);
				var tag:String = json.tag_name;
				if (tag != null && tag.length > 0)
				{
					if (tag.charAt(0) == 'v' || tag.charAt(0) == 'V')
						tag = tag.substr(1);

					latestVersion = tag;
					updateAvailable = (tag != currentVersion);
				}
			}
			catch (e:Dynamic)
			{
				trace('UpdateChecker: couldn\'t read GitHub response - $e');
			}
			checked = true;
		};
		http.onError = function(error:String)
		{
			trace('UpdateChecker: request failed - $error');
			checked = true; // don't keep retrying every time you open the menu
		};
		http.request(false);
	}
	#end
}
