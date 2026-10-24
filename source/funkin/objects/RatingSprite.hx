package funkin.objects;

import funkin.game.Timings;

class RatingSprite extends FlxSprite
{
	// fit between notes
	public var baseScale:Float = 0.49;
	public var ratingTween:FlxTween;
	
	public function new(assetPath:String)
	{
		super();
		var ratingArray = Timings.ratings;
		var ratingGraph = Paths.image(assetPath);
		loadGraphic(ratingGraph, true, Math.floor(ratingGraph.width), Math.floor(ratingGraph.height / 4));
		for (i in 0...ratingArray.length)
			animation.add(ratingArray[i], [i], 0, false);
			
		scale.x = baseScale;
		scale.y = baseScale;
		updateHitbox();
		alpha = 0;
	}
	
	public function playRating(rating:String)
	{
		animation.play(rating);
		scale.set(baseScale * 1.2, baseScale * 1.2);
		alpha = 1;
		stopTween();
		ratingTween = FlxTween.tween(this, {alpha: 0}, 0.5, {startDelay: 0.7});
	}
	
	public function stopTween()
	{
		if (ratingTween != null) ratingTween.cancel();
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		scale.x = MathUtil.decayLerp(scale.x, baseScale, 9, elapsed);
		scale.y = MathUtil.decayLerp(scale.x, baseScale, 9, elapsed);
	}
}

class ComboSprite extends FlxSprite
{
	// fit between notes
	public var baseScale:Float = 0.34;
	public var comboTween:FlxTween;
	public var lastNum:String = "";
	
	public function new(assetPath:String)
	{
		super();
		var numberGraph = Paths.image(assetPath);
		loadGraphic(numberGraph, true, Math.floor(numberGraph.width / 11), Math.floor(numberGraph.height));
		for (i in 0...11)
			animation.add((i <= 9 ? '$i' : "-"), [i], 0, false);
			
		scale.x = baseScale;
		scale.y = baseScale;
		updateHitbox();
		alpha = 0;
	}
	
	public function playCombo(num:String)
	{
		animation.play(num);
		alpha = 1;
		stopTween();
		comboTween = FlxTween.tween(this, {alpha: 0}, 0.5, {startDelay: 0.7});
		lastNum = num;
	}
	
	public function stopTween()
	{
		if (comboTween != null) comboTween.cancel();
	}
}
