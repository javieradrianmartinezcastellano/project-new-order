FACTION.name = "Unión de Trabajadores Civiles"
FACTION.description = "Ciudadanos que trabajan para la Alianza a cambio de mejores raciones y algo de protección."
FACTION.color = Color(220, 170, 80)
FACTION.isDefault = false
FACTION.pay = 15
FACTION.models = {
	"models/humans/group01/male_01.mdl",
	"models/humans/group01/male_02.mdl",
	"models/humans/group01/male_03.mdl",
	"models/humans/group01/male_04.mdl",
	"models/humans/group01/male_05.mdl",
	"models/humans/group01/male_06.mdl",
	"models/humans/group01/male_07.mdl",
	"models/humans/group01/male_08.mdl",
	"models/humans/group01/male_09.mdl",
	"models/humans/group01/female_01.mdl",
	"models/humans/group01/female_02.mdl",
	"models/humans/group01/female_03.mdl",
	"models/humans/group01/female_04.mdl",
	"models/humans/group01/female_06.mdl",
	"models/humans/group01/female_07.mdl"
}

function FACTION:OnCharacterCreated(client, character)
	Schema:GiveCID(character)
	character:SetData("loyalty", ix.config.Get("loyalRationThreshold", 10))
end

FACTION_CWU = FACTION.index
