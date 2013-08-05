--storyboard stuff
local storyboard = require ("storyboard")
local scene = storyboard.newScene()
local params 


--global assets
--positioning variables
local middleX=display.contentCenterX
local middleY=display.contentCenterY

-- Menu Screen
local GOScreenGroup	-- display.newGroup()
local goScreen
local easyBtn
local medBtn
local hardBtn
local helpBtn
local creditsBtn
local message
local endText
local lives
local level
local score
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
	print("I'm on the gameOverScreen")
	params = event.params
	print( params.sfx )
	print( params.musicIsPlaying )
	score=params.score
	lives=params.lives
	level=params.level
	sfx=params.sfx
	musicIsPlaying=params.musicIsPlaying

	local screenGroup = self.view
	--background images & stuff
	GOScreenGroup=display.newGroup()
	goScreen = display.newImage(GOScreenGroup, "gameOverScreen.jpg",0,0, true)

	helpBtn = display.newImage("helpbtn.png")
	helpBtn.x = middleX+500; helpBtn.y = 620
	helpBtn.name = "helpbutton"

	creditsBtn = display.newImage("creditsbtn.png")
	creditsBtn.x = middleX-500; creditsBtn.y = 620
	creditsBtn.name = "creditsbutton"

	easyBtn = display.newImage("easybtn.png")
	easyBtn.x = middleX-300; easyBtn.y = 500
	easyBtn.name = "easybutton"

	medBtn = display.newImage("mediumbtn.png")
	medBtn.x = middleX; medBtn.y = 500
	medBtn.name = "mediumbutton"

	hardBtn = display.newImage("hardbtn.png")
	hardBtn.x = middleX+300; hardBtn.y = 500
	hardBtn.name = "hardbutton"

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

  	if musicIsPlaying == "true" then
	musicIcon:setSequence("On")
	elseif musicIsPlaying == "paused" then
	musicIcon:setSequence("Off")
	end
	musicIcon:play()
	GOScreenGroup:insert(musicIcon)
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
	GOScreenGroup:insert(sfxIcon)
	sfxIcon.x=middleX+100
	sfxIcon.y=620

	GOScreenGroup:insert(helpBtn)
	GOScreenGroup:insert(creditsBtn)
	GOScreenGroup:insert(easyBtn)
	GOScreenGroup:insert(medBtn)
	GOScreenGroup:insert(hardBtn)

	--text to be displayed
	scoreText = display.newText("Score:", middleX+300, 2, "Verdana", 30)
	scoreText:setTextColor(0,0,0,255)

	scoreNum = display.newText(""..score, middleX+400, 2, "Verdana", 30)
	scoreNum:setTextColor(0,0,0,255)

	livesText = display.newText("Lives:", middleX-400, 5, "Verdana", 30)
	livesText:setTextColor(0,0,0,255)

	livesNum = display.newText( ""..lives, middleX-300, 5, "Verdana", 30)
	livesNum:setTextColor(0,0,0,255)

if lives<=0 then
		message ="          The planes destroyed your ship.\n                       Try again."

	else
		message = "           You survived the "..level .. " level!\n                  Try a different level." -- the space before is to center the text.
	end	
	endText = display.newText(GOScreenGroup, message, 0, 0,display.contentWidth *0.7,display.contentHeight *0.5,"Verdana",40)
	endText.x = middleX
	endText.y = middleY+150
	endText:setTextColor(0,0,0,255)

	GOScreenGroup:insert(scoreText)
	GOScreenGroup:insert(scoreNum)
	GOScreenGroup:insert(livesText)
	GOScreenGroup:insert(livesNum)
end

function toggleSoundGO(event)
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

function onPlayTouchGO(event)
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

function GOLoadScreen(event)
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
if event.target.name == "helpbutton" then 
	print("helpBtn")
	storyboard.gotoScene("helpScreen", sceneOptions)
	elseif event.target.name == "creditsbutton" then 
	print("creditsBtn")
	storyboard.gotoScene("creditsScreen", sceneOptions)
	elseif event.target.name == "easybutton" then 
	storyboard.gotoScene("playEasy", sceneOptions)
	elseif event.target.name == "mediumbutton" then 
	storyboard.gotoScene("playMedium", sceneOptions)
	elseif event.target.name == "hardbutton" then 
	storyboard.gotoScene("playHard", sceneOptions)
	else 
		print("the else in loadScreen on gameOverScreen")
	end
	transition.to(GOScreenGroup, {time=0, alpha=0,})
end


function scene:enterScene(event)
	storyboard.purgeAll()
-- Button Listeners	
	easyBtn:addEventListener("tap", GOLoadScreen)
	medBtn:addEventListener("tap", GOLoadScreen)
	hardBtn:addEventListener("tap", GOLoadScreen)
	helpBtn:addEventListener("tap", GOLoadScreen)
	creditsBtn:addEventListener("tap", GOLoadScreen)
	musicIcon:addEventListener("touch", onPlayTouchGO)
	sfxIcon:addEventListener("touch", toggleSoundGO)
end

function scene:exitScene(event )
-- Button Listeners		
	easyBtn:removeEventListener("tap", GOLoadScreen)
	medBtn:removeEventListener("tap", GOLoadScreen)
	hardBtn:removeEventListener("tap", GOLoadScreen)
	helpBtn:removeEventListener("tap", GOLoadScreen)
	creditsBtn:removeEventListener("tap", GOLoadScreen)
	musicIcon:removeEventListener("touch", onPlayTouchGO)
	sfxIcon:removeEventListener("touch", toggleSoundGO)
end

function scene:destroyScene(event )	

end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)

return scene