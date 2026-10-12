ITEM.name = "Brida"
ITEM.description = "Una brida de plástico para inmovilizar a una persona."
ITEM.model = "models/items/crossbowrounds.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Utilidades"

ITEM.functions.Use = {
	name = "Atar",
	icon = "icon16/link.png",
	OnRun = function(item)
		local client = item.player
		local trace = util.TraceLine({
			start = client:GetShootPos(),
			endpos = client:GetShootPos() + client:GetAimVector() * 96,
			filter = client
		})
		local target = trace.Entity

		if (not IsValid(target) or not target:IsPlayer() or not target:GetCharacter() or target:IsRestricted()) then
			client:Notify("Debes mirar a una persona a la que puedas atar.")
			return false
		end

		item.bBeingUsed = true
		client:SetAction("Atando...", 5)
		target:SetAction("Te están atando...", 5)

		client:DoStaredAction(target, function()
			if (IsValid(target)) then
				target:SetRestricted(true)
			end

			item:Remove()
		end, 5, function()
			item.bBeingUsed = false

			if (IsValid(client)) then
				client:SetAction()
			end

			if (IsValid(target)) then
				target:SetAction()
			end
		end)

		return false
	end,
	OnCanRun = function(item)
		return not IsValid(item.entity) and not item.bBeingUsed
	end
}
