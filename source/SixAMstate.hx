package;

#if desktop
import Discord.DiscordClient;
import sys.thread.Thread;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.keyboard.FlxKey;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import haxe.Json;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end
import options.GraphicsSettingsSubState;
//import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxFrame;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import openfl.Assets;
import flixel.math.FlxRandom;
import flixel.util.FlxTimer;
import flixel.util.FlxSave;
#if !flash 
import flixel.addons.display.FlxRuntimeShader;
import openfl.filters.ShaderFilter;
#end

using StringTools;

class SixAMstate extends MusicBeatState
{
	public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];
	public static var initialized:Bool = false;
	public static var closedState:Bool = false;
	var curWacky:Array<String> = [];
	var warningBG:FlxSprite;
	var blackBG:FlxSprite;
	var assets:Array<String>=[];
	var randomInt:Int;
	var backgroundSprite:FlxSprite;
	var logoBl:FlxSprite;
	var bars:FlxSprite;
	var pressStartSprite:FlxSprite;
	var inicio:Bool=false;
	var antiperu2:Bool=false;

	override public function create():Void
	{	
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();
	
		#if LUA_ALLOWED
		Paths.pushGlobalMods();
		#end

		WeekData.loadTheFirstEnabledMod();
	
		FlxG.game.focusLostFramerate = 60;
		FlxG.sound.muteKeys = muteKeys;
		FlxG.sound.volumeDownKeys = volumeDownKeys;
		FlxG.sound.volumeUpKeys = volumeUpKeys;
		FlxG.keys.preventDefaultKeys = [TAB];
	
		PlayerSettings.init();
	
		FlxG.save.bind('funkin', 'ninjamuffin99');
		ClientPrefs.loadPrefs();
		Highscore.load();
		if(FlxG.save.data.antiperu2 != null) {
			antiperu2 = FlxG.save.data.antiperu2;
		}

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('bgPlayTime'));
		bg.scale.set(0.68,0.68);
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);
		bg.color = 0x484848;

		if(antiperu2 == true) { // no te olvides de cambiarlo manuel no te olvides de cambiarlo manuel no te olvides de cambiarlo manuel no te olvides de cambiarlo manuel no te olvides de cambiarlo manuel
			var huggylel:FlxSprite= new FlxSprite().loadGraphic(Paths.image('golden_huggy'));
			huggylel.scale.set(0.22,0.22);
			huggylel.screenCenter();
			huggylel.y-=80;
			var tweenlel:Float = huggylel.y;
			huggylel.y+=420;
			FlxTween.tween(huggylel, {y: tweenlel }, 1.2, {ease: FlxEase.quintOut});
			huggylel.antialiasing = ClientPrefs.globalAntialiasing;
			add(huggylel);

			var coso:FlxText = new FlxText(12, FlxG.height - 44, 0, "Ollie:", 12);
			coso.setFormat("VCR OSD Mono", 40, FlxColor.GREEN, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			coso.screenCenter();
			coso.y+=240;
			coso.antialiasing = ClientPrefs.globalAntialiasing;
			add(coso);

			var coso2:FlxText = new FlxText(12, FlxG.height - 44, 0, "\n¡You did it! Get this reward i found, a little prize.", 12);
			coso2.setFormat("VCR OSD Mono", 40, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			coso2.screenCenter();
			coso2.y+=280;
			coso2.antialiasing = ClientPrefs.globalAntialiasing;
			add(coso2);
		}
		if(!inicio)
		{
			persistentUpdate = true;
			persistentDraw = true;
			#if desktop
			if (!DiscordClient.isInitialized)
			{
				DiscordClient.initialize();
				Application.current.onExit.add (function (exitCode) {
					DiscordClient.shutdown();
				});
			}
			#end
		}
		/*
		if(antiperu2 == true) {
			new FlxTimer().start(0.2, function(tmr:FlxTimer)
			{
				MusicBeatState.switchState(new TitleState());
			});
		}
		*/
		super.create();
	}	
	var titleInicied:Bool=false;
	var iTime:Float;
	override function update(elapsed:Float)
	{
		iTime += elapsed;
		FlxG.camera.zoom= FlxMath.lerp(1, FlxG.camera.zoom,0.85);
			if (controls.ACCEPT&&!titleInicied && antiperu2 == true){ //manelmanelmanelmanelmanelmanelmanelmanelmanelmanelmanel
				antiperu2 = true;
				FlxG.save.data.antiperu2 = antiperu2;
				FlxG.save.flush();

				titleInicied=true;
				FlxG.sound.play(Paths.sound('confirmMenu'));
				FlxG.sound.play(Paths.sound('huggyfunnylaugh'));
				FlxG.camera.zoom+=0.1;
				new FlxTimer().start(1.2, function(tmr:FlxTimer)
				{
					MusicBeatState.switchState(new TitleState());
				});
			}
		super.update(elapsed);
	}
}