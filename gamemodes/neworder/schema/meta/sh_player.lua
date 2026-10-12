local playerMeta = FindMetaTable("Player")

function playerMeta:IsCombine()
	local faction = self:Team()

	return faction == FACTION_MPF or faction == FACTION_OTA
end

function playerMeta:IsCityAdmin()
	return self:Team() == FACTION_ADMIN
end
