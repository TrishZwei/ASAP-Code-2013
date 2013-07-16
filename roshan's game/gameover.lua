local storyboard = require ("storyboard")
local scene = storyboard.newScene()

 -- background 

function scene:createScene(event)
	--purge previous scene
	print("inrestartpg")
	storyboard.purgeScene("game_new_bkup")
	--add the event listeners

	local screenGroup = self.view
	--background images & stuff
	background = display.newImage("Chocolate-Background.jpg")
	screenGroup:insert(background)

	gameoverImage = display.newImage("gameover.png")
	--startImage:setReferencePoint(display.BottomLeftReferencePoint)
	gameoverImage.x=240
	gameoverImage.y=160
	screenGroup:insert(gameoverImage)
end


function gameover(event)
	if event.phase == "began" then
		storyboard.gotoScene("game_new_bkup", "fade", 400)
	end
end


function scene:enterScene(event)
	--add the event listeners
	background:addEventListener("touch", gameover)

end

function scene:exitScene(event)
	chocolatebarPoints=0
	chocolatebarLives=20
	granolaLives=10
	background:removeEventListener("touch", gameover)
end

function scene:destroyScene(event )	
	chocolatebarPoints=0
	chocolatebarLives=20
	granolaLives=10
end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)

return scene