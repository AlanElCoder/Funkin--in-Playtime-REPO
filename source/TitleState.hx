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
#if !flash 
import flixel.addons.display.FlxRuntimeShader;
import openfl.filters.ShaderFilter;
#end

using StringTools;

class TitleState extends MusicBeatState
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

	var vcrShader:FlxRuntimeShader;
	var shader1:FlxRuntimeShader;
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

		//
		blackBG = new FlxSprite();
		blackBG.makeGraphic(FlxG.width,FlxG.height,FlxColor.BLACK);
		blackBG.screenCenter();
		add(blackBG);
		//

		var logoLEl:FlxSprite= new FlxSprite().loadGraphic(Paths.image('logoP'));
		logoLEl.scale.set(0.23,0.23);
		logoLEl.screenCenter();
		logoLEl.y-=200;
		add(logoLEl);

		var coso:FlxText = new FlxText(12, FlxG.height - 44, 0, "It is recommended to activate \nShader for a better experience or\nyou could deactivate it in settings\n      [Press enter to begin]", 12);
		coso.setFormat("VCR OSD Mono", 40, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		coso.screenCenter();
		coso.y+=150;
		add(coso);
		if(!inicio)
		{
			if(FlxG.save.data != null && FlxG.save.data.fullscreen)
			{
				FlxG.fullscreen = FlxG.save.data.fullscreen;
				//trace('LOADED FULLSCREEN SETTING!!');
			}
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
		if(FlxG.sound.music == null) {
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
		}
		vcrShader = new FlxRuntimeShader(File.getContent(Paths.shaderFragment("tvcrt")));
	    shader1 = new FlxRuntimeShader(File.getContent(Paths.shaderFragment("shader1")));
		if (ClientPrefs.shaders)
		{
		 FlxG.camera.setFilters([new ShaderFilter(shader1),new ShaderFilter(vcrShader)]);
		}
		super.create();
		FlxG.mouse.visible=false;
	}	
	var titleInicied:Bool=false;
	var iTime:Float;
	override function update(elapsed:Float)
	{
		iTime += elapsed;
	    vcrShader.setFloat("iTime", iTime);
		shader1.setFloat("iTime", iTime);
		FlxG.camera.zoom= FlxMath.lerp(1, FlxG.camera.zoom,0.85);
			if (controls.ACCEPT&&!titleInicied){
				titleInicied=true;
				FlxG.camera.zoom+=0.1;
				FlxG.sound.play(Paths.sound('confirmMenu'));
				FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
				FlxG.sound.music.fadeIn(4, 0, 0.7);
				new FlxTimer().start(1.2, function(tmr:FlxTimer)
				{
					MusicBeatState.switchState(new MainMenuState());
				});
			}	
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		super.update(elapsed);
	}
}