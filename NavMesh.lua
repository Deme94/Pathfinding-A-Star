local NavMesh = {}

-- Script properties are defined here
NavMesh.Properties = {
	-- Example property
	--{name = "health", type = "number", tooltip = "Current health", default = 100},
	{name = "Nodes", type = "entity", tooltip = "attach all nodes from this NavMesh", container = "array"},
}

--This function is called on the server when this entity is created
function NavMesh:Init()
	
end

-- Return the node that cointains a given position
function NavMesh:FindNodeInPosition(pos)
	local nodes = self:GetProperties().Nodes
	for i=1, #nodes do
		if nodes[i].NavMeshNode:Contains(pos) then 
			return nodes[i] 
		end
	end
end

return NavMesh
