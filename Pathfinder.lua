local Pathfinder = {}

--This function is called on the server when this entity is created
function Pathfinder:Init()
	self.open = self:GetEntity().List:New()
	self.closed = self:GetEntity().List:New()
	self.path = self:GetEntity().List:New()
	self.parent = {}
	self.cost = {}
	self.start = nil
	self.goal = nil
end

function Pathfinder:FindPath(origin, destination)
	if origin == destination then return origin end
	-- if the Path is already calculated return target node, otherwise start new A* search
	if destination == self.goal then 
		local n = nil
		while self.path:Size() > 0 and target ~= origin do
			n = self.path[1]
			if n == origin then
				
				-- DEBUG ----------------------------------------
				--print('Target -> ' .. self.path[2]:GetName())
				-------------------------------------------------
				
				-- Return target node (next node from origin)
				return self.path[2]
			end
			self.path:RemoveIndex(1) -- Pop useless node (this is a target's parent node)
		end
	end
	-- Clear data structures
	clear(self)
	
	-- Save start and goal
	self.start = origin
	self.goal = destination
	print('Start -> ' .. self.start:GetName())
	print('Goal -> ' .. self.goal:GetName())
	print('Finding path...')
	
	-- Start new A* search
	self.open:Add(self.start)
	self.cost[self.start:GetName()] = 0
	A_Star(self)
	extractPath(self)
	
	-- Free some memory (keep the path and goal node)
	self.open:Clear()
	self.closed:Clear()
	self.parent = {}
	self.cost = {}
	self.start = nil
	
	-- DEBUG ------------------------------------------
	print('RUTA COMPLETA:')
	for _, n in self.path:Iterator() do
		print(n:GetName())
	end
	print('Target -> ' .. self.path:Get(2):GetName())
	---------------------------------------------------
	
	-- Return target node (next node from origin)
	if self.path:Size() == 0 then return nil end
	return self.path:Get(2)
end

-- Find the path using the A* search algorithm
function A_Star(self)
	local node = self.start -- Current node we are investigating
	while(self.open:Size() > 0) do
		-- Search node with min f(n) in the open list, pop it and close it
		local minNi = 1 -- index of node
		local minFn = math.huge -- Start with a huge number for finding the minimum
		if self.open:Size() > 1 then 
			for i, n in self.open:Iterator() do
				local fn = self.cost[n:GetName()]
				if fn < minFn then
					minFn = fn
					minNi = i
				end
			end
		end
		node = self.open:Get(minNi)
		-- For each successor of node
		local successors = node.NavMeshNode:GetProperties().SuccessorNodes
		for i=1, #successors do
			local s = successors[i]
			-- if n is goal, add node and goal to closed list and stop A* search
			if s == self.goal then
				self.closed:Add(node)
				self.closed:Add(self.goal)
				self.parent[self.goal] = node
				return 
			end
			-- if this sucessor hasn't been visited, add it to open list
			if not self.closed:Contains(s) and not self.open:Contains(s) then
				-- Set parent of s
				self.parent[s] = node
				-- Calculate f(n) and save it
				self.cost[s:GetName()] = self:f(s)
				-- Add s to open list
				self.open:Add(s)
			end
		end	
		
		-- Add node to closed list and remove it from open list
		self.closed:Add(node)
		self.open:RemoveIndex(minNi)
	end
end

-- Total cost of node n
function Pathfinder:f(n)
	return self:g(n) + self:h(n)
end
-- Cost from start to node n
function Pathfinder:g(n)
	return Vector.Distance(n:GetPosition(), self.start:GetPosition())
end
-- Cost from node n to goal
function Pathfinder:h(n)
	return Vector.SquaredDistance(n:GetPosition(), self.goal:GetPosition())
end

-- Extract the path using the parent map and save it into the path list
function extractPath(self)
	local inversedPath = self:GetEntity().List:New()
	inversedPath:Add(self.goal)
	-- Extract inversed path from the parents of valid nodes (from goal to start)
	local p = self.parent[self.goal]
	while p ~= nil do
		inversedPath:Add(p)
		p = self.parent[p]
	end
	-- Inverse the inversed path to get the correct path
	local i = inversedPath:Size()
	while i > 0 do
		self.path:Add(inversedPath:Get(i))
		i = i - 1
	end	
end

-- Clear all saved data (previous path) and reset the pathfinder
function clear(self)
	self.open:Clear()
	self.closed:Clear()
	self.path:Clear()
	self.parent = {}
	self.cost = {}
	self.start = nil
	self.goal = nil
end

return Pathfinder
