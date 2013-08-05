--storyboard stuff
local storyboard = require ("storyboard")
local scene = storyboard.newScene()
local params

--global assets
--positioning variables
local middleX=display.contentCenterX
local middleY=display.contentCenterY

-- Menu Screen
local helpScreenGroup	-- display.newGroup()
local helpScreen
local menuBtn
local creditsBtn
local musicIsPlaying
local sfx

 -- background 

function scene:createScene(event)
	print("I'm on the help screen")
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
	--background images & stuff
	helpScreenGroup=display.newGroup()
	helpScreen = display.newImage(helpScreenGroup, "helpScreen.jpg",0,0, true)

	myRoundedRect = display.newRoundedRect(helpScreenGroup,80, 170, (display.contentWidth *0.8)+20, (display.contentHeight*0.7)+10, 20)
	myRoundedRect.strokeWidth = 6
	myRoundedRect:setFillColor(255, 255, 255, 200)
	myRoundedRect:setStrokeColor(0, 0, 0)
	helpText = display.newText(helpScreenGroup, "Move your ship side to side by tilting your device. Stay out of the way of enemy planes to stay alive.\n\nFire your gun and destroy enemy planes by tapping the screen. Every plane shot down earns you points.\n\nScore as many points as you can in 30 seconds and stay alive. Good Luck!", 100, 190, display.contentWidth *0.8, display.contentHeight * 0.7, "Verdana", 40)
	helpText:setTextColor(0, 0, 0)

	menuBtn = display.newImage("menubtn.png")
	menuBtn:setReferencePoint(display.CenterReferencePoint)
	menuBtn.x = middleX+300; menuBtn.y = 100
	menuBtn.name = "menubutton"
	helpScreenGroup:insert(menuBtn)

	creditsBtn = display.newImage(helpScreenGroup,"creditsbtn.png")
	creditsBtn.x = middleX+10; creditsBtn.y = 100
	creditsBtn.name = "creditsbutton"
end

function helpLoadScreen(event)
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
	if event.target.name == "menubutton" then 
	print("menuBtn on helpScreen")
	storyboard.gotoScene("menuScreen", sceneOptions)
	elseif event.target.name == "creditsbutton" then 
	print("creditsBtn on helpScreen")
	storyboard.gotoScene("creditsScreen", sceneOptions)
	else
	print ("else in loadScreen on helpScreen")
	end
	transition.to(helpScreenGroup, {time=0, alpha=0,})

end


function scene:enterScene(event)
	storyboard.purgeAll()
-- Button Listeners		
	menuBtn:addEventListener("tap", helpLoadScreen)
	creditsBtn:addEventListener("tap", helpLoadScreen)
end

function scene:exitScene(event)
-- Button Listeners		
	menuBtn:removeEventListener("tap", helpLoadScreen)
	creditsBtn:removeEventListener("tap", helpLoadScreen)	
end

function scene:destroyScene(event )	

end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)

return scene


