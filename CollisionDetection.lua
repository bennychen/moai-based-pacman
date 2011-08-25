--
--------------------------------------------------------------------------------
--         FILE:  CollisionDetection.lua
--        USAGE:  ./CollisionDetection.lua 
--  DESCRIPTION:  
--      OPTIONS:  ---
-- REQUIREMENTS:  ---
--         BUGS:  ---
--        NOTES:  ---
--       AUTHOR:   (), <>
--      COMPANY:  
--      VERSION:  1.0
--      CREATED:  08/22/2011 20:29:43 CST
--     REVISION:  ---
--------------------------------------------------------------------------------
--

CollisionDetection = {} 

function CollisionDetection.willCollideWall( gameMap, entity, direction )
	if ( not entity:is_a( GameEntity ) )
	then
		print( "ERROR @ CollisionDetection:willCollideWall - " ..
			   "entity is not a GameEntity" )
		return
	end

	local leftTopX = 0
	local leftTopY = 0
	local rightBottomX = 0
	local rightBottomY = 0
	leftTopX, leftTopY = entity:getLeftTopLoc() 
	rightBottomX, rightBottomY = 
		entity:getRightBottomLoc( leftTopX, leftTopY )

	entitySpeed = entity.velocity.speed
	local displacementX = 0
	local displacementY = 0
	local vel = Velocity( entitySpeed, direction )
	displacementX, displacementY = vel:getDisplacement( FRAME_TIME )
	leftTopX = leftTopX + displacementX
	leftTopY = leftTopY + displacementY
	rightBottomX = rightBottomX + displacementX
	rightBottomY = rightBottomY + displacementY

	return gameMap:isCollidingWall( leftTopX, leftTopY, 
			rightBottomX, rightBottomY )
end

function CollisionDetection.willCollideBar( gameMap, entity, direction )
	local leftTopX = 0
	local leftTopY = 0
	local rightBottomX = 0
	local rightBottomY = 0
	leftTopX, leftTopY = entity:getLeftTopLoc() 
	rightBottomX, rightBottomY = 
		entity:getRightBottomLoc( leftTopX, leftTopY )

	entitySpeed = entity.velocity.speed
	local displacementX = 0
	local displacementY = 0
	local vel = Velocity( entitySpeed, direction )
	displacementX, displacementY = vel:getDisplacement( FRAME_TIME )
	leftTopX = leftTopX + displacementX
	leftTopY = leftTopY + displacementY
	rightBottomX = rightBottomX + displacementX
	rightBottomY = rightBottomY + displacementY

	return gameMap:isCollidingBar( leftTopX, leftTopY, 
			rightBottomX, rightBottomY )
end

function CollisionDetection.isCollidingWall( gameMap, entity )
	local leftTopX = 0
	local leftTopY = 0
	local rightBottomX = 0
	local rightBottomY = 0
	leftTopX, leftTopY = entity:getLeftTopLoc() 
	rightBottomX, rightBottomY = 
		entity:getRightBottomLoc( leftTopX, leftTopY )

	return gameMap:isCollidingWall( leftTopX, leftTopY, 
			rightBottomX, rightBottomY )
end

function CollisionDetection.isCollidingBar( gameMap, entity )
	local leftTopX = 0
	local leftTopY = 0
	local rightBottomX = 0
	local rightBottomY = 0
	leftTopX, leftTopY = entity:getLeftTopLoc() 
	rightBottomX, rightBottomY = 
		entity:getRightBottomLoc( leftTopX, leftTopY )

	return gameMap:isCollidingBar( leftTopX, leftTopY, 
			rightBottomX, rightBottomY )
end

function CollisionDetection.isEntityColliding( entity1, entity2 )
	if ( entity1.visible == true and entity2.visible == true )
	then
		local entity1LeftTopX
		local entity1LeftTopY
		local entity1RightBottomX
		local entity1RightBottomY
		local entity2LeftTopX
		local entity2LeftTopY
		local entity2RightBottomX
		local entity2RightBottomY

		entity1LeftTopX, entity1LeftTopY = entity1:getLeftTopLoc()
		entity1RightBottomX, entity1RightBottomY = 
			entity1:getRightBottomLoc( entity1LeftTopX, entity1LeftTopY )
		
		entity2LeftTopX, entity2LeftTopY = entity2:getLeftTopLoc()
		entity2RightBottomX, entity2RightBottomY = 
			entity2:getRightBottomLoc( entity2LeftTopX, entity2LeftTopY )

		if ( entity1LeftTopX > entity2RightBottomX or
			 entity1LeftTopY > entity2RightBottomY or
			 entity2LeftTopX > entity1RightBottomX or
			 entity2LeftTopY > entity1RightBottomY )
		then
			return false
		else
			return true
		end
	end
	return false
end

function CollisionDetection.willOverBound( gameMap, entity, direction )
	if ( not entity:is_a( GameEntity ) )
	then
		print( "ERROR @ CollisionDetection:willCollideWall - " ..
			   "entity is not a GameEntity" )
		return
	end

	local leftTopX = 0
	local leftTopY = 0
	local rightBottomX = 0
	local rightBottomY = 0
	leftTopX, leftTopY = entity:getLeftTopLoc() 
	rightBottomX, rightBottomY = 
		entity:getRightBottomLoc( leftTopX, leftTopY )

	entitySpeed = entity.velocity.speed
	local displacementX = 0
	local displacementY = 0
	local vel = Velocity( entitySpeed, direction )
	displacementX, displacementY = vel:getDisplacement( FRAME_TIME )
	leftTopX = leftTopX + displacementX
	leftTopY = leftTopY + displacementY
	rightBottomX = rightBottomX + displacementX
	rightBottomY = rightBottomY + displacementY

	return gameMap:isOverBound( leftTopX, leftTopX, rightBottomX, rightBottomY )
end

function CollisionDetection.isOverBound( gameMap, entity )
	local leftTopX = 0
	local leftTopY = 0
	local rightBottomX = 0
	local rightBottomY = 0
	leftTopX, leftTopY = entity:getLeftTopLoc() 
	rightBottomX, rightBottomY = 
		entity:getRightBottomLoc( leftTopX, leftTopY )
	return gameMap:isOverBound( leftTopX, leftTopY, rightBottomX, rightBottomY ) 
end

function CollisionDetection.willPacmanCollideBarrier( gameMap, pacman, direction )
	return CollisionDetection.willCollideWall( gameMap, pacman, direction ) or
		   CollisionDetection.willCollideBar( gameMap, pacman, direction )
end


function CollisionDetection.willGhostCollideBarrier( gameMap, ghost, direction )
	if ( CollisionDetection.willCollideWall( gameMap, ghost, direction ) )
	then
		return true
	end
	if ( ghost.canCrossBar == false and 
		 CollisionDetection.willCollideBar( gameMap, ghost, direction ) )
	then
		return true
	end
	return false
end
