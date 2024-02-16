-- change the video name here	->  var filepath = Paths.video('name');	
--												     		   ^^^^^^^
-- or put the video whit name " name" on videos folder

function onCreate()

makeLuaSprite('black', '', 0, 0);

makeGraphic('black', 2500, 2500, '000000');

--setScrollFactor('black', 0, 0);
setObjectCamera('black', 'game');

setObjectCamera('videoSprite', 'game');

setObjectOrder('black', 99999);

screenCenter('black');

addLuaSprite('black', true);


	setProperty('skipCountdown', true)

	makeLuaSprite('videoSprite','',0,0)
	addLuaSprite('videoSprite')

	addHaxeLibrary('MP4Handler','vlc')
	addHaxeLibrary('Event','openfl.events')

	runHaxeCode([[
		var filepath = Paths.video('ELRAPDEHUGGYWUGGY');		
		var video = new MP4Handler();
		video.playVideo(filepath);
		video.visible = false;
		setVar('video',video);
		FlxG.stage.removeEventListener('enterFrame', video.update); 
	]])
end

function onUpdatePost()
	triggerEvent('Camera Follow Pos', '640', '360')

	runHaxeCode([[
		var video = getVar('video');
		game.getLuaObject('videoSprite').loadGraphic(video.bitmapData);
		video.volume = FlxG.sound.volume + 100;	
		if(game.paused)video.pause();
	]])
end


function onResume()
	runHaxeCode([[
		var video = getVar('video');
		video.resume();
	]])
end
function onCreatePost()
	getObjectOrder('videoSprite')
	setObjectOrder('videoSprite', 100000)
end

function onUpdate()
	triggerEvent('Camera Follow Pos', '640', '360')
end
