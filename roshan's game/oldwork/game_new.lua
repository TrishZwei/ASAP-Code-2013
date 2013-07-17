--Gravity
local physics = require "physics"
physics.start()
physics.setGravity(0,0) 

--Storyboard
local storyboard = require "storyboard"
local scene = storyboard.newScene()

function scene:createScene(event)
	local screenGroup = self.view

--Background
	local background = display.newImage("Street-Level1.jpg")
	screenGroup:insert(background)

	granola = display.newImage("granolabar.png")
	granola.x = 240
	granola.y = 90
	granola.myName="granola"
	physics.addBody(granola, "static")
	screenGroup:insert(granola)

	chocolatebar = display.newImage("chocolate-bar.png")
	chocolatebar.x = 240
	chocolatebar.y = 310
	chocolatebar.myName = "ourHero"
	physics.addBody(chocolatebar, "static", {density = 1, friction = 0, bounce = 0,})
	screenGroup:insert(chocolatebar)

	MyTimer = timer.performWithDelay(100, givePoints, 1)
	oatsTimer = timer.performWithDelay(1000, fireOats, 1)

	resetPnL()	
end

--Lives and Points
	chocolatebarPoints=0
	chocolatebarLives=10
	granolaLives=8

	Points = display.newText("Points:"..chocolatebarPoints, 100, 0, "Verdana", 18)
	Points:setTextColor(200,100,0)

	Lives = display.newText("Lives:"..chocolatebarLives, 400, 0, "Verdana", 18)
	Lives:setTextColor(200,0,100)
function resetPnL()
	Lives.text="Lives:"..chocolatebarLives
	Points.text="Points:"..chocolatebarPoints
end

--needed to detect that the environment is the simulator...
local isSimulator = "simulator" == system.getInfo("environment")

-- Used to drag the chocolatebar on the simulator
function dragChocolatebar(event)

	if isSimulator then
		if event.phase == "began" then
			moveX = event.x - chocolatebar.x
		elseif event.phase == "moved" then
			chocolatebar.x = event.x - moveX
		end
	
		if((chocolatebar.x - chocolatebar.width * 0.5) < 0) then
			chocolatebar.x = chocolatebar.width * 0.5
		elseif((chocolatebar.x + chocolatebar.width * 0.5) > display.contentWidth) then
			chocolatebar.x = display.contentWidth - chocolatebar.width * 0.5
		end
		
	end
end

function moveChocolatebar(event)
	-- Accelerometer Movement
	--must be yGravity
	chocolatebar.x = display.contentCenterX - (display.contentCenterX * (event.yGravity*3))
		
	-- Wall Borders 
	
	if((chocolatebar.x - chocolatebar.width * 0.5) < 0) then
		chocolatebar.x = chocolatebar.width * 0.5
	elseif((chocolatebar.x + chocolatebar.width * 0.5) > display.contentWidth) then
		chocolatebar.x = display.contentWidth - chocolatebar.width * 0.5
	end
end

function fireChocolate(event)
	if event.phase == "ended" then
--Fires Chocolate Weapon
		chocolate = display.newImage("chocolateweapon.png",chocolatebar.x, chocolatebar.y)	
		chocolate.myName="chocolate"
		physics.addBody(chocolate, "dynamic")
		transition.to(chocolate,{time=1300, x=chocolate.x, y=-400})
	end
end

function fireOats(event)
	print("I hate chocolate")
--Fires Oat Gun
	if granolaLives > 0 then
		
		oats = display.newImage("oats.png",granola.x, granola.y)
		oats.myName="oats"
		physics.addBody(oats, "dynamic")
		--oats.collision=onCollision
		--oats:addEventListener("collision", oats)
		--oatsTimer = timer.performWithDelay(100, fireOats)
		oats.collision = onCollision
		oats:addEventListener("collision", oats)
		transition.to(oats, {time = 300 , y = 400, onComplete = function(self) self.parent:remove(self); self=nil;end})
	elseif granolaLives == 0 then
		--oats:removeSelf()
		storyboard.gotoScene("gameover","fade", 400)
	end
end



function onCollision(event)
	--print("chocolatepower")
	if (event.phase == "began" and event.object1.myName == "granola" and event.object2.myName == "chocolate") then
 		print("collide")
 		if granolaLives > 0 then  
			granolaLives = granolaLives-1
			print("granolaHit")
		end
		if granolaLives == 0 then		
			--granola:removeSelf()
			--granola.isVisible = false
			--granola=nil
			--storyboard.gotoScene("gameover","fade", 400)

			print("granoladead")
		end
 	elseif (event.phase == "began" and event.object1.myName == "oats" and event.object2.myName == "chocolatebar") then
	--if (object1.myName == "chocolatebar" and object2.myName == "oats") then
		print("diechocolatebardie")
		if chocolatebarLives >0 then 
			chocolatebarLives = chocolatebarLives-1
		end
		if chocolatebarLives == 0 then
			chocolatebar:removeSelf()
			--chocolatebar.isVisible = false
			chocolatebar=nil
			storyboard.gotoScene("gameover","fade", 400)
			print("chocolatebardead")
		end
	end
end
-- function onCollision(event2)

-- end

function givePoints()
	chocolatebarPoints = chocolatebarPoints+5
	Points.text="Points:"..chocolatebarPoints
	myTimer = timer.performWithDelay( 100, givePoints)

	if chocolatebarLives==0 or granolaLives == 0 then
		print("gotorestartpg")
		granola = nil
		storyboard.gotoScene("gameover","fade", 400)
	end
end


function scene:enterScene(event)
	print("enterscene")
	--purge previous scene
	storyboard.purgeScene("gameover")
	--add the event listeners
	Runtime:addEventListener("accelerometer", moveChocolatebar) 
	chocolatebar:addEventListener("touch", dragChocolatebar)
	Runtime:addEventListener("touch", fireChocolate)
	Runtime:addEventListener("collision", onCollision)
	Runtime:addEventListener("enterFrame", fireOats)
	--Runtime:addEventListener("oatsTimer", fireOats)
end

function scene:exitScene(event)
	Runtime:removeEventListener("accelerometer", moveChocolatebar) 
	chocolatebar:removeEventListener("touch", dragChocolatebar)
	Runtime:removeEventListener("touch", fireChocolate)
	Runtime:removeEventListener("collision", onCollision)
	Runtime:removeEventListener("enterFrame", fireOats)
	timer.cancel(myTimer)
	--Runtime:removeEventListener("oatsTimer", fireOats)
end

function scene:destroyScene(event)
 -- exterminate the granola bar
end

-- scene event listeners
scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)

return scene