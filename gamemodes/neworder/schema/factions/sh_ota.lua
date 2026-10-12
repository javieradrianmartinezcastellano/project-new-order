FACTION.name = "Overwatch Transhumana"
FACTION.description = "Soldados transhumanos de la Alianza. Solo intervienen cuando la Protección Civil no basta."
FACTION.color = Color(150, 50, 50)
FACTION.isDefault = false
FACTION.isGloballyRecognized = true
FACTION.pay = 30
FACTION.armor = 100
FACTION.models = {
	"models/combine_soldier.mdl",
	"models/combine_soldier_prisonguard.mdl",
	"models/combine_super_soldier.mdl"
}

function FACTION:GetDefaultName(client)
	return Schema:FormatOTAName(Schema:GenerateID()), true
end

function FACTION:OnCharacterCreated(client, character)
	local inventory = character:GetInventory()

	inventory:Add("ar2")
	inventory:Add("ar2ammo", 2)
end

function FACTION:OnTransferred(character)
	character:SetName(Schema:FormatOTAName(Schema:GenerateID()))
end

FACTION_OTA = FACTION.index
