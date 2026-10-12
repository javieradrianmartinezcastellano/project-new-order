local BIOSIGNAL_RANGE = 3000
local biosignalColor = Color(80, 170, 255)

-- Marcadores de biseñal de las demás unidades, como el HUD de la máscara.
function Schema:HUDPaint()
	local client = LocalPlayer()

	if (not IsValid(client) or not client:GetCharacter() or not client:Alive() or not client:IsCombine()) then
		return
	end

	local origin = client:GetPos()

	for _, v in ipairs(player.GetAll()) do
		if (v ~= client and v:Alive() and v:IsCombine() and v:GetCharacter()) then
			local distance = origin:Distance(v:GetPos())

			if (distance <= BIOSIGNAL_RANGE) then
				local screen = (v:GetPos() + Vector(0, 0, 80)):ToScreen()

				if (screen.visible) then
					draw.SimpleTextOutlined(v:Name(), "ixSmallFont", screen.x, screen.y, biosignalColor,
						TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black)
					draw.SimpleTextOutlined(math.floor(distance / 52.49) .. " m", "ixSmallFont", screen.x, screen.y,
						color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, color_black)
				end
			end
		end
	end
end
