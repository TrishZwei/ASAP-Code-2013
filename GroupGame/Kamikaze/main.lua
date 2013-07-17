--My Breakout Game
-- Hide Status Bar

display.setStatusBar(display.HiddenStatusBar)

-- Physics Engine
		
local physics = require "physics"
physics.start()
--this will allow the ball to bounce around the screen freely
physics.setGravity(0, 0)

system.setAccelerometerInterval(100)

-- Menu Screen

local menuScreenGroup	-- display.newGroup()
local mmScreen
local playBtn

-- Game Assets

local plane
local destroyer
local bullet

-- Score/Level Text

local scoreText
local scoreNum
local levelText
local levelNum

local _W = display.contentWidth / 2
local _H = display.contentHeight / 2
local score = 0
local scoreIncrease = 100

--the accelerometer events can only be tested on a device so we're 
--going to add a variable for touch events on the baddle by calling the simulator environment

local isSimulator = "simulator" == system.getInfo("environment")

--this is the start of our game
function main()
	mainMenu()
end	

function mainMenu()
--this is the start screen
--art goes here

-- Button Listeners
--code for button to call loadGame
--code for button to call helpScreen
		
end

function helpScreen(event)
--code to remove the start screen
-- code to display help/instructions
--event listeners for button to startGame

end


function loadGame(event)
--removes helpscreen and or startscreen
--then calls startGame
end

-- Used to move the boat on the simulator

function moveBoatSim(event)
	if isSimulator then	
		--code to move the boat in the simulator
	end
	
end


function moveBoat(event)
	-- Accelerometer Movement
end

function startGame()
	-- Physics
	--load the assets:
	--boat, planes
	gameListeners(add)
end


function gameListeners(event)
	if event == "add" then
	--add any necessary event listeners
	elseif event == "remove" then
	--remove any necessary event listeners
	end
end	

function addPlane(event)
--add plane then call the update plane function to move the plane.
end	

function removePlane(event)
	-- check if the plane gets hit
	--add points
end

function movePlane()
--code that moves the plane
end
 
--alert screen
function check4GameOver(event)
	--time's up
	--0 lives
end

function gameOver (event)
--You lose
--the game over screen and restart button
	gameListeners(remove)

end	

function restart()
--the code to restart the game
end

main()

















