local PLUGIN = PLUGIN

ENT.Type = "anim"
ENT.PrintName = "Dispensador de raciones"
ENT.Category = "Helix - New Order"
ENT.Spawnable = true
ENT.AdminOnly = true

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "Disabled")
end

if (SERVER) then
	function ENT:SpawnFunction(client, trace)
		local entity = ents.Create("ix_rationdispenser")
		entity:SetPos(trace.HitPos + trace.HitNormal * 16)
		entity:SetAngles(Angle(0, (client:GetPos() - trace.HitPos):Angle().y, 0))
		entity:Spawn()
		entity:Activate()

		PLUGIN:SaveData()

		return entity
	end

	function ENT:Initialize()
		self:SetModel("models/props_combine/combine_dispenser.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)

		local physics = self:GetPhysicsObject()

		if (IsValid(physics)) then
			physics:EnableMotion(false)
		end
	end

	function ENT:Deny(client, message)
		client:Notify(message)
		self:EmitSound("buttons/combine_button_locked.wav")
	end

	function ENT:Use(client)
		if ((self.nextUse or 0) > CurTime()) then
			return
		end

		self.nextUse = CurTime() + 2

		local character = client:GetCharacter()

		if (not character) then
			return
		end

		if (self:GetDisabled()) then
			return self:Deny(client, "El dispensador está fuera de servicio.")
		end

		local inventory = character:GetInventory()
		local cid = inventory:HasItem("cid")

		if (not cid) then
			return self:Deny(client, "Necesitas una tarjeta CID.")
		end

		local now = os.time()
		local nextRation = cid:GetData("nextRation", 0)

		if (nextRation > now) then
			return self:Deny(client, string.format("Esta CID no puede recibir otra ración hasta dentro de %d minutos.",
				math.ceil((nextRation - now) / 60)))
		end

		local itemID = "ration"

		if (client:Team() == FACTION_CWU or character:GetData("loyalty", 0) >= ix.config.Get("loyalRationThreshold", 10)) then
			itemID = "ration_loyal"
		end

		if (not inventory:Add(itemID)) then
			ix.item.Spawn(itemID, self:GetPos() + self:GetForward() * 24)
		end

		cid:SetData("nextRation", now + ix.config.Get("rationInterval", 60) * 60)
		self:EmitSound("buttons/combine_button1.wav")
	end

	function ENT:OnRemove()
		if (not ix.shuttingDown) then
			PLUGIN:SaveData()
		end
	end
else
	function ENT:Draw()
		self:DrawModel()
	end
end
