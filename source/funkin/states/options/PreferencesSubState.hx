package funkin.states.options;

import funkin.states.options.Option;

import flixel.FlxG;

class PreferencesSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Preferences';
		rpcTitle = 'Preferences Settings Menu'; // for Discord Rich Presence
		
		var option:Option = new Option('Flashing Lights', "Uncheck this if you're sensitive to flashing lights!", 'flashing', BOOL, true);
		addOption(option);
		
		var option:Option = new Option('FPS Counter',
			'Handles what type of information to display in the top left of your screen.\nSimple displays FPS & Memory, and advanced displays the same alongside debug information.\nDisabled disables the counter entirely.',
			'fpsDisplayType', STRING, 'Simple', ['Simple', 'Advanced', 'Disabled']);
		addOption(option);
		
		var option:Option = new Option('Underlay Type:', "What should the lane underlay do?", 'underlayType', STRING, 'Lane Underlay', UnderlayType.toArray());
		addOption(option);
		
		var option:Option = new Option('Underlay Transparency', 'How much transparent should the health bar and icons be.', 'underlayOpacity', PERCENT, 0);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		addOption(option);
		
		var pause:Option = new Option("Auto-Pause Game",
			'If checked, the game will automatically freeze when unselected, pausing all sounds and visuals. If unchecked, the game will continue as normal regardless of focus.', 'autoPause', BOOL,
			false);
		pause.onChange = () -> {
			FlxG.autoPause = ClientPrefs.autoPause;
		};
		addOption(pause);
		
		var discordOption:Option = new Option('Discord Rich Presence',
			"If checked, It will show what you are currently playing on your Discord profile. Disable this if you don't want accidental leaks.", 'discordEnabled', BOOL, true);
		discordOption.onChange = DiscordClient.restart;
		addOption(discordOption);
		
		var option:Option = new Option('Streamed Song files',
			'If checked, playable song files will be streamed via bytes instead of being loaded all at once. This heavily improves loading times, however it is EXTREMELY EXPERIMENTAL and prone to issues.',
			'streamedMusic', BOOL, false);
		addOption(option);
		
		var option:Option = new Option('Dev Mode', "If checked, traces & developer hotkeys will become available.", 'inDevMode', BOOL, false);
		addOption(option);
		
		super();
	}
}
