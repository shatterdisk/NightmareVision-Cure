package funkin.game.huds;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxObject;
import flixel.util.FlxStringUtil;
import flixel.text.FlxText.FlxTextFormatMarkerPair;
import flixel.text.FlxText.FlxTextFormat;

import funkin.objects.Bar;
import funkin.objects.HealthIcon;

@:access(funkin.states.PlayState)
class CureHUD extends BaseHUD
{
	var healthBar:Bar;
	var iconP1:HealthIcon;
	var iconP2:HealthIcon;
	
	var scoreTxt:FlxText;
	var timeTxt:FlxText;
	
	var ratingGraphic:RatingSprite;
	var ratingNumGroup:FlxTypedGroup<ComboSprite>;
	
	var ratingPrefix:String = "";
	var ratingSuffix:String = '';
	var comboPrefix:String = "";
	var textDivider = '|';
	
	var alphaList:Array<FlxSprite> = [];
	
	override function init()
	{
		name = 'DOIDO';
		
		ratingPrefix = Paths.RATINGS_PREFIX;
		comboPrefix = Paths.COMBO_PREFIX;
		
		final healthGraphic = FunkinAssets.exists(Paths.mods('images/${Paths.UI_PREFIX}healthBar')) ? '${Paths.UI_PREFIX}healthBar' : 'UI/healthBar';
		
		healthBar = new Bar(0, FlxG.height * (!ClientPrefs.downScroll ? 0.89 : 0.11), healthGraphic, function() return parent.health, parent.healthBounds.min, parent.healthBounds.max);
		healthBar.screenCenter(X);
		healthBar.y = (ClientPrefs.downScroll ? 70 : FlxG.height - healthBar.bg.height - 50);
		healthBar.leftToRight = false;
		healthBar.scrollFactor.set();
		reloadHealthBarColors();
		add(healthBar);
		
		iconP1 = new HealthIcon(parent.boyfriend.healthIcon, true);
		iconP1.y = healthBar.y - 75;
		iconP1.visible = !ClientPrefs.hideHud;
		iconP1.alphaMultipler = ClientPrefs.healthBarAlpha;
		add(iconP1);
		
		iconP2 = new HealthIcon(parent.dad.healthIcon, false);
		iconP2.y = healthBar.y - 75;
		iconP2.visible = !ClientPrefs.hideHud;
		iconP2.alphaMultipler = ClientPrefs.healthBarAlpha;
		add(iconP2);
		
		scoreTxt = new FlxText(0, healthBar.y + healthBar.bg.height + 12, FlxG.width, "", 20);
		scoreTxt.setFormat(Paths.DEFAULT_FONT, 20, FlxColor.WHITE, CENTER);
		scoreTxt.setBorderStyle(OUTLINE, FlxColor.BLACK, 1.5);
		scoreTxt.scrollFactor.set();
		add(scoreTxt);
		
		timeTxt = new FlxText(0, ClientPrefs.downScroll ? FlxG.height - 44 : 19, FlxG.width, "0:00", 20);
		timeTxt.setFormat(Paths.DEFAULT_FONT, 32, FlxColor.WHITE, CENTER);
		timeTxt.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);
		timeTxt.scrollFactor.set();
		add(timeTxt);
		
		var ratingPos = ClientPrefs.downScroll ? FlxG.height - 150 : 65;
		ratingGraphic = new RatingSprite('${ratingPrefix}ratings${ratingSuffix}', ["sick", "good", "bad", "shit"]);
		ratingGraphic.alpha = 0;
		ratingGraphic.screenCenter(X);
		ratingGraphic.y = ratingPos - 15;
		add(ratingGraphic);
		
		ratingNumGroup = new FlxTypedGroup();
		add(ratingNumGroup);
		
		for (i in 0...3)
		{
			var num = new ComboSprite('${comboPrefix}numbers$ratingSuffix');
			num.alpha = 0;
			num.screenCenter(X);
			if (i == 0) num.x -= num.width - 9;
			if (i == 2) num.x += num.width - 9;
			num.y = ratingPos + 55;
			num.ID = i;
			ratingNumGroup.add(num);
		}
		
		// ?
		parent.scripts.set('healthBar', healthBar);
		parent.scripts.set('iconP1', iconP1);
		parent.scripts.set('iconP2', iconP2);
		parent.scripts.set('scoreTxt', scoreTxt);
		parent.scripts.set('timeTxt', timeTxt);
		parent.scripts.set('ratingPrefix', ratingPrefix);
		parent.scripts.set('ratingSuffix', ratingSuffix);
		parent.scripts.set('comboPrefix', comboPrefix);
		
