--storyboard stuff
local storyboard = require ("storyboard")
local scene = storyboard.newScene()
local params

--global assets
--positioning variables
local middleX=display.contentCenterX
local middleY=display.contentCenterY

-- Menu Screen
local creditsScreenGroup	-- display.newGroup()
local creditsScreen
local helpBtn
local menuBtn
local musicIsPlaying
local sfx

 -- background 

function scene:createScene(event)
print("I'm on the credits screen")
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
	creditsScreenGroup=display.newGroup()
	creditsScreen = display.newImage(creditsScreenGroup, "creditsScreen.jpg",0,0, true)

	myRoundedRect = display.newRoundedRect(creditsScreenGroup,80, 170, (display.contentWidth *0.8)+20, (display.contentHeight*0.7)+10, 20)
	myRoundedRect.strokeWidth = 6
	myRoundedRect:setFillColor(255, 255, 255, 200)
	myRoundedRect:setStrokeColor(0, 0, 0)
	creditsText = display.newText(creditsScreenGroup, "Game Code: Abigail Kineston, Arik Lemon, Austin Beaart, Nicholas Burton, Roshan Srinivasan, Samantha Yim with assistance from Trish Ladd.\n\nGame Art: Trish Ladd\n\nMusic: Arik Lemon\n\nSound: FreeSFX http://www.freesfx.co.uk", 100, 190, display.contentWidth *0.8, display.contentHeight * 0.7, "Verdana", 40)
	creditsText:setTextColor(0, 0, 0)


	menuBtn = display.newImage("menubtn.png")
	menuBtn:setReferencePoint(display.CenterReferencePoint)
	menuBtn.x = middleX+300; menuBtn.y = 100
	menuBtn.name = "menubutton"
	creditsScreenGroup:insert(menuBtn)

	helpBtn = display.newImage(creditsScreenGroup,"helpbtn.png")
	helpBtn.x = middleX+10; helpBtn.y = 100
	helpBtn.name = "helpbutton"

end

function creditsLoadScreen(event)
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
	print("menuBtn on creditsScreen")
	storyboard.gotoScene("menuScreen", sceneOptions)
	elseif event.target.name == "helpbutton" then 
	print("helpBtn on creditsScreen")
	storyboard.gotoScene("helpScreen", sceneOptions)
	else
		print("else in loadScreen on creditsScreen")
	end
	transition.to(creditsScreenGroup, {time=0, alpha=0,})
end


function scene:enterScene(event)
	storyboard.purgeAll()
-- Button Listeners		
	menuBtn:addEventListener("tap", creditsLoadScreen)
	helpBtn:addEventListener("tap", creditsLoadScreen)
end

function scene:exitScene(event )
-- Button Listeners		
	menuBtn:removeEventListener("tap", creditsLoadScreen)
	helpBtn:removeEventListener("tap", creditsLoadScreen)
end

function scene:destroyScene(event )	

end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)

return scene


