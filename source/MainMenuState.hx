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

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.6.2'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxText>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	
	var optionShit:Array<String> = ['play','settings','credits','quit'];

	var magenta:FlxSprite;
	var debugKeys:Array<FlxKey>;
	var cursorImage:FlxSprite;
	var hubicationItems:Array<Int>=[];
	var vcrShader:FlxRuntimeShader;
	var shader1:FlxRuntimeShader;
	var alanpuntoecse:Bool = false;
	var corky:Bool = false;
	var antiperu2:Bool=false;
	var huggylel:FlxSprite;
	var negro2:FlxSprite;
	private var imageOffsets:Array<Float> = [0, 0];
	private var char:String = 'pene';
	override function create():Void
	{		
		openfl.Lib.application.window.title="Funkin' In Playtime";
		#if MODS_ALLOWED
		Paths.pushGlobalMods();
		#end
		WeekData.loadTheFirstEnabledMod();

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end
		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement, false);
		FlxG.cameras.setDefaultDrawTarget(camGame, true);

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		if(FlxG.save.data.antiperu2 != null) {
			antiperu2 = FlxG.save.data.antiperu2;
		}

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('bgPlayTime'));
		bg.scale.set(0.68,0.68);
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		var logoLEl:FlxSprite= new FlxSprite().loadGraphic(Paths.image('logoP'));
		logoLEl.scale.set(0.23,0.23);
		logoLEl.screenCenter();
		logoLEl.y-=200;
		logoLEl.antialiasing =ClientPrefs.globalAntialiasing;
		add(logoLEl);

		menuItems = new FlxTypedGroup<FlxText>();
		add(menuItems);

		hubicationItems.push(90);//0
		hubicationItems.push(360);//1
		hubicationItems.push(680);//2
		hubicationItems.push(990);//3
		for (i in 0...optionShit.length)
		{
			var textItem:FlxText= new FlxText(12,0,0,optionShit[i],12);
			textItem.setFormat("VCR OSD Mono", 46, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			textItem.ID=i;
			textItem.antialiasing =ClientPrefs.globalAntialiasing;
		    menuItems.add(textItem);
			textItem.setPosition(hubicationItems[i],620);
		}

		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "Psych Engine v" + psychEngineVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		//add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		//add(versionShit);

		negro2 = new FlxSprite(12).makeGraphic(240, 620, FlxColor.BLACK);
		negro2.screenCenter();
		negro2.x+=540;
		negro2.y-=360;
		add(negro2);
		negro2.visible = false;
		
		huggylel = new FlxSprite().loadGraphic(Paths.image('golden_huggy'));
		huggylel.scale.set(0.14,0.14);
		huggylel.screenCenter();
		huggylel.x+=540;
		huggylel.y-=200;
		huggylel.antialiasing = ClientPrefs.globalAntialiasing;
		huggylel.visible=false;
	    add(huggylel);
		if(antiperu2 == true) {
		  huggylel.visible=true;
		}

		cursorImage = new FlxSprite();
		cursorImage.loadGraphic(Paths.image('cursor'));
		cursorImage.loadGraphic(Paths.image('cursor'), true, Math.floor(cursorImage.width / 2), Math.floor(cursorImage.height));
		imageOffsets[0] = (cursorImage.width - 150) / 2;
		imageOffsets[1] = (cursorImage.height - 150) / 2;
		// cursorImage.updateHitbox();
		cursorImage.offset.x = imageOffsets[0];
		cursorImage.offset.y = imageOffsets[1];
		cursorImage.animation.add(char, [0, 1], 0, false,false);
		cursorImage.animation.play(char);
		cursorImage.scale.set(0.07,0.07);
		cursorImage.antialiasing =ClientPrefs.globalAntialiasing;
		add(cursorImage);

		
		FlxG.mouse.visible=false;
		super.create();
		// changeItem();

		cursorImage.setPosition(FlxG.mouse.getPosition().x-50,FlxG.mouse.getPosition().y-70);

		
		vcrShader = new FlxRuntimeShader(File.getContent(Paths.shaderFragment("tvcrt")));
	    shader1 = new FlxRuntimeShader(File.getContent(Paths.shaderFragment("shader1")));
	
		if (ClientPrefs.shaders)
		{
		 FlxG.camera.setFilters([new ShaderFilter(shader1),new ShaderFilter(vcrShader)]);
		}
		if(FlxG.sound.music == null) {
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
		}
	}
	var selectedSomethin:Bool = false;
	var iTime:Float;
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		iTime += elapsed;
	    vcrShader.setFloat("iTime", iTime);
		shader1.setFloat("iTime", iTime);
		if (!selectedSomethin){
			cursorImage.setPosition(FlxG.mouse.getPosition().x-50,FlxG.mouse.getPosition().y-70);
			if (FlxG.mouse.justPressed && alanpuntoecse == false){
				changeItem();
			}
			changeCur();
		}
		if(FlxG.keys.justPressed.SPACE && curSelected == 4 && alanpuntoecse == false) {
			alanpuntoecse = true;
			corky = true;
			PlayState.SONG = Song.loadFromJson('el-rap-de-huggy-wuggy', 'el-rap-de-huggy-wuggy');
            PlayState.isStoryMode = false;
            PlayState.storyDifficulty = 2;
            PlayState.storyWeek = 1;
			FlxG.sound.play(Paths.sound('confirmMenu'));
			new FlxTimer().start(0.4, function(tmr:FlxTimer)
			{
				LoadingState.loadAndSwitchState(new PlayState());
			});
			FlxG.camera.fade(FlxColor.BLACK, 0.4, false);
		}
		if(controls.ACCEPT && curSelected <= 3 && alanpuntoecse == false) {
			alanpuntoecse = true;
			changeItem();
		}
		if(controls.ACCEPT && curSelected == 4 && alanpuntoecse == false) {
			curSelected = 0;
			alanpuntoecse = true;
			changeItem();
		}

		if (huggylel.visible){
			if (FlxG.mouse.overlaps(negro2) && FlxG.mouse.justPressed && corky == false) {
				FlxG.sound.play(Paths.sound('huggyfunnylaugh'));
				huggylel.scale.set(0.18,0.18);
				corky = true;
				FlxTween.tween(huggylel.scale, {x: 0.14, y: 0.14}, 1, {ease: FlxEase.quintOut, onComplete: function(twn:FlxTween) {
					corky = false;
				}});
			}
		}
	}
	var beats:Int;
	override function beatHit()
	{
		super.beatHit();
		beats++;
		switch(beats){
			case 1:
			
		}
	}
	function changeCur(){
		if (FlxG.mouse.overlaps(menuItems.members[0]) && alanpuntoecse == false){
			curSelected=0;

		 }
		 if (FlxG.mouse.overlaps(menuItems.members[1]) && alanpuntoecse == false){
			 curSelected=1;

		 }
		 if (FlxG.mouse.overlaps(menuItems.members[2]) && alanpuntoecse == false){
			 curSelected=2;

		 }
		 if (FlxG.mouse.overlaps(menuItems.members[3]) && alanpuntoecse == false){
			curSelected=3;
		
		 }
		 if (!FlxG.mouse.overlaps(negro2) && !FlxG.mouse.overlaps(menuItems.members[0])&&!FlxG.mouse.overlaps(menuItems.members[1])&&!FlxG.mouse.overlaps(menuItems.members[2])&&!FlxG.mouse.overlaps(menuItems.members[3]) && alanpuntoecse == false){
			curSelected=4;
			cursorImage.animation.curAnim.curFrame = 0;
		 }else{
			cursorImage.animation.curAnim.curFrame = 1;
		 }
	}
	function changeItem(){
		if (curSelected<=3){
		alanpuntoecse = true;
		FlxG.sound.play(Paths.sound('confirmMenu'));
		new FlxTimer().start(0.4, function(tmr:FlxTimer)
		{
			switch(curSelected){
				case 0: 
					MusicBeatState.switchState(new StoryMenuState());
				case 1:
					LoadingState.loadAndSwitchState(new options.OptionsState());
				case 2:
					MusicBeatState.switchState(new CreditsState());	
				case 3:
					new FlxTimer().start(0.45, function(tmr:FlxTimer)
					{
					 System.exit(0);
					});
			  }
	   });
	   }else{}
	}
}