		for (i in [scoreTxt, timeTxt, healthBar, iconP1, iconP2])
		{
			i.alpha = 0;
			alphaList.push(i);
		}
	}
	
	override function onSongStart()
	{
		for (i in alphaList)
			FlxTween.tween(i, {alpha: 1}, 0.5);
	}
	
	override function onUpdateScore(score:Int = 0, accuracy:Float = 0, misses:Int = 0, missed:Bool = false)
	{
		final tempScore:String = 'Score: ${FlxStringUtil.formatMoney(score, false)}'
			+ ' $textDivider Accuracy: ${accuracy}% [${parent.ratingFC}]'
			+ (!parent.instakillOnMiss ? ' $textDivider Misses: ${misses}' : "");
			
		scoreTxt.text = '${tempScore}\n';
	}
	
	public function updateIconsPosition()
	{
		final iconOffset:Int = 26;
		if (!healthBar.leftToRight)
		{
			iconP1.x = healthBar.barCenter + (150 * iconP1.scale.x - 150) / 2 - iconOffset;
			iconP2.x = healthBar.barCenter - (150 * iconP2.scale.x) / 2 - iconOffset * 2;
		}
		else
		{
			iconP1.x = healthBar.barCenter - (150 * iconP2.scale.x) / 2 - iconOffset * 2;
			iconP2.x = healthBar.barCenter + (150 * iconP1.scale.x - 150) / 2 - iconOffset;
		}
	}
	
	public function updateIconsScale(elapsed:Float)
	{
		final mult:Float = MathUtil.decayLerp(iconP1.scale.x, 1, 9, elapsed);
		iconP1.scale.set(mult, mult);
		iconP1.updateHitbox();
		
		final mult:Float = MathUtil.decayLerp(iconP2.scale.x, 1, 9, elapsed);
		iconP2.scale.set(mult, mult);
		iconP2.updateHitbox();
	}
	
	public function updateIconsAnimation()
	{
		iconP1.updateIconAnim(healthBar.percent * 0.01);
		iconP2.updateIconAnim((100 - healthBar.percent) * 0.01);
	}
	
	public function reloadHealthBarColors()
	{
		var dad = parent.dad;
		var boyfriend = parent.boyfriend;
		if (!healthBar.leftToRight)
		{
			healthBar.setColors(dad.healthColour, boyfriend.healthColour);
		}
		else
		{
			healthBar.setColors(boyfriend.healthColour, dad.healthColour);
		}
	}
	
	public function flipBar()
	{
		healthBar.leftToRight = !healthBar.leftToRight;
		iconP1.flipX = !iconP1.flipX;
		iconP2.flipX = !iconP2.flipX;
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		updateIconsPosition();
		updateIconsScale(elapsed);
		updateIconsAnimation();
		
		if (!parent.startingSong && !parent.paused && parent.updateTime && !parent.endingSong)
		{
			var curTime:Float = Math.max(0, Conductor.songPosition - ClientPrefs.noteOffset);
			parent.songPercent = (curTime / parent.songLength);
			
			var songCalc:Float = (parent.songLength - curTime);
			var secondsTotal:Int = Math.floor(songCalc / 1000);
			if (secondsTotal < 0) secondsTotal = 0;
			
			timeTxt.text = flixel.util.FlxStringUtil.formatTime(secondsTotal, false);
		}
	}
	
	override function beatHit()
	{
		if (parent.curBeat % 2 != 0) return;
		
		iconP1.scale.set(1.3, 1.3);
		iconP2.scale.set(1.3, 1.3);
		
		iconP1.updateHitbox();
		iconP2.updateHitbox();
	}
	
	override function onCharacterChange()
	{
		reloadHealthBarColors();
		iconP1.changeIcon(parent.boyfriend.healthIcon);
		iconP2.changeIcon(parent.dad.healthIcon);
	}
	
	override function onHealthChange(health:Float)
	{
		final newPercent:Null<Float> = FlxMath.remapToRange(FlxMath.bound(healthBar.valueFunction(), healthBar.bounds.min, healthBar.bounds.max), healthBar.bounds.min, healthBar.bounds.max, 0, 100);
		healthBar.percent = (newPercent != null ? newPercent : 0);
	}
	
	override function popUpScore(daRating:funkin.game.Rating, combo:Int, note:funkin.objects.note.Note)
	{
		final ratingImage = daRating.image;
		
		final posX = FlxG.width * 0.35;
		
		if (ClientPrefs.hideHud) return;
		
		parent.scripts.call('onPopUpScore', [note, daRating, ratingGraphic, ratingNumGroup]);
		
		ratingGraphic.playRating(daRating.image);
		var comboStr:String = '${Math.abs(combo)}'.lpad("0", 3);
		var stringArr = comboStr.split("");
		ratingNumGroup.forEachAlive((num) -> {
			num.playCombo(stringArr[num.ID]);
		});
		
		parent.scripts.call('onPopUpScorePost', [note, daRating, ratingGraphic, ratingNumGroup]);
	}
}

class RatingSprite extends FlxSprite
{
	// fit between notes
	public var baseScale:Float = 0.49;
	public var ratingTween:FlxTween;
	
	public function new(assetPath:String, ratingArray:Array<String>)
	{
		super();
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
