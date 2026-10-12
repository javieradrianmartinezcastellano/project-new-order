local PLUGIN = PLUGIN

PLUGIN.name = "Raciones"
PLUGIN.author = "Project: New Order"
PLUGIN.description = "Dispensadores de raciones vinculados a la tarjeta CID."

ix.command.Add("DispenserToggle", {
	description = "Activa o desactiva el dispensador de raciones que estás mirando.",
	OnRun = function(self, client)
		if (not client:IsCombine() and not client:IsCityAdmin() and not client:IsAdmin()) then
			return "No tienes autorización."
		end

		local entity = client:GetEyeTraceNoCursor().Entity

		if (not IsValid(entity) or entity:GetClass() ~= "ix_rationdispenser") then
			return "Debes mirar a un dispensador de raciones."
		end

		entity:SetDisabled(not entity:GetDisabled())
		PLUGIN:SaveData()

		return entity:GetDisabled() and "Dispensador desactivado." or "Dispensador activado."
	end
})

if (SERVER) then
	function PLUGIN:SaveData()
		local data = {}

		for _, v in ipairs(ents.FindByClass("ix_rationdispenser")) do
			data[#data + 1] = {v:GetPos(), v:GetAngles(), v:GetDisabled()}
		end

		self:SetData(data)
	end

	function PLUGIN:LoadData()
		for _, v in ipairs(self:GetData() or {}) do
			local entity = ents.Create("ix_rationdispenser")
			entity:SetPos(v[1])
			entity:SetAngles(v[2])
			entity:Spawn()
			entity:SetDisabled(v[3] == true)
		end
	end
end
