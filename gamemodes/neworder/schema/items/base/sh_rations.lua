ITEM.name = "Ración"
ITEM.description = "Un paquete sellado distribuido por la Unión."
ITEM.model = "models/weapons/w_package.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Raciones"
ITEM.contents = {"ration_food", "water"}
ITEM.money = 15

ITEM.functions.Open = {
	name = "Abrir",
	icon = "icon16/box.png",
	OnRun = function(item)
		local client = item.player
		local character = client:GetCharacter()
		local inventory = character:GetInventory()

		for _, uniqueID in ipairs(item.contents) do
			if (not inventory:Add(uniqueID)) then
				ix.item.Spawn(uniqueID, client:GetPos() + Vector(0, 0, 16))
			end
		end

		character:GiveMoney(item.money)
		client:EmitSound("physics/body/body_medium_impact_soft1.wav")

		return true
	end
}
