package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;
import flash.system.System;
import flixel.util.FlxTimer;
import options.GraphicsSettingsSubState;
import openfl.Lib;
#if !flash 
import flixel.addons.display.FlxRuntimeShader;
import openfl.filters.ShaderFilter;
#end

#if sys
import sys.FileSystem;
import sys.io.File;
#end
using StringTools;

class SixAMstate extends MusicBeatState
{
	var blackBG:FlxSprite;
	var logoBl:FlxSprite;
	var antiperu2:Bool=false;
	var bg:FlxSprite;	
	var huggylel:FlxSprite;
	var coso:FlxText;
	var shader:String='desaturate';
	var shaderD:FlxRuntimeShader;
	var negro1:FlxSprite;
	var negro2:FlxSprite;
	override public function create():Void
	{	
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();
	
		#if LUA_ALLOWED
		Paths.pushGlobalMods();
		#end

		WeekData.loadTheFirstEnabledMod();
	
		FlxG.game.focusLostFramerate = 60;
		FlxG.keys.preventDefaultKeys = [TAB];
		ClientPrefs.loadPrefs();
		if(FlxG.save.data.antiperu2 != null) {
			antiperu2 = FlxG.save.data.antiperu2;
		}

		persistentUpdate = persistentDraw = true;

		blackBG = new FlxSprite();
		blackBG.makeGraphic(FlxG.width,FlxG.height,FlxColor.BLACK);
		blackBG.screenCenter();
		blackBG.antialiasing = ClientPrefs.globalAntialiasing;
		add(blackBG);

		bg = new FlxSprite(-80).loadGraphic(Paths.image('bgPlayTime'));
		bg.scale.set(0.68,0.68);
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		var bgBlack:FlxSprite=new FlxSprite().makeGraphic(FlxG.width,FlxG.height,FlxColor.BLACK);
		add(bgBlack);
		bgBlack.alpha=0.4;
		shaderD = new FlxRuntimeShader(File.getContent(Paths.shaderFragment(shader)));
		bg.shader=shaderD;
		if(FlxG.sound.music == null) {
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
		}
		if(antiperu2 == true) {
			bg.visible = false;
			MusicBeatState.switchState(new MainMenuState());
		}
		if(antiperu2 == false) {
		    huggylel= new FlxSprite().loadGraphic(Paths.image('golden_huggy'));
			huggylel.scale.set(0.22,0.22);
			huggylel.screenCenter();
			huggylel.y-=80;
			var tweenlel:Float = huggylel.y;
			huggylel.y+=420;
			FlxTween.tween(huggylel, {y: tweenlel }, 1.2, {ease: FlxEase.quintOut});
			huggylel.antialiasing = ClientPrefs.globalAntialiasing;
			add(huggylel);
			
			negro2= new FlxSprite(12).makeGraphic(FlxG.height+220,32,FlxColor.BLACK);
			negro2.screenCenter();
			negro2.y+=306;
			negro2.alpha=0.72;
			add(negro2);

			coso = new FlxText(12, FlxG.height - 44, 0, "Ollie:", 12);
			coso.setFormat("VCR OSD Mono", 25, FlxColor.GREEN, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			coso.screenCenter();
			coso.x-=400;
			coso.y+=305;
			coso.antialiasing = ClientPrefs.globalAntialiasing;
			add(coso);

			var coso2:FlxText = new FlxText(12, FlxG.height - 44, 0, "\n¡You did it! Get this reward i found, a little prize.", 12);
			coso2.setFormat("VCR OSD Mono", 25, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			coso2.screenCenter();
			coso2.setPosition(coso.x+100,630);
			coso2.antialiasing = ClientPrefs.globalAntialiasing;
			add(coso2);
		}
		super.create();
	}	
	var titleInicied:Bool=false;
	var iTime:Float;
	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null) Conductor.songPosition = FlxG.sound.music.time;
		iTime += elapsed;
		shaderD.setFloat("iTime", iTime);
	
		FlxG.camera.zoom= FlxMath.lerp(1, FlxG.camera.zoom,0.85);
			if (controls.ACCEPT&&!titleInicied && antiperu2 == false){
				antiperu2 = true;
				FlxG.save.data.antiperu2 = antiperu2;
				FlxG.save.flush();

				titleInicied=true;
				FlxG.sound.play(Paths.sound('confirmMenu'));
				FlxG.sound.play(Paths.sound('huggyfunnylaugh'));
				FlxG.camera.zoom+=0.1;
				new FlxTimer().start(1.2, function(tmr:FlxTimer)
				{
					MusicBeatState.switchState(new MainMenuState());
				});
			}
		super.update(elapsed);
	}
}