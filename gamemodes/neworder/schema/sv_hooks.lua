function Schema:PostPlayerLoadout(client)
	local faction = ix.faction.indices[client:Team()]

	if (faction and faction.armor) then
		client:SetArmor(faction.armor)
	end
end

-- Desatar a un jugador atado manteniendo la mirada sobre él.
function Schema:PlayerUse(client, entity)
	if (client:IsRestricted() or not entity:IsPlayer() or not entity:IsRestricted() or entity.ixBeingUntied) then
		return
	end

	entity.ixBeingUntied = true
	entity:SetAction("Te están desatando...", 5)
	client:SetAction("Desatando...", 5)

	client:DoStaredAction(entity, function()
		entity:SetRestricted(false)
		entity.ixBeingUntied = nil
	end, 5, function()
		if (IsValid(entity)) then
			entity.ixBeingUntied = nil
			entity:SetAction()
		end

		if (IsValid(client)) then
			client:SetAction()
		end
	end)
end

-- Aviso de pérdida de biseñal a toda la Unión.
function Schema:PlayerDeath(client)
	if (not client:IsCombine()) then
		return
	end

	local message = "Pérdida de biseñal: " .. client:Name()

	for _, v in ipairs(player.GetAll()) do
		if (v ~= client and v:IsCombine()) then
			v:Notify(message)
			v:EmitSound("npc/overwatch/radiovoice/lostbiosignalforunit.wav", 60)
		end
	end
end

-- Sin sprays: rompen la inmersión.
function Schema:PlayerSpray(client)
	return true
end
