display.setStatusBar(display.HiddenStatusBar)

local middleX=display.contentCenterX
local middleY=display.contentCenterY
local right=display.contentWidth
local left=0
local top=0
local bottom=display.contentHeight
local canDrag = true
local vy = 3 
local vx = -3
local bias
local inaccuracy

local physics = require "physics"
physics.start()
physics.setGravity(-10,20)

local player = display.newRect(50,220, 20, 150)
physics.addBody( player, "static", { density=3.0, friction=0.5, bounce=1 } )
local cpu = display.newRect(1070,220, 20, 150)
physics.addBody( cpu, "static", { density=3.0, friction=0.5, bounce=1 } )

local ceiling = display.newRect(0, 0, display.contentWidth, 20)
local floor = display.newRect(0, 620, display.contentWidth, 20)
local leftWall = display.newRect(0, 0, 20, display.contentHeight)
local rightWall = display.newRect(1120, 0, 20, display.contentHeight)

physics.addBody( ceiling, "static", { density=3.0, friction=0.5, bounce=1 } )
physics.addBody( floor, "static", { density=3.0, friction=0.5, bounce=1 } )
physics.addBody( leftWall, "static", { density=3.0, friction=0.5, bounce=1 } )
physics.addBody( rightWall, "static", { density=3.0, friction=0.5, bounce=1 } )

touchSensor=display.newImage("assets/touchSensor.png") -- The touch bounds for moving the player
touchSensor.x, touchSensor.y=left+100, middleY

local ball = display.newCircle(display.contentWidth/2, display.contentHeight/2, 15)
physics.addBody( ball, "dynamic", { density=1.0, friction=0, bounce=1.1 } )
		
	function touchPlayer(event)
		if "began"==event.phase then
			player.y1=event.y-player.y
			player.prevY=player.y
			display.getCurrentStage():setFocus(touchSensor) -- Set focus to touchSensor
			touchSensor.isFocus=true
		elseif touchSensor.isFocus then
			if "moved"==event.phase and canDrag then -- Only if canDrag is active
				if event.y-player.y1>=top+60 and event.y-player.y1<=bottom-60 then -- Snap to bounds
					player.y=event.y-player.y1 -- Reposition player
				elseif event.y-player.y1<top+60 then
					player.y=top+60
				elseif event.y-player.y1>bottom-60 then
					player.y=bottom-60
				end
				player.moveSpeed=player.y-player.prevY -- MoveSpeed is the difference between previous position and new position - the faster you move, the more it is
				player.prevY=player.y -- Reset prevY
				
			elseif "ended"==event.phase then
				display.getCurrentStage():setFocus(nil) -- "Un-focus" the touchSensor
				touchSensor.isFocus=false
			end
		end
	end
	touchSensor:addEventListener("touch", touchPlayer)
	-- Add listener

function cpuPaddle(event)

 -- AI for the topPaddle
inaccuracy = math.random(-40,40)
 
if(cpu.y < ball.y + 10) then
    cpu.y = ball.y
  elseif(cpu.y > ball.y - 10) then
    cpu.y = ball.y
  end

--make sure the AI paddle stays within the boundary of the game
end
Runtime:addEventListener("enterFrame", cpuPaddle)

function bounce(event)
	--changed all x for y and ys for xes
	print(event.target.name)
	vx = -3
	if ((ball.y + ball.height * 0.5 )< player.y) then
		vy = -vy
	elseif((ball.y + ball.height * 0.5) >= player.y) then
		vy=vy
	end
end

function bounce2(event)
	--changed all x for y and ys for xes
	print(event.target.name)
	vx = 3
	if ((ball.y + ball.height * 0.5 )< cpu.y) then
		vy = -vy
	elseif((ball.y + ball.height * 0.5) >= cpu.y) then
		vy=vy
	end

end

function updateBall()
-- exchanged all xes for ys
	ball.y = ball.y+vy
	ball.x = ball.x+vx
	if ball.y < 0 or ball.y +ball.height > display.contentHeight then
		vy = -vy
	end
end	

function gameListeners(event)
	if event == "add" then
		Runtime:addEventListener("accelerometer", movePaddle)
		Runtime:addEventListener("enterFrame", updateBall)

		playerPaddle:addEventListener("touch", dragPaddle)
	elseif event == "remove" then
		Runtime:removeEventListener("accelerometer", movePaddle)
		Runtime:removeEventListener("enterFrame", updateBall)
		player:removeEventListener("collision", bounce)
		cpu:removeEventListener("collision", bounce2)
		player:removeEventListener("touch", dragPaddle)
	end

end	

function changeGravity()
	physics.setGravity(0,0)
end

player:addEventListener("collision", changeGravity)
