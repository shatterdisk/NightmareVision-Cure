package funkin.states.options;

import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxSprite;

import funkin.backend.DebugDisplay;

class GraphicsSettingsSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Graphics';
		rpcTitle = 'Graphics Settings Menu'; // for Discord Rich Presence
		
		// window size
        var option:Option = new Option("Window Size", "Scale the window up or down idk", 'windowSize', STRING, "1x", ["0.5x", "0.67x", "0.75x", "0.8x", "0.9x", "1x", "1.25x", "1.5x", "2x", "3x"]);
		addOption(option);
		option.onChange = funkin.utils.WindowUtil.resetWindow;
		
		var option:Option = new Option('Framerate', "Pretty self explanatory, isn't it?", 'framerate', INT, 60);
		addOption(option);
		
		option.minValue = 60;
		option.maxValue = 400;
		option.displayFormat = '%v FPS';
		option.onChange = onChangeFramerate;
		
		var option:Option = new Option('Unlocked Framerate', "Pretty self explanatory, isn't it?", 'unlockedFramerate', 'bool', false);
		addOption(option);
		
		option.onChange = onChangeFramerate;
		
		var option:Option = new Option("VSync Mode", "Syncs the games Fps to your monitors refresh rate to prevent screen tearing", 'vsyncMode', STRING, 'Off', ['Off', 'On', 'Adaptive']);
		addOption(option);
		option.onChange = ClientPrefs.refreshVSyncMode;
		
		var option:Option = new Option('Anti-Aliasing', 'If unchecked, disables anti-aliasing, increases performance\nat the cost of sharper visuals.', 'globalAntialiasing', BOOL, true);
		option.onChange = onChangeAntiAliasing; // Changing onChange is only needed if you want to make a special interaction after it changes the value
		addOption(option);
		
		var option:Option = new Option('Shaders', 'If checked, shaders will be enabled across the mod', 'shaders', BOOL, true);
		addOption(option);
		
		var option:Option = new Option('Low Quality', // Name
			'If checked, disables some background details,\ndecreases loading times and improves performance.', // Description
			'lowQuality', // Save data variable name
			'bool', // Variable type
			false); // Default value
		addOption(option);
		
		var option:Option = new Option('GPU Caching', 'If checked, GPU caching will be enabled.', 'gpuCaching', BOOL, false);
		addOption(option);
		
		super();
	}
	
	function onChangeAntiAliasing()
	{
		for (sprite in members)
		{
			if (sprite != null && (sprite is FlxSprite) && !(sprite is FlxText))
			{
				(cast sprite : FlxSprite).antialiasing = ClientPrefs.globalAntialiasing;
			}
		}
		
		FlxSprite.defaultAntialiasing = ClientPrefs.globalAntialiasing;
	}
	
	function onChangeFramerate()
	{
		ClientPrefs.changeFps(ClientPrefs.framerate);
	}
}
