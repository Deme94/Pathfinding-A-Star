local Main = {}

-- Script properties are defined here
Main.Properties = {
	-- Example property
	--{name = "health", type = "number", tooltip = "Current health", default = 100},
	{name = "Ghost", type = "entity"},
	{name = "TargetForGhost", type = "entity"},
}

--This function is called on the server when this entity is created
function Main:Init()
	self.ghost = self:GetProperties().Ghost.NavMeshAgent
	self.target = self:GetProperties().TargetForGhost	
end

function Main:OnTick()
	self.ghost:SetDestination(self.target:GetPosition()) -- AI WILL CHASE THE TARGET!!!
end

return Main
