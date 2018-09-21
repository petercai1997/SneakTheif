package;

import flash.filters.ColorMatrixFilter;
import flash.geom.Matrix;
import flash.geom.Point;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;


using flixel.util.FlxSpriteUtil;

class ExamineHUD extends FlxTypedGroup<FlxSprite>
{
	
	var _sprBack:FlxSprite;	// this is the background sprite

	var _alpha:Float = 0;	// we will use this to fade in and out our combat hud
	var _wait:Bool = true;	// this flag will be set to true when don't want the player to be able to do anything (between turns)
	var _player:Player;
	var _spr:FlxSprite;
	var _text:FlxText;
	var _dialog:Dialog;

	var _invGraphics:FlxTypedGroup<Entity>;
	public function new() 
	{
		super();
		
		// _sprScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT);
		// var waveEffect = new FlxWaveEffect(FlxWaveMode.ALL, 4, -1, 4);
		// var waveSprite = new FlxEffectSprite(_sprScreen, [waveEffect]);
		// add(waveSprite);
		
		// first, create our background. Make a black square, then draw borders onto it in white. Add it to our group.
		_sprBack = new FlxSprite().makeGraphic(200, 120, FlxColor.WHITE);
		_sprBack.drawRect(1, 1, 198, 58, FlxColor.BLACK);
		_sprBack.drawRect(1, 60, 198, 58, FlxColor.BLACK);
		_sprBack.screenCenter();
		add(_sprBack);
		
		_dialog=new Dialog();
		
		_spr=new FlxSprite(_sprBack.x +90, _sprBack.y +40, AssetPaths.coin__png);
		_text=new FlxText(_sprBack.x +90, _sprBack.y +70, 0, "some texts"+"                               ", 8);
		_text.wordWrap=true;
		_spr.screenCenter();
		add(_spr);
		add(_text);
		
		forEach(function(spr:FlxSprite)
		{
			spr.scrollFactor.set();
			spr.alpha = 0;
		});
		
		active = false;
		visible = false;
	}
	
	
	public function init(P:Player, ?C:Entity = null, ?invPop:Bool = false, ?choiceInv:FlxTypedGroup<Entity> = null):Void
	{
		if(_dialog.lines.exists(C._name)){
			_text.text=new Dialog().lines.get(C._name)[0];
			_spr.loadGraphic(AssetPaths.LivingRoomWallsWriting__png, false);
		}
		else if(invPop){
			_invGraphics = choiceInv; 
			_text.text = _invGraphics.members[0]._name; 
		}
		else{
			_spr.loadGraphicFromSprite(C);
			_text.text=C._name;
		}
		_text.offset.set(_text.width/2,0);
		_spr.screenCenter();
		_spr.y-=_spr.height/2+4;
		_player=P;
		_player.active=false;

		FlxTween.num(0, 1, .33, { ease: FlxEase.circOut, onComplete: finishFadeIn }, updateAlpha);
		visible = true;
	}
	
	/**
	 * This function is called by our Tween to fade in/out all the items in our hud.
	 */
	function updateAlpha(Value:Float):Void
	{
		_alpha = Value;
		forEach(function(spr:FlxSprite)
		{
			spr.alpha = _alpha;
		});
		_invGraphics.forEach(function(spr:Entity)
		{
			spr.alpha = _alpha;
		});
	}
	
	/**
	 * When we've finished fading in, we set our hud to active (so it gets updates), and allow the player to interact. We show our pointer, too.
	 */
	function finishFadeIn(_):Void
	{
		active = true;
		_wait = false;
	}
	

	
	override public function update(elapsed:Float):Void 
	{
		if(FlxG.keys.anyJustReleased([J,ONE,TWO,THREE])){
			active = false;
			visible = false;
			_player.active=true;
		}

		super.update(elapsed);

	}
	
}
