--storyboard stuff
local storyboard = require ("storyboard")
local scene = storyboard.newScene()
local params 

--global assets
--positioning variables
local middleX=display.contentCenterX
local middleY=display.contentCenterY

-- Menu Screen
local menuScreenGroup	-- display.newGroup()
local easyBtn
local medBtn
local hardBtn
local helpBtn
local creditsBtn
local musicIsPlaying
local IconSheetData 	
local musicIconSheet
local IconSequenceData
local musicIcon
local sfxIconSheet
local sfxIcon
local sfx


 -- background 
function scene:createScene(event)
print("I'm on the menuScreen screen")
if event.params==nil then
		print("params are nil")
		sfx=true
		musicIsPlaying = "true"
	else
	params = event.params
	sfx=params.sfx
	musicIsPlaying=params.musicIsPlaying
	end
	print(event.params)

	local screenGroup = self.view
	--background images & stuff
	menuScreenGroup=display.newGroup()
	mmScreen = display.newImage(menuScreenGroup, "mainScreen.jpg",0,0, true)

	easyBtn = display.newImage("easybtn.png")
	easyBtn:setReferencePoint(display.CenterReferencePoint)
	easyBtn.x = middleX-300; easyBtn.y = 500
	easyBtn.name = "easybutton"

	medBtn = display.newImage("mediumbtn.png")
	medBtn:setReferencePoint(display.CenterReferencePoint)
	medBtn.x = middleX; medBtn.y = 500
	medBtn.name = "mediumbutton"

	hardBtn = display.newImage("hardbtn.png")
	hardBtn:setReferencePoint(display.CenterReferencePoint)
	hardBtn.x = middleX+300; hardBtn.y = 500
	hardBtn.name = "hardbutton"

	helpBtn = display.newImage("helpbtn.png")
	helpBtn.x = middleX-500; helpBtn.y = 620
	helpBtn.name = "helpbutton"

	creditsBtn = display.newImage("creditsbtn.png")
	creditsBtn.x = middleX+500; creditsBtn.y = 620
	creditsBtn.name = "creditsbutton"

	--musicIcon/soundIcon sprite global variables
	--sheetData holds the information about the image. Size of frame and size of sheet.
	IconSheetData = { width=90, height=90, numFrames=2, sheetContentWidth=180, sheetContentHeight=90 }
 
	--this line gives two types of animation to play. Either one can be called by utilizing: animation:setSequence( “pointLeft” ) 
	IconSequenceData = {
    	{ name = "On", frames={1}, time=800, loopCount=1 },
    	{ name = "Off", frames={2}, time=800, loopCount=1 }
  	}

  	musicIconSheet = graphics.newImageSheet("musiconoff2.png", IconSheetData )
	musicIcon = display.newSprite( musicIconSheet, IconSequenceData )
  	musicIcon.myName = "musicIcon"
  	print("musicIsPlaying "..musicIsPlaying)

  	if musicIsPlaying == "true" then
	musicIcon:setSequence("On")
	elseif musicIsPlaying == "paused" then
	musicIcon:setSequence("Off")
	end
	musicIcon:play()
	menuScreenGroup:insert(musicIcon)
	musicIcon.x=middleX-100
	musicIcon.y=620

--speaker stuff
  	sfxIconSheet = graphics.newImageSheet("speakeronoff2.png", IconSheetData )
	sfxIcon = display.newSprite( sfxIconSheet, IconSequenceData )
  	sfxIcon.myName = "sfxIcon"
	if sfx == true then
	sfxIcon:setSequence("On")
	else
	sfxIcon:setSequence("Off")
	end	
	sfxIcon:play()
	menuScreenGroup:insert(sfxIcon)
	sfxIcon.x=middleX+100
	sfxIcon.y=620

	menuScreenGroup:insert(easyBtn)
	menuScreenGroup:insert(medBtn)
	menuScreenGroup:insert(hardBtn)
	menuScreenGroup:insert(helpBtn)
	menuScreenGroup:insert(creditsBtn)

end

function menuLoadScreen(event)			
	sceneOptions =
	{
	effect = "fade",
	time = 1000,
	params =
		{
		musicIsPlaying = musicIsPlaying,
		sfx=sfx
		}
	}

	if event.target.name == "easybutton" then 
	print("easyBtn on menuScreen")
	storyboard.gotoScene("playEasy", sceneOptions )
	elseif event.target.name == "mediumbutton" then 
	storyboard.gotoScene("playMedium", sceneOptions)
	print("medBtn on menuScreen")
	elseif event.target.name == "hardbutton" then 
	storyboard.gotoScene("playHard", sceneOptions)
	print("hardBtn on menuScreen")
	elseif event.target.name == "helpbutton" then 
	print("helpBtn on menuScreen")
	storyboard.gotoScene("helpScreen", sceneOptions)
	elseif event.target.name == "creditsbutton" then 
	print("creditsBtn on menuScreen")
	storyboard.gotoScene("creditsScreen", sceneOptions)
	else
	print ("else in loadScreen on menuScreen")
	end
	transition.to(menuScreenGroup, {time=0, alpha=0,})	
end

function toggleSoundMenu(event)
	if event.phase == "ended" then
		if sfx == true then 
		sfxIcon:setSequence("Off")
		sfxIcon:play()
		sfx=false
		else
		sfxIcon:setSequence("On")
		sfxIcon:play()
		sfx=true
		end
	end
end

function onPlayTouchMenu(event)
	if event.phase == "ended" then
		if musicIsPlaying == "paused" then
		myMusic = audio.resume(backgroundSound, {channel=1, loops=-1})
	  	musicIcon:setSequence("On")
		musicIcon:play()
		print("resume")
		musicIsPlaying = "true"
		elseif musicIsPlaying == "true" then
		myMusic = audio.pause(backgroundSound, {channel=1, loops=-1})
	  	musicIcon:setSequence("Off")
		musicIcon:play()
		musicIsPlaying="paused"
		end
		print(musicIsPlaying)
	end
end

function scene:enterScene(event)
	storyboard.purgeAll()	
-- Button Listeners		
	easyBtn:addEventListener("tap", menuLoadScreen)
	medBtn:addEventListener("tap", menuLoadScreen)
	hardBtn:addEventListener("tap", menuLoadScreen)
	helpBtn:addEventListener("tap", menuLoadScreen)
	creditsBtn:addEventListener("tap", menuLoadScreen)
	musicIcon:addEventListener("touch", onPlayTouchMenu)
	sfxIcon:addEventListener("touch", toggleSoundMenu)
end

function scene:exitScene(event )
-- Button Listeners		
	easyBtn:removeEventListener("tap", menuLoadScreen)
	medBtn:removeEventListener("tap", menuLoadScreen)
	hardBtn:removeEventListener("tap", menuLoadScreen)
	helpBtn:removeEventListener("tap", menuLoadScreen)
	creditsBtn:removeEventListener("tap", menuLoadScreen)
		musicIcon:addEventListener("touch", onPlayTouchMenu)
	sfxIcon:addEventListener("touch", toggleSoundMenu)

end

function scene:destroyScene(event )	

end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)

return scene


