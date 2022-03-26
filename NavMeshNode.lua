local NavMeshNode = {}

-- Script properties are defined here
NavMeshNode.Properties = {
	-- Example property
	--{name = "health", type = "number", tooltip = "Current health", default = 100},
	
	-- Corners
	{name = "Corner1", type = "entity"},
	{name = "Corner2", type = "entity"},
	{name = "SuccessorNodes", type = "entity", tooltip = "attach all successor nodes", container = "array"},
}


--This function is called on the server when this entity is created
function NavMeshNode:Init()
	local pos1 = self:GetProperties().Corner1:GetPosition()
	local pos2 = self:GetProperties().Corner2:GetPosition()
	-- self.x1 is the min x and self.x2 is the max x
	if pos1.x < pos2.x 
	then self.x1 = pos1.x; self.x2 = pos2.x
	else self.x1 = pos2.x; self.x2 = pos1.x 
	end
	-- self.y1 is the min y and self.y2 is the max y
	if pos1.y < pos2.y 
	then self.y1 = pos1.y; self.y2 = pos2.y
	else self.y1 = pos2.y; self.y2 = pos1.y 
	end
end

-- Check if this node contains a given position (point inside rectangle)
function NavMeshNode:Contains(pos)
	local x = pos.x
	local y = pos.y
	if self.x1 < x and x < self.x2 and self.y1 < y and y < self.y2 
	then 
		return true 
	end
	return false
end

-- Return the closest point (x, y) from this node to a given position
function NavMeshNode:GetClosestPoint(pos)
	local x = pos.x
	local y = pos.y
	if not (self.x1 < x and x < self.x2) then
		if x < self.x1 then 
			x = self.x1 
		else 
			x = self.x2
		end 
	end
	if not (self.y1 < y and y < self.y2) then
		if y < self.y1 then 
			y = self.y1 
		else 
			y = self.y2
		end 
	end
	
	return Vector.New(x, y, 0)	
end

return NavMeshNode
