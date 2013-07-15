display.setStatusBar(display.HiddenStatusBar)
local physics = require "physics"
physics.start()
physics.setGravity(0,0)

local menuScreenGroup
local mmScreen
local playbtn

--game screen
local background
local penguin
local alligator

-- ending game screen
local menuEndScreenGroup
local resetBtn

--variables
local _H=display.contentHeight/2 
local _W=display.contentWidth/2


--sound asset moved up with other variables...
local hity = audio.loadSound("hit2.mp3")

--variable to store points moved to top
local myPoints = 0

function main()
	mainMenu()
end	

function mainMenu()
--display group this is empty until object are inserted in it
	menuScreenGroup=display.newGroup()
	mmScreen = display.newImage("mmScreen.png", 0,0, true)
	mmScreen.x =300; mmScreen.y = 470

	playBtn = display.newImage("playbtn.png")
	playBtn:setReferencePoint(display.CenterReferencePoint)
	playBtn.x = 125; playBtn.y = 400
	playBtn.name = "playbutton"

	menuScreenGroup:insert(mmScreen)
	menuScreenGroup:insert(playBtn)

-- Button Listeners
		
	playBtn:addEventListener("tap", loadGame)
end

function loadGame(event)
	if event.target.name == "playbutton" then
		-- Start Game				
		transition.to(menuScreenGroup,{time = 0, alpha=0, onComplete = addGameScreen})
		playBtn:removeEventListener("tap", loadGame)
	end
end

function loadGames(event)
	if event.target.name == "resetbutton" then
		-- Start Game
		transition.to(menuEndScreenGroup,{time = 0, alpha=0, onComplete = addGameScreen})
		resetBtn:removeEventListener("tap", loadGame)
	end
end

function addGameScreen()
	background = display.newImage("background.jpg")	
	background.x = 250; background.y = 325
	

	penguin = display.newImage("penguin.png")
	penguin.myName = "penguin"
	penguin.x=math.random(20,450)
	penguin.y=math.random(20,450)
	penguin.width = 60
	penguin.height = 60
	physics.addBody(penguin, "static")

	alligator = display.newImage("alligator.png")
	alligator.myName="alligator"
	alligator.x = 100
	alligator.y = 100
	alligator.width = 115
	alligator.height = 115
	physics.addBody(alligator, "dynamic") 


--stuff to go into your game function because it governs your main game area.
movePenguin()

gameTimer =timer.performWithDelay(60000, gameOver)

Runtime:addEventListener("collision", onCollision)
Runtime:addEventListener("touch", touchScreen)
end

--respond to touch events
function touchScreen(event)
		if event.phase == "ended" then
			transition.to(alligator,{time=1000, x=event.x, y=event.y})
		end 
end


--create penguin movement
function movePenguin()
pengMove = transition.to(penguin, {time=1000, x=math.random(20,300), y=math.random(20,450), onComplete=movePenguin})
end


function gameOver()
	display.remove(penguin)
	display.remove(alligator)
	--remove event listeners in your addGameScreen function here:
	Runtime:removeEventListener("collision", onCollision)
	Runtime:removeEventListener("touch", touchScreen)
	--add text, images etc. potentially any event listeners to restart the game here.
	menuEndScreenGroup = display.newGroup()
	resetBtn = display.newImage("resetBtn.png")
	resetBtn:setReferencePoint(display.CenterReferencePoint)
	resetBtn.x = 125; resetBtn.y = 400
	resetBtn.name = "resetbutton"

	menuEndScreenGroup:insert(resetBtn)

	--Button Listner
	resetBtn:addEventListener("tap", loadGames)


end

function addNewPenguin()
	myPoints = myPoints+1
	print(myPoints)
	penguin.isVisible=true
	penguin.x=math.random(20,300)
	penguin.y=math.random(20,450)
	movePenguin()
end


function onCollision(event)	
	audio.play(hity)
   	if ( event.phase == "ended" ) then
  --	print( "ended: " .. event.object1.myName .. " & " .. event.object2.myName )
   	penguin.isVisible=false
   	transition.cancel(pengMove)
   	pengTimer=timer.performWithDelay(50, addNewPenguin)
   end	

end

main()
