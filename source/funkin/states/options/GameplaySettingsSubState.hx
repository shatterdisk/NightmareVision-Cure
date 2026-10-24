package funkin.states.options;

import flixel.FlxG;

class GameplaySettingsSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Gameplay Settings';
		rpcTitle = 'Gameplay Settings Menu'; // for Discord Rich Presence
		
		var option:Option = new Option('Mechanics', 'Check this if you want to enable mechanics!', 'mechanics', BOOL, true);
		addOption(option);
		
		var option:Option = new Option('Modcharts', 'Check this if you want to enable modcharts!', 'modcharts', BOOL, true);
		addOption(option);
		
		// I'd suggest using "Downscroll" as an example for making your own option since it is the simplest here
		var option:Option = new Option('Downscroll', // Name
			'If checked, notes go Down instead of Up, simple enough.', // Description
			'downScroll', // Save data variable name
			BOOL, // Variable type
			false); // Default value
		addOption(option);
		
		// var option:Option = new Option('Middlescroll', '[IS NOT FUNCTIONAL AS OF NOW]\nIf checked, your notes get centered.', 'middleScroll', 'bool', false);
		// addOption(option);
		
		var option:Option = new Option('Ghost Tapping', "If checked, you won't get misses from pressing keys\nwhile there are no notes able to be hit.", 'ghostTapping', BOOL, true);
		addOption(option);
		
		var option:Option = new Option('Disable Reset Button', "If checked, pressing Reset won't do anything.", 'noReset', BOOL, false);
		addOption(option);
		
		var option:Option = new Option('Hitsound Volume', 'Funny notes does \"Tick!\" when you hit them."', 'hitsoundVolume', PERCENT, 0);
		addOption(option);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		option.onChange = onChangeHitsoundVolume;
		
		super();
	}
	
	function onChangeHitsoundVolume()
	{
		FlxG.sound.play(Paths.sound('hitsound'), ClientPrefs.hitsoundVolume);
	}
	
	function addHitWindowOption(dName:String, prefID:String, min:Float = 15.0, max:Float = 200.0, scrollSpeed:Float = 15)
	{
		var option:Option = new Option('$dName Hit Window', 'Changes the amount of time you have\nfor hitting a "$dName" in milliseconds.', prefID, FLOAT, max);
		option.displayFormat = '%vms';
		option.scrollSpeed = scrollSpeed;
		option.minValue = min;
		option.maxValue = max;
		option.changeValue = 0.1;
		addOption(option);
	}
}
