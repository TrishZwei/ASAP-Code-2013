display.setStatusBar(display.HiddenStatusBar)

	local menuScreenGroup display.newGroup()
	local mmScreen 
	local playcastle

--main menu


local testText = display.newText("Castle Dungeon Doors", 50, 650, "Arial", 50)
--testText.text="whatever you want in here"

--function main()
	--mainMenu()
--end 

--function mainMenu()
		
		--menuScreenGroup = display.newGroup()
	
	--mmScreen = display.newImage ("castle.jpeg", 0, 0, true)
		--x.Scale = 5
		--y.Scale = 5

	--mmScreen.x = 500
	--mmScreen.y = 500
	
	--local playBtn  
  	--playBtn = display.newImage("start.jpeg")
  	--playBtn.name = "startBtn"	
	--playBtn:setReferencePoint(display.CenterReferencePoint)
	--playBtn.x = 300
	--playBtn.y = 350 
	

  	--local function listener(event)
  	  --if event.phase == "began" then 
		--print ("The button was pushed")

  	 --end 
  	--end 	

  	--playBtn:addEventListener("touch", listener)

	--menuScreenGroup:insert(mmScreen)
	--menuScreenGroup:insert(playBtn)	
--end 

--function loadGame(event)
	--if event.target.name == "playbutton" then 
		--transition.to(menuScreenGroup,{time = 0, alpha = 0, onComplete = 
--addGameScreen})
		--playBtn:removeEventListener("playbutton", loadGame)
	--end
--end 

--function addGameScreen()
	--body
--end
	
	local background = display.newImage("background.jpeg")
	
	nightmare = audio.play("nightmare.mp3") 

	local door1 = display.newImage("door.jpg")
	door1.x = 100	
	door1.y = 200

	local tiger 
	tiger = display.newImage("tiger.jpeg")
	tiger.x = 300
	tiger.y = 1000

	local directText = display.newText("Choose a door to open", 50, 500, "Arial", 50)
  	
  	--add corridor 1

	--program door to open for each choice
	local door3 = display.newImage( "door.jpg" )
	door3.x = 500
	door3.y = 200 

	--local door3 = display.newText( "door 3", 160, 800, "Arial", 100 )
	local trap
	trap = display.newImage("trap.jpeg")
	trap.x = 100
	trap.y = 1000
	
	--sound
	nightmare = audio.loadSound("nightmare.mp3")

function openDoor1 (event) 
	testText.text="You got eaten by a tiger"	
	audio.play("nightmare.mp3")
	display.remove(door1)
	transition.to(tiger, {alpha=255, x=100, y=200, "fade in"})
	
	--once doors are removed... add an image and have it come in with 
	--a transition to animation or 
	--to do a fade in alpha=255 or read up on easing


	end
	--event listener
	door1:addEventListener("touch", openDoor1)

	local door2 = display.newImage("door.jpg")
	door2.x = 300
	door2.y = 200
	
	local treasure 
	treasure = display.newImage("treasure.jpeg")
	treasure.x = 500
	treasure.y = 1000


function openDoor2(event)
		testText.text="the treasure room"	
		display.remove(door2)
		display.remove(door3)	
		if event.phase == "began" then 
			transition.to(treasure, {alpha=255, x=300, y=200, "fade in"})
			transition.dissolve(door1, {alpha=255, x=100,y=200, "fade"})
			transition.to(door3, {alpha=0, x=500,y=200, "fade"})

		end
	end

	--event listener
	door2:addEventListener("touch", openDoor2)

function openDoor3( event )
		testText.text="You are trapped"	
		display.remove(door3)
		if event.phase == "began" then 
			transition.to(trap,{alpha=255, x=500, y=200, "fade"})

end		end

		

	--event listener
	door3:addEventListener( "touch", openDoor3) 
 	 
	--add animations/pictures and text

	
	
	
	



