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
	private var imageOffsets:Array<Float> = [0, 0];
	private var char:String = 'pene';
	override function create():Void
	{		
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

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('bgPlayTime'));
		bg.scale.set(0.659,0.659);
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		var logoLEl:FlxSprite= new FlxSprite().loadGraphic(Paths.image('logoP'));
		logoLEl.scale.set(0.23,0.23);
		logoLEl.screenCenter();
		logoLEl.y-=200;
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
		trace(curSelected);
		if (!selectedSomethin){
			cursorImage.setPosition(FlxG.mouse.getPosition().x-50,FlxG.mouse.getPosition().y-70);
			if (FlxG.mouse.justPressed){
				changeItem();
			}
			changeCur();
			/*
			if (controls.BACK){
				MusicBeatState.switchState(new TitleState());
			}
			*/
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
		if (FlxG.mouse.overlaps(menuItems.members[0])){
			curSelected=0;

		 }
		 if (FlxG.mouse.overlaps(menuItems.members[1])){
			 curSelected=1;

		 }
		 if (FlxG.mouse.overlaps(menuItems.members[2])){
			 curSelected=2;

		 }
		 if (FlxG.mouse.overlaps(menuItems.members[3])){
			curSelected=3;
		
		 }
		 if (!FlxG.mouse.overlaps(menuItems.members[0])&&!FlxG.mouse.overlaps(menuItems.members[1])&&!FlxG.mouse.overlaps(menuItems.members[2])&&!FlxG.mouse.overlaps(menuItems.members[3])){
			curSelected=4;
			cursorImage.animation.curAnim.curFrame = 0;
		 }else{
			cursorImage.animation.curAnim.curFrame = 1;
		 }
	}
	function changeItem(){
		if (curSelected==0 || curSelected==1 || curSelected==2 || curSelected==3){
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