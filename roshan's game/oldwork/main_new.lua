--Gravity
display.setStatusBar(display.HiddenStatusBar)
local physics = require "physics"
physics.start()
physics.setGravity(0,0) 

--Storyboard
storyboard = require "storyboard"
local scene = storyboard.newScene()

function scene:createScene(event)
local screenGroup = self.view

--Background
local background = display.newImage("Street - Level 1.jpg")
screenGroup:insert(background)

--Setup for characters
local granola = display.newImage("granola bar.png")
granola.x = 90
granola.y = 90
physics.addBody(granola, "static")
screenGroup:insert(granola)

local granola2 = display.newImage("granola bar.png")
granola2.x = 200
granola2.y = 200
physics.addBody(granola2, "static")
screenGroup:insert(granola2)

local granola3 = display.newImage("granola bar.png")
granola3.x = 260
granola3.y = 120
physics.addBody(granola3, "static")
screenGroup:insert(granola3)

local granola4 = display.newImage("granola bar.png")
granola4.x = 350
granola4.y = 240
physics.addBody(granola4, "static")
screenGroup:insert(granola4)

local chocolatebar = display.newImage("chocolate-bar.png")
chocolatebar.x = 240
chocolatebar.y = 300
physics.addBody(chocolatebar, "dynamic")
screenGroup:insert(chocolatebar)

end
--Chocolate Bar's Functions - Moving and Shooting

--Moving
function touchScreen(event)
	if event.phase == "began" then
		print(event.y)
		transition.to(chocolatebar, {time= 200, x = event.x, y = 300})
	end
end


Runtime:addEventListener("touch", touchScreen)

-- --Collisions
-- function onCollision() 
-- 	--print("collide!)	
-- 	if chocolatebarLives == 0 then
-- 		chocolatebar:removeSelf()
-- 	end
-- end

-- function scene:enterScene(event)
-- 	--purge previous scene
-- 	storyboard.purgeScene("gameover")
-- 	--add the event listeners
-- 	Runtime:addEventListener("collision", onCollision)
-- 	Runtime:addEventListener("touch", touchScreen)

-- 	-- body
-- end

-- --Scene Change

-- function scene:exitScene(event)
-- 	Runtime:removeEventListener("collision", onCollision)
-- 	Runtime:removeEventListener("touch", touchScreen)

-- 	-- body
-- end

-- function scene:destroyScene(event)
-- end

-- -- scene event listeners
-- scene:addEventListener("createScene", scene)
-- scene:addEventListener("enterScene", scene)
-- scene:addEventListener("exitScene", scene)
--scene:addEventListener("destroyScene", scene)

--return scene