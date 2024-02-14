package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;
import flixel.graphics.FlxGraphic;
import WeekData;
import haxe.Json;
#if !flash 
import flixel.addons.display.FlxRuntimeShader;
import openfl.filters.ShaderFilter;
#end

#if sys
import sys.FileSystem;
import sys.io.File;
#end

using StringTools;
typedef WeekDataLEl =
{ 
	widthL:Dynamic,
	heightL:Dynamic,
	ekis:Float,
	eye:Float,
	descWeek:String,
	songs:Array<Dynamic>,
	numWeek:Int,
	ekisT:Float,
	eyeT:Float
}
class StoryMenuState extends MusicBeatState
{
	
	var textWeek:FlxText;
	var text:FlxText;
	var quitar:FlxText;
	var menuItems:FlxTypedGroup<FlxSprite>;
	public static var weekJSON:WeekDataLEl;
	public static var weekCompleted:Map<String, Bool> = new Map<String, Bool>();
	var curSelected:Int;
	var cursorImage:FlxSprite;
	var vcrShader:FlxRuntimeShader;
	private static var lastDifficultyName:String = '';
	var curDifficulty:Int = 1;
	var shader1:FlxRuntimeShader;
	var bgBlack:FlxSprite;
	private var imageOffsets:Array<Float> = [0, 0];
	private var char:String = 'pene';
	override function create():Void//ya Void xdxdxd
	{
		super.create();
	

		PlayState.isStoryMode = true;


		weekJSON = Json.parse(Paths.getTextFromFile('weeks/chapter1.json'));


		
		bgBlack= new FlxSprite().makeGraphic(FlxG.width,FlxG.height,FlxColor.BLACK);
		add(bgBlack);
		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		text = new FlxText(450, 0, 0, "| select Chapter |", 12);
		text.setFormat("VCR OSD Mono", 35, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(text);

		for (i in 0...1){
            //crear recuadros
			var newItem:FlxSprite= new FlxSprite();
			newItem.makeGraphic(weekJSON.widthL,weekJSON.heightL,FlxColor.WHITE);
            newItem.setPosition(weekJSON.ekis,weekJSON.eye);
			newItem.updateHitbox();
			newItem.alpha=0;
			menuItems.add(newItem);

			var newItem2:FlxSprite= new FlxSprite();
			newItem2.loadGraphic(Paths.image('chapters/1'));
            newItem2.setPosition(weekJSON.ekis,weekJSON.eye);
			newItem2.scale.set(0.45,0.45);
			newItem2.updateHitbox();
			menuItems.add(newItem2);


			textWeek = new FlxText(12, 0, 0, "CHAPTER "+weekJSON.numWeek+" "+weekJSON.descWeek, 12);
			textWeek.setPosition(weekJSON.ekisT,weekJSON.eyeT);
			textWeek.setFormat("VCR OSD Mono", 40, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			add(textWeek);
		}	
		quitar = new FlxText(1182, 0, 0, "Quit", 12);
		quitar.setFormat("VCR OSD Mono", 35, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(quitar);
		quitar.updateHitbox();

	
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

		cursorImage.setPosition(FlxG.mouse.getPosition().x-50,FlxG.mouse.getPosition().y-70);


		FlxG.mouse.visible=false;
		vcrShader = new FlxRuntimeShader(File.getContent(Paths.shaderFragment("tvcrt")));
	    shader1 = new FlxRuntimeShader(File.getContent(Paths.shaderFragment("shader1")));
		if (ClientPrefs.shaders)
		{
		 FlxG.camera.setFilters([new ShaderFilter(shader1),new ShaderFilter(vcrShader)]);
		}
	}
	var iTime:Float;
	var noPressed:Bool=false;
	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		iTime += elapsed;
	    vcrShader.setFloat("iTime", iTime);
		shader1.setFloat("iTime", iTime);
		cursorImage.setPosition(FlxG.mouse.getPosition().x-50,FlxG.mouse.getPosition().y-70);

		if (controls.BACK){
			MusicBeatState.switchState(new MainMenuState());
		}
		changeCur();
		if (FlxG.mouse.justPressed && !noPressed && cursorImage.animation.curAnim.curFrame == 1){
			changeItem();
		}
		if(controls.ACCEPT && !noPressed) {
			curSelected = 0;
			changeItem();
		}
	}
	function changeCur(){
		if(!noPressed) {
			if (FlxG.mouse.overlaps(menuItems.members[1])){
				curSelected=0;
				cursorImage.animation.curAnim.curFrame = 1;
			}else{
				cursorImage.animation.curAnim.curFrame = 0;
				curSelected=2;
				noPressed=false;
			}
			if (FlxG.mouse.overlaps(quitar)) {
				curSelected=1;
				cursorImage.animation.curAnim.curFrame = 1;
			}
			// no alan ya no 😡
		}
	}
	function changeItem(){
		noPressed=true;
		if (curSelected==0){
		FlxG.sound.play(Paths.sound('confirmMenu'));
		new FlxTimer().start(0.4, function(tmr:FlxTimer)
		{
			PlayState.storyPlaylist = weekJSON.songs[curSelected];
		    PlayState.storyDifficulty = 1;

	     	PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase()+"-hard", PlayState.storyPlaylist[0].toLowerCase());
	       	PlayState.storyWeek = weekJSON.numWeek;
	      	PlayState.campaignScore = 0;
	    	new FlxTimer().start(0.4, function(tmr:FlxTimer)
		   	{
		     LoadingState.loadAndSwitchState(new PlayState(), true);
			 FreeplayState.destroyFreeplayVocals();
		    });

	   });
	   }else if (curSelected==1) {
		 FlxG.sound.play(Paths.sound('confirmMenu'));
		 new FlxTimer().start(0.4, function(tmr:FlxTimer)
		 {
			MusicBeatState.switchState(new MainMenuState());
		 });
	   }
	   
	}
}