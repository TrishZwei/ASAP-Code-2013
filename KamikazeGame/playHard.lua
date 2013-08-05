--storyboard stuff
local storyboard = require ("storyboard")
local scene = storyboard.newScene()
local params

-- Physics Engine		
local physics = require "physics"
physics.start()
physics.setGravity(0, 0)

--accelerometer
system.setAccelerometerInterval(100)

--global assets
--positioning variables
local middleX=display.contentCenterX
local middleY=display.contentCenterY
local moveX

local gameScreenGroup --display.newGroup()

-- Game Assets
local kamikaze
local destroyer
local bullet
local ocean
local sky
local sun
local message
local endTextOptions
local planeFlying

--effects
local g = graphics.newGradient(
  { 0, 128, 255 },
  { 153, 255, 255 },
  "down" )

-- Score/Lives/Time Text
local scoreText
local scoreNum
local score

--positioning variables
local middleX=display.contentCenterX
local middleY=display.contentCenterY
local right=display.contentWidth
local left=0
local top=0
local bottom=display.contentHeight

--explosion sprite global variables
local explosionSheetData 	
local explosionSheet
local explosionSequenceData
local explosion

--explosion sound
local boom 

--splash sound
local splashSound

--plane sprite global variables
local planeSheetData 	
local planeSheet
local planeSequenceData
local planeFlying

--boat animation
local boatSheetData
local boatSheet
local boatSequenceData
local boatMoving

--splash animation
local splashSheetData
local splashSheet
local splashSequenceData
local splash

--the add plane timer
local addPlaneTimerHard

--variable for countdown
local theTime

--accelerometer variables
local acc 

local isSimulator = "simulator" == system.getInfo("environment")

  -- Music Variables
local backgroundSound
local myMusic
local musicIsPlaying
local musicIconSheetData 	
local musicIconSheet
local musicIconSequenceData
local musicIcon
local sfxIconSheet
local sfxIcon
local sfx

function scene:createScene(event)
print("I'm on the Hard screen")
if event.params==nil then
		print("params are nil")
		sfx=true
		musicIsPlaying = "true"
	else
	params = event.params
	sfx=params.sfx
	musicIsPlaying=params.musicIsPlaying
	print("params exist")
	end

	local screenGroup = self.view
	
	--load the assets and put them into the screen group, set the values...
	score = 0
	lives = 3
	theTime = 30
	gameScreenGroup=display.newGroup()	
	-- sets gradient 'g',defined above on rect
	sky = display.newRect(gameScreenGroup, 0, 0, display.contentWidth, display.contentHeight)
	sky:setFillColor( g )

	sun = display.newImage(gameScreenGroup,"sun.png", 150,50)

	ocean = display.newImage(gameScreenGroup,"oceanbg.png", 355, 580)
	ocean:setReferencePoint(display.CenterReferencePoint)
	ocean.x=middleX
	ocean.myName="ocean"
	physics.addBody(ocean, "static", {density = 0.1, bounce = 1, friction = 0, isSensor=true})

	--add upper wall for ball to collide against
	upperBarrier = display.newRect(gameScreenGroup, 0, -10, display.contentWidth, 10)
	upperBarrier.myName="ceiling"
	physics.addBody(upperBarrier, "dynamic", {density=0, bounce=0, friction=0, isSensor=true})
	
	scoreText = display.newText(gameScreenGroup, "Score:", middleX+300, 2, "Verdana", 30)
	scoreText:setTextColor(255,255,255,255)

	scoreNum = display.newText(gameScreenGroup, "0", middleX+420, 2, "Verdana", 30)
	scoreNum:setTextColor(255,255,255,255)

	livesText = display.newText(gameScreenGroup, "Lives:", middleX-400, 5, "Verdana", 30)
	livesNum = display.newText(gameScreenGroup, "3", middleX-300, 5, "Verdana", 30)

	timerText=display.newText("Time:", middleX-50, 2, "Verdana", 30)
	timerText:setTextColor(255,255,255)

	timerNum = display.newText("30", middleX+50,2,"Verdana", 30)
	timerNum:setTextColor(255,255,255)

	--explosion stuff
	--sheetData holds the information about the image. Size of frame and size of sheet.
	explosionSheetData = { width=24, height=23, numFrames=8, sheetContentWidth=192, sheetContentHeight=23 }
	-- this line links the actual image to the sheet data and passes the parameters of sheetData
	explosionSheet = graphics.newImageSheet( "explosion.png", explosionSheetData )
	--This line gives information to the animation for how to play.
	explosionSequenceData ={ name = "normalExplosion", start=1, count=8, time=800, loopCount=1 }
    
	--this displays the sprite, like we would an image but it does not play it. 
	explosion = display.newSprite( explosionSheet, explosionSequenceData )

--splash stuff
	--sheetData holds the information about the image. Size of frame and size of sheet.
	splashSheetData = { width=156, height=118, numFrames=10, sheetContentWidth=780, sheetContentHeight=236 }
	-- this line links the actual image to the sheet data and passes the parameters of sheetData
	splashSheet = graphics.newImageSheet( "splashsheet2.png", splashSheetData )
	--This line gives information to the animation for how to play.
	splashSequenceData ={ name = "splashing", start=1, count=10, time=800, loopCount=1 }
    
	--this displays the sprite, like we would an image but it does not play it. 
	splash = display.newSprite( splashSheet, splashSequenceData )
	splash.isVisible=false

--sheetData holds the information about the image. Size of frame and size of sheet.
	planeSheetData = { width=120, height=70, numFrames=2, sheetContentWidth=240, sheetContentHeight=70 }
 
--this line gives two types of animation to play. Either one can be called by utilizing: animation:setSequence( “pointLeft” ) 
	planeSequenceData = {
    	{ name = "pointLeft", start=1, count=1, time=800, loopCount=1 },
    	{ name = "pointRight", frames={2}, time=800, loopCount=1 }
  	}

	boatSheetData = { width=81, height=146, numFrames=2, sheetContentWidth=162, sheetContentHeight=146 }
	boatSequenceData = {
    { name = "wavesmove", start=1, count=2, time=800, loopCount=0 },
  }

--convert to boat
  	boat = graphics.newImageSheet("battleships.png", boatSheetData )

	destroyer = display.newSprite(boat, boatSequenceData )
  	gameScreenGroup:insert(destroyer)
 	destroyer.x = middleX
  	destroyer.y = 540
  	destroyer.myName = "destroyer"
  	physics.addBody(destroyer, "static", {density = 0.1, bounce = 0, friction = .1,})
  	destroyer:play()

--musicIcon/soundIcon sprite global variables
--sheetData holds the information about the image. Size of frame and size of sheet.
	IconSheetData = { width=90, height=90, numFrames=2, sheetContentWidth=180, sheetContentHeight=90 }
 
--this line gives two types of animation to play. Either one can be called by utilizing: animation:setSequence( “pointLeft” ) 
	IconSequenceData = {
    	{ name = "On", frames={1}, time=800, loopCount=1 },
    	{ name = "Off", frames={2}, time=800, loopCount=1 }
  	}

  	musicIconSheet = graphics.newImageSheet("musiconoff2.png", IconSheetData )

backgroundSound=audio.loadStream("MilitaryTune.mp3")

	musicIcon = display.newSprite( musicIconSheet, IconSequenceData )
  	musicIcon.myName = "musicIcon"
  	print("musicIsPlaying "..musicIsPlaying)

	myMusic = audio.play(backgroundSound, {channel=1, loops=-1})
	audio.setVolume( 0.5, { channel=1 } ) -- set the volume on channel 1
	if musicIsPlaying == "true" then
	musicIcon:setSequence("On")
	elseif musicIsPlaying == "paused" then
	myMusic = audio.pause(backgroundSound, {channel=1, loops=-1})
	musicIcon:setSequence("Off")
	end
	musicIcon:play()
	gameScreenGroup:insert(musicIcon)

	musicIcon.x=50
	musicIcon.y=50

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
	gameScreenGroup:insert(sfxIcon)
	sfxIcon.x=right-50
	sfxIcon.y=50
end

function toggleSoundHard(event)
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

function onPlayTouchHard(event)
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

function moveBoatSimHard(event)
		--code to move the boat in the simulator
	if isSimulator then	
		--couldn't get the touch sensor to work :/ click on the boat and drag. 
		if event.phase == "began" then
			moveX = event.x -destroyer.x
		elseif event.phase == "moved" then
		destroyer.x = event.x - moveX
		end
		if ((destroyer.x -destroyer.width * 0.5) < 0) then
		destroyer.x =destroyer.width * 0.5
		elseif((destroyer.x +destroyer.width * 0.5) > display.contentWidth) then
		destroyer.x = display.contentWidth -destroyer.width * 0.5
		end
	end
end

function moveBoatHard(event)
	-- Accelerometer Movement	
	--must be yGravity since it's landscape
	destroyer.x = display.contentCenterX - (display.contentCenterX * (event.yGravity*3))
	-- Wall Borders 
	if((destroyer.x - destroyer.width * 0.5) < 0) then
		destroyer.x = destroyer.width * 0.5
	elseif((destroyer.x + destroyer.width * 0.5) > display.contentWidth) then
		destroyer.x = display.contentWidth - destroyer.width * 0.5
	end
end

function addPlaneHard(event)
  	kamikaze = graphics.newImageSheet("zeroSheet.png", planeSheetData )

	planeFlying = display.newSprite( kamikaze, planeSequenceData )
	gameScreenGroup:insert(planeFlying)
 	planeFlying.x = math.random(0,1200)
  	planeFlying.y = -40
  	planeFlying.myName = "plane"
  	physics.addBody(planeFlying, "dynamic", {density = 0.1, bounce = 0, friction = .1,})
  	movePlaneHard(planeFlying.x)
end	

function movePlaneHard(compareX1)
--	print("first X: "..compareX1)
	compareX2 =math.random(0, 1280)
--	print("second X: "..compareX2)
	if compareX1 < compareX2 then
--		print("this is pointRight")
		planeFlying:setSequence("pointRight")
	else
	--	print("this is pointLeft")
		planeFlying:setSequence("pointLeft")
	end
	planeFlying:play()
	planeMove = transition.to(planeFlying, {time = 1200, x = compareX2, y = display.contentHeight+10})
end

function tickingTimeHard(event)
 theTime = theTime - 1
 timerNum.text = theTime 
end

function check4GameOverHard()
	if lives<=0 then
--		print("gameOver")
		gameOverHard("lives")	
	end
end

function gameOverHard(event)
	print("gameOver on playHard")
	if event == "lives" then
		lives=0
	end	

	sceneOptions =
	{
	effect = "fade",
	time = 1000,
	params =
		{
		score = score,
		lives = lives,
		level = "hard",
		musicIsPlaying = musicIsPlaying,
		sfx=sfx
		}
	}
	print("score is: "..score)
	print("lives is: "..lives)

storyboard.gotoScene( "gameOverScreen", sceneOptions )
end	

function removeObjectHard(event)
--[[left this in for testing later	
	if (event.phase=="began") then
	print( "began: " .. event.object1.myName .. " & " .. event.object2.myName )
	end ]]--

	if (event.phase=="began" and event.object1.myName=="plane" and event.object2.myName=="bullet") then
	explosion.x = event.object1.x
	explosion.y = event.object1.y
	explosion:play()
	if sfx == true then
	audio.play(boom)	
	end
	event.object1:removeSelf()
	event.object2:removeSelf()		
	score = score + 1
	scoreNum.text=score 
	end
	if (event.phase == "began" and event.object1.myName == "ocean" and event.object2.myName == "plane") then
	splash.isVisible=true
	splash.x = event.object2.x
	splash.y = event.object2.y
	splash:play()
	if sfx == true then
	audio.play(splashSound)	
	end
 	event.object2:removeSelf()
 	end	
 	if (event.phase == "began" and event.object1.myName == "ceiling" and event.object2.myName == "bullet") then
 		event.object2:removeSelf()
	end
	if (event.phase=="began" and event.object1.myName=="destroyer" and event.object2.myName=="plane") then
	print("plane-destroyer hard")
	explosion.x = event.object2.x
	explosion.y = event.object2.y+50
	explosion:play()
	if sfx == true then
	audio.play(boom)	
	end	
	event.object2:removeSelf()
	lives = lives-1
	livesNum.text = lives
	check4GameOverHard()
	end
end

function spawnBallHard(event)
	if event.phase == "began" then
	bullet = display.newCircle(gameScreenGroup, destroyer.x, 500, 6 )
	bullet.myName="bullet"
	physics.addBody(bullet, "static", {density = 0.1, bounce = 0, friction = .1, radius = 6})
	bulletMove = transition.to(bullet, {time = 500, x = destroyer.x , y = -10})
	end
end

function scene:enterScene(event)
	print("enterScene playHard")	
	storyboard.purgeAll()
--timers
	addPlaneTimer = timer.performWithDelay(600, addPlaneHard, 45)
	endTimer = timer.performWithDelay(30000, gameOverHard, 1)
	--timer for displayed timer
	countdownTimer=timer.performWithDelay(1000, tickingTimeHard, 30)

--audio
 	boom = audio.loadSound("boom.mp3") -- explosion sound
 	splashSound = audio.loadSound("splash.mp3") -- splashing noise

-- Listeners
	destroyer:addEventListener("touch", moveBoatSimHard)		
	Runtime:addEventListener("touch", spawnBallHard)
	Runtime:addEventListener("collision", removeObjectHard)
	Runtime:addEventListener("accelerometer", moveBoatHard)
	musicIcon:addEventListener("touch", onPlayTouchHard)
	sfxIcon:addEventListener("touch", toggleSoundHard)
end

function scene:exitScene(event )
	timer.cancel(addPlaneTimer)
	timer.cancel(endTimer)
	timer.cancel(countdownTimer)
	audio.stop()

-- Listeners		
	Runtime:removeEventListener("touch", spawnBallHard)
	Runtime:removeEventListener("collision", removeObjectHard)
	destroyer:removeEventListener("touch", moveBoatSimHard)
	Runtime:removeEventListener("accelerometer", moveBoatHard)
	musicIcon:removeEventListener("touch", onPlayTouchHard)
	sfxIcon:removeEventListener("touch", toggleSoundHard)	
end

function scene:destroyScene(event )
gameScreenGroup:removeSelf();
gameScreenGroup=nil
end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)

return scene