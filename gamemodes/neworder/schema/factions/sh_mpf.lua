FACTION.name = "Protección Civil"
FACTION.description = "La fuerza policial humana de la Alianza. Mantiene el orden en las calles."
FACTION.color = Color(50, 100, 150)
FACTION.isDefault = false
FACTION.isGloballyRecognized = true
FACTION.pay = 20
FACTION.armor = 50
FACTION.models = {"models/police.mdl"}

function FACTION:GetDefaultName(client)
	return Schema:FormatMPFName(Schema.mpfRanks[1], Schema:GenerateID()), true
end

function FACTION:OnCharacterCreated(client, character)
	local id = character:GetName():match("(%d+)$") or Schema:GenerateID()
	local inventory = character:GetInventory()

	character:SetData("cpID", id)
	character:SetData("cpRank", Schema.mpfRanks[1])

	inventory:Add("stunstick")
	inventory:Add("pistol")
	inventory:Add("pistolammo", 2)
	inventory:Add("ziptie", 2)
end

function FACTION:OnTransferred(character)
	character:SetData("cpID", Schema:GenerateID())
	Schema:SetMPFRank(character, Schema.mpfRanks[1])
end

FACTION_MPF = FACTION.index
