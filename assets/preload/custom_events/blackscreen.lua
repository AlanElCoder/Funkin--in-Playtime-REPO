function onCreatePost()
------------------------------------------------------------------------
	--THE wea--
	makeLuaSprite('blackScreen', 'empty', -110, -350)
	makeGraphic('blackScreen', 1500, 2500, '000000')
	setObjectCamera('blackScreen', 'camOther')
	addLuaSprite('blackScreen', true)
	setProperty('blackScreen.alpha',0)

------------------------------------------------------------------------
end
------------------------------------------------------------------------
function onEvent(name, value1, value2)
	if name == 'blackscreen' then
	
	Speed = tonumber(value1)
	alpha = tonumber(value2)
	end

	if Speed <= 0 then		
		setProperty('blackScreen.alpha',alpha)
	end

	if alpha > 0 then
		doTweenAlpha('blackScreen', 'blackScreen', alpha, Speed, 'QuadOut')
		end

--FOR EXIT--
------------------------------------------------------------------------
    if alpha == 0 then
    	doTweenAlpha('blackScreen', 'blackScreen', 0, Speed, 'QuadOut')
    end
end
