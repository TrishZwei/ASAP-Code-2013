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
	granola.x = 90
	granola.y = 90
	physics.addBody(granola, "static")
	screenGroup:insert(granola)

	granola2 = display.newImage("granolabar.png")
	granola2.x = 390
	granola2.y = 90
	physics.addBody(granola2, "static")
	screenGroup:insert(granola2)

	granola3 = display.newImage("granolabar.png")
	granola3.x = 90
	granola3.y = 160
	physics.addBody(granola3, "static")
	screenGroup:insert(granola3)

	granola4 = display.newImage("granolabar.png")
	granola4.x = 390
	granola4.y = 160
	physics.addBody(granola4, "static")
	screenGroup:insert(granola4)

	chocolatebar = display.newImage("chocolate-bar.png")
	chocolatebar.x = 240
	chocolatebar.y = 310
	physics.addBody(chocolatebar, "dynamic")
	screenGroup:insert(chocolatebar)

	MyTimer = timer.performWithDelay( 100, givePoints, 1)

	resetPnL()

end

--Lives and Points
	chocolatebarPoints=0
	chocolatebarLives=100
	granolaLives=1
	granola2Lives=1
	granola3Lives=1
	granola4Lives=1

	Points = display.newText("Points:"..chocolatebarPoints, 100, 0, "Verdana", 18)
	Points:setTextColor(200,100,0)

	Lives = display.newText("Lives:"..chocolatebarLives, 400, 0, "Verdana", 18)
	Lives:setTextColor(200,0,100)
function resetPnL()
	Lives.text="Lives:"..chocolatebarLives
	Points.text="Points:"..chocolatebarPoints
end

--chocolatebar's motion
function touchScreen(event)
	if event.phase == "ended" then
		print(event.x)
		transition.to(chocolatebar,{time=250, x=event.x, y=event.y})
	end
end


--Runtime:addEventListener("touch", touchScreen)

--Collisions
LivesText=""

function onCollision() 
	print("collide!")
	print(chocolatebar.x, chocolatebar.y)
	if ((chocolatebar.x > 45 and chocolatebar.x < 135) and (chocolatebar.y > 90 and chocolatebar.y < 118)) then
		if granolaLives >0 then 
			granolaLives = granolaLives-1
			print("granolaHit")
			
		end
	end

	if ((chocolatebar.x > 345 and chocolatebar.x < 435) and (chocolatebar.y > 90 and chocolatebar.y < 118)) then
		if granola2Lives >0 then 
			granola2Lives = granola2Lives-1
			print("granola2Hit")
		end	
	end

	if ((chocolatebar.x > 45 and chocolatebar.x < 135) and (chocolatebar.y > 160 and chocolatebar.y < 188)) then
		if granola3Lives >0 then 
			granola3Lives = granola3Lives-1
			print("granola3Hit")
		end
	end

	if ((chocolatebar.x > 345 and chocolatebar.x < 435) and (chocolatebar.y > 160 and chocolatebar.y < 188)) then
		if granola4Lives >0 then 
			granola4Lives = granola4Lives-1
			print("granola4Hit")
		end
	end

	if chocolatebarLives >0 then 
		chocolatebarLives = chocolatebarLives-1
	end
	
	if chocolatebarLives == 0 then
		--chocolatebar:removeSelf()
		chocolatebar.isVisible = false
		--print("chocolatebardead")
	end

	if granolaLives == 0 then		
		--granola:removeSelf()
		granola.isVisible = false
		print("granoladead")

	end
	
	if granola2Lives == 0 then
		--granola2:removeSelf()
		granola2.isVisible = false
		print("granola2dead")

	end

	if granola3Lives == 0 then
		--granola3:removeSelf()
		granola3.isVisible = false
		print("granola3dead")

	end
	
	if granola4Lives == 0 then
		--granola:removeSelf()
		granola4.isVisible = false
		print("granola4dead")
	end

Lives.text="Lives:"..chocolatebarLives
end

--Giving Points
function givePoints()
	chocolatebarPoints = chocolatebarPoints+5
	Points.text="Points:"..chocolatebarPoints
	myTimer = timer.performWithDelay( 100, givePoints)

	if chocolatebarLives==0 then
		print("gotorestartpg")
		timer.cancel(myTimer)
		storyboard.gotoScene("gameover","fade", 400)
	end
end


function scene:enterScene(event)
	--purge previous scene
	storyboard.purgeScene("gameover")
	--add the event listeners
	Runtime:addEventListener("collision", onCollision)
	Runtime:addEventListener("touch", touchScreen)
	-- body
end

function scene:exitScene(event)
	Runtime:removeEventListener("collision", onCollision)
	Runtime:removeEventListener("touch", touchScreen)

	-- body
end

function scene:destroyScene(event)
	granola=nil
	granola2=nil
	granola3=nil
	granola4=nil
end

-- scene event listeners
scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)

return scene

