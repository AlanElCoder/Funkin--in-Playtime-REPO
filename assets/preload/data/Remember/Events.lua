function onUpdatePost(elapsed)
	if curStep== 768 then
		--triggerEvent('CameraZoom',0.75,1)
		triggerEvent('Set Cam Zoom',0.75,1)
	end	
	if curStep==1153 then
	 triggerEvent('ChaSrlTyp~ Strum Swap', 'on')
	 triggerEvent('Change Scrolltype', '', 'off')
   	 CreateBars()
	end
	--setPropertyFromClass('PlayState', 'botPlay',true)
	--setProperty('timeBar.visible',false)
	--setProperty('timeBarBG.visible',false)
end		
function CreateBars()
    makeLuaSprite('upBarr')
    makeGraphic('upBarr',1500,500,'000000')
    addLuaSprite('upBarr')
    setObjectCamera('upBarr','camHUD')


    makeLuaSprite('downBarr')
    makeGraphic('downBarr',1500,500,'000000')
    addLuaSprite('downBarr')
    setObjectCamera('downBarr','camHUD')


    screenCenter('upBarr','X')
    screenCenter('downBarr','X')
    setProperty('upBarr.y',-1400)
    setProperty('downBarr.y',1400)

	doTweenY('moveStart', 'upBarr', -400, 1 , 'quadInOut')
    doTweenY('moveStart2', 'downBarr', 630, 1 , 'quadInOut')

	--doTweenX('moveHuggy','hPatas',-900,1,'quadInOut')
	--doTweenX('moveHuggy2','dad',-900,1,'quadInOut')
end   		