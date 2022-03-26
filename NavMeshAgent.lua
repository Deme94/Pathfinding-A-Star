local NavMeshAgent = {}

-- Script properties are defined here
NavMeshAgent.Properties = {
	-- Example property
	--{name = "health", type = "number", tooltip = "Current health", default = 100},
	{name = "Pathfinder", type = "entity"},
	{name = "NavMesh", type = "entity"},
	{name = "Speed", type = "number"},
	{name = "StoppingDistance", type = "number", tooltip = "Stopping distance (cm)"},
}


--This function is called on the server when this entity is created
function NavMeshAgent:Init()
	self.pathfinder = self:GetProperties().Pathfinder.Pathfinder
	self.navMesh = self:GetProperties().NavMesh.NavMesh
	self.speed = self:GetProperties().Speed
	self.stoppingDistance = self:GetProperties().StoppingDistance
	
	self.UPDATE_WAIT = 0.5 -- wait time in seconds for updating the path
	self.t = 0
	
	self.destination = nil -- Final position the agent will reach
	self.targetPosition = nil -- Current position the agent is moving to
end

--This function is called each frame (update loop)
function NavMeshAgent:OnTick(dt)
	self.t = self.t + dt
	if self.t > self.UPDATE_WAIT then
		self.t = 0
		if self.destination ~= nil then 
			self.pos = self:GetEntity():GetPosition()
			updatePath(self)
		end
	end
	if self.targetPosition ~= nil then 
		-- Get direction from agent to targetPosition
		local forward = self.targetPosition - self.pos
		forward = forward:Normalize() * self.speed
		-- Set agent rotation (forward)
		local lerpRotation = Vector.Lerp(self:GetEntity():GetForward(), forward, 0.01 * dt)
		self:GetEntity():SetForward(lerpRotation)
		-- Move agent forward
		if Vector.Distance(self:GetEntity():GetPosition(), self.destination) < self.stoppingDistance then
			self:GetEntity():SetVelocity(Vector.Zero)
		else
			self:GetEntity():SetVelocity(forward)
		end
	end
end

-- Set the self.destination of the agent
function NavMeshAgent:SetDestination(d)
	self.destination = d
end

-- Find a new path if needed, otherwise just update the targetPosition
function updatePath(self)
	local currentNode = self.navMesh:FindNodeInPosition(self.pos)
	if currentNode == nil then return end -- just in case the agent is out of the navmesh limits
	local destinationNode = self.navMesh:FindNodeInPosition(self.destination)
	if destinationNode == nil then return end -- just in case the agent is out of the navmesh limits
	
	-- if agent is in the same node as destination, then go to destination
	if currentNode == destinationNode then
		self.targetPosition = self.destination
		return
	end
	
	-- Find path (the next node to go) from agent's position to the target's position
	local targetNode = self.pathfinder:FindPath(currentNode, destinationNode)
	
	-- if the target node is the same as the previous one, then return
	if self.previousTargetNode == targetNode then return end 
	self.previousTargetNode = targetNode
	
	-- Set targetPosition as the middle point between the closest position from the agent to targetNode
	-- and the closest position from targetNode to destination
	local closestPointToNextNode = targetNode.NavMeshNode:GetClosestPoint(self.pos)
	local closesPointFromNextNodeToTarget = targetNode.NavMeshNode:GetClosestPoint(self.destination)
	local m = Vector.New((closestPointToNextNode.x + closesPointFromNextNodeToTarget.x) / 2, 
						(closestPointToNextNode.y + closesPointFromNextNodeToTarget.y) / 2, 
						0)
	self.targetPosition = m
end
	
return NavMeshAgent

