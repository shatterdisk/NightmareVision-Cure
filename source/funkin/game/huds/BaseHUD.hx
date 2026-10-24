package funkin.game.huds;

import flixel.group.FlxContainer.FlxTypedContainer;
import flixel.FlxBasic;

@:access(funkin.states.PlayState)
class BaseHUD extends FlxTypedContainer<FlxBasic>
{
	// keep this in caps for consistency
	public var name:String = 'BASE';
	public var healthLerp:Float = 0;
	public var healthTarget:Float = 0;
	
	public var parent:PlayState;
	
	public var curStep(get, never):Int;
	
	function get_curStep():Int return parent.curStep;
	
	public var curBeat(get, never):Int;
	
	function get_curBeat():Int return parent.curBeat;
	
	public var curSection(get, never):Int;
	
	function get_curSection():Int return parent.curSection;
	
	// ignore this
	public function new(parent:PlayState)
	{
		this.parent = parent;
		super();
		init();
	}
	
	public function init():Void {}
	
	public function onSongStart():Void {}
	
	public function stepHit():Void {}
	
	public function beatHit():Void {}
	
	public function sectionHit():Void {}
	
	public function onUpdateScore(score:Int = 0, accuracy:Float = 0, misses:Int = 0, missed:Bool = false):Void {}
	
	public function popUpScore(daRating:funkin.game.Timings.Rating, combo:Int, note:funkin.objects.note.Note):Void {}
	
	public function onEvent(ev:String, v1:String, v2:String, strumTime:Float):Void {}
	
	public function onCharacterChange() {}
	
	public function onHealthChange(health:Float)
	{
		final newPercent:Null<Float> = FlxMath.remapToRange(FlxMath.bound(health, parent.healthBounds.min, parent.healthBounds.max), parent.healthBounds.min, parent.healthBounds.max, 0, 100);
		healthTarget = (newPercent != null ? newPercent : 0);
	}
	
	public function updateHealthPercent(elapsed:Float)
	{
		healthLerp = MathUtil.decayLerp(healthLerp, healthTarget, 8, elapsed);
	}
	
	public function cachePopUpScore() {}
	
	public var alpha(default, set):Float = 1;
	
	function set_alpha(v:Float)
	{
		v = FlxMath.bound(v, 0, 1);
		for (basic in members)
		{
			if (basic != null && basic is FlxSprite) (cast basic : FlxSprite).alpha = v;
		}
		return alpha = v;
	}

    override function update(elapsed:Float)
	{
		super.update(elapsed);
        updateHealthPercent(elapsed);
    }
}
