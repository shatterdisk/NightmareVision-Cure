package funkin.game;

import flixel.util.FlxStringUtil;

import funkin.objects.note.*;

typedef Rating =
{
	var name:String;
	var hitWindow:Float; // ms to hit
	var ratingMod:Float; // accuracy mod
	var score:Int;
	var noteSplash:Bool;
}

class Timings
{
    // fix later
	public static var ratings:Array<String> = ["sick", "good", "bad", "shit"];
	
	public static var timings:Map<String, Rating> = [
		"sick" =>
		{
			name: "sick",
			hitWindow: 45,
			ratingMod: 1.0,
			score: 350,
			noteSplash: true
		},
		"good" =>
		{
			name: "good",
			hitWindow: 90,
			ratingMod: 0.75,
			score: 200,
			noteSplash: false
		},
		"bad" =>
		{
			name: "bad",
			hitWindow: 135,
			ratingMod: 0.25,
			score: 100,
			noteSplash: false
		},
		"shit" =>
		{
			name: "shit",
			hitWindow: 160,
			ratingMod: 0,
			score: 50,
			noteSplash: false
		}
	];
	
	public static function judgeNote(note:Note, diff:Float = 0):Rating
	{
		switch (note.noteType)
		{
			default:
				return judgeTime(diff);
		}
	}
	
	public static function judgeTime(diff:Float = 0):Rating
	{
		var timing = timings.get("shit");
		if (diff < timing.hitWindow)
		{
			for (key => data in timings)
			{
				if (data.hitWindow > timing.hitWindow) continue;
				if (diff > data.hitWindow) continue;
				timing = data;
			}
		}
		return timing;
	}
	
	public static function toString(rating:Rating):String
	{
		return FlxStringUtil.getDebugString([
			LabelValuePair.weak("name", rating.name),
			LabelValuePair.weak("hitWindow", rating.hitWindow),
			LabelValuePair.weak("ratingMod", rating.ratingMod),
			LabelValuePair.weak("score", rating.score)
		]);
	}
	
	public static function increase(rating:Rating, blah:Int = 1)
	{
		var counter = rating.name + "s";
		Reflect.setField(PlayState.instance, counter, Reflect.field(PlayState.instance, counter) + blah);
	}
}
