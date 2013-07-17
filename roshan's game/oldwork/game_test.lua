--storyboard stuff
local storyboard = require ("storyboard")
local scene = storyboard.newScene()

 -- background 

function scene:createScene(event)

	local screenGroup = self.view
	--background images & stuff
	background = display.newImage("Chocolate-Background.jpg")
	screenGroup:insert(background)
	myText= display.newText("I'm working", 100, 90, "Times New Roman", 18)

	screenGroup:insert(startImage)
end


function start(event)
	if event.phase == "began" then
		--storyboard.gotoScene("game", "fade", 400)
		--print("start")
	end
end


function scene:enterScene(event)
	--add the event listeners
	background:addEventListener("touch", start)

end

function scene:exitScene(event)
	background:removeEventListener("touch", start)
end

function scene:destroyScene(event)	

end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)

return scene
