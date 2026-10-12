ITEM.name = "Consumible"
ITEM.description = "Algo que se puede consumir."
ITEM.model = "models/props_junk/popcan01a.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Consumibles"
ITEM.healthRestore = 5
ITEM.useSound = "npc/barnacle/barnacle_crunch2.wav"

ITEM.functions.Consume = {
	name = "Consumir",
	icon = "icon16/cup.png",
	OnRun = function(item)
		local client = item.player

		client:SetHealth(math.min(client:Health() + item.healthRestore, client:GetMaxHealth()))
		client:EmitSound(item.useSound)

		return true
	end
}
