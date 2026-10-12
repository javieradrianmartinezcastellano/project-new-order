ix.command.Add("CharSetRank", {
	description = "Asigna un rango a una unidad de la Protección Civil.",
	arguments = {ix.type.character, ix.type.string},
	OnRun = function(self, client, target, rank)
		if (not Schema:CanManageCombine(client)) then
			return "No tienes autoridad para cambiar rangos."
		end

		if (target:GetFaction() ~= FACTION_MPF) then
			return "Ese personaje no pertenece a la Protección Civil."
		end

		local index = Schema:GetRankIndex(rank)

		if (not index) then
			return "Rango inválido. Rangos: " .. table.concat(Schema.mpfRanks, ", ")
		end

		-- Una unidad no puede ascender a nadie a su rango o por encima.
		if (not client:IsAdmin() and client:Team() == FACTION_MPF) then
			local own = Schema:GetRankIndex(client:GetCharacter():GetData("cpRank")) or 1

			if (index >= own) then
				return "No puedes asignar un rango igual o superior al tuyo."
			end
		end

		Schema:SetMPFRank(target, Schema.mpfRanks[index])

		local targetPlayer = target:GetPlayer()

		if (IsValid(targetPlayer)) then
			targetPlayer:Notify("Tu rango ahora es " .. Schema.mpfRanks[index] .. ".")
		end

		return "Rango actualizado: " .. target:GetName()
	end
})

ix.command.Add("CharAddLoyalty", {
	description = "Suma (o resta, con valores negativos) puntos de lealtad a un ciudadano.",
	arguments = {ix.type.character, ix.type.number},
	OnRun = function(self, client, target, amount)
		if (not client:IsCombine() and not client:IsCityAdmin() and not client:IsAdmin()) then
			return "No tienes autoridad para esto."
		end

		local faction = target:GetFaction()

		if (faction ~= FACTION_CITIZEN and faction ~= FACTION_CWU) then
			return "Solo los ciudadanos tienen puntos de lealtad."
		end

		amount = math.floor(amount)

		local step = ix.config.Get("loyaltyStep", 5)

		if (not client:IsAdmin() and not client:IsCityAdmin() and math.abs(amount) > step) then
			return string.format("No puedes modificar más de %d puntos de una vez.", step)
		end

		local total = target:GetData("loyalty", 0) + amount
		target:SetData("loyalty", total)

		local targetPlayer = target:GetPlayer()

		if (IsValid(targetPlayer)) then
			targetPlayer:Notify(string.format("Tus puntos de lealtad han cambiado: %+d (total %d).", amount, total))
		end

		return string.format("%s tiene ahora %d puntos de lealtad.", target:GetName(), total)
	end
})

ix.command.Add("CharCheckLoyalty", {
	description = "Consulta los puntos de lealtad de un ciudadano.",
	arguments = {ix.type.character},
	OnRun = function(self, client, target)
		if (not client:IsCombine() and not client:IsCityAdmin() and not client:IsAdmin()) then
			return "No tienes acceso a los registros civiles."
		end

		return string.format("%s: %d puntos de lealtad.", target:GetName(), target:GetData("loyalty", 0))
	end
})
