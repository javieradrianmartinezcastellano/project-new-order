Schema.name = "Project: New Order"
Schema.author = "Project: New Order"
Schema.description = "Roleplay serio en City 24, bajo el yugo de la Alianza."

-- Rangos de la Protección Civil, de menor a mayor.
Schema.mpfRanks = {"RCT", "05", "04", "03", "02", "01", "OfC", "EpU", "DvL", "SeC"}
-- A partir de este rango una unidad puede gestionar rangos, códigos y el dispatch.
Schema.mpfLeaderRank = "DvL"

ix.util.Include("meta/sh_player.lua")
ix.util.Include("sh_configs.lua")
ix.util.Include("sh_chatclasses.lua")
ix.util.Include("sh_commands.lua")
ix.util.Include("cl_hooks.lua")
ix.util.Include("sv_hooks.lua")

function Schema:ZeroNumber(number, length)
	number = tostring(number)

	return string.rep("0", length - #number) .. number
end

function Schema:GenerateID()
	return self:ZeroNumber(math.random(1, 99999), 5)
end

function Schema:GetRankIndex(rank)
	if (not rank) then
		return
	end

	rank = rank:lower()

	for index, name in ipairs(self.mpfRanks) do
		if (name:lower() == rank) then
			return index
		end
	end
end

function Schema:FormatMPFName(rank, id)
	return string.format("%s.MPF-%s.%s", ix.config.Get("cityName", "C24"), rank, id)
end

function Schema:FormatOTAName(id)
	return string.format("%s.OTA-ECHO.%s", ix.config.Get("cityName", "C24"), id)
end

-- ¿Puede este jugador dirigir a la Unión (rangos, código de la ciudad, dispatch)?
function Schema:CanManageCombine(client)
	if (client:IsAdmin() or client:IsCityAdmin()) then
		return true
	end

	if (client:Team() == FACTION_MPF) then
		local rank = self:GetRankIndex(client:GetCharacter():GetData("cpRank"))

		return rank ~= nil and rank >= self:GetRankIndex(self.mpfLeaderRank)
	end

	return false
end

if (SERVER) then
	function Schema:SetMPFRank(character, rank)
		local id = character:GetData("cpID") or self:GenerateID()

		character:SetData("cpID", id)
		character:SetData("cpRank", rank)
		character:SetName(self:FormatMPFName(rank, id))
	end

	function Schema:GiveCID(character)
		local id = self:GenerateID()

		character:SetData("cid", id)
		character:GetInventory():Add("cid", 1, {
			name = character:GetName(),
			id = id,
			issued = os.date("%d/%m/%Y")
		})
	end
end
