local PLUGIN = PLUGIN

PLUGIN.name = "Código de la ciudad"
PLUGIN.author = "Project: New Order"
PLUGIN.description = "Estado de estabilidad socio-civil visible para toda la ciudad."

PLUGIN.codes = {
	{
		name = "Estabilidad civil",
		color = Color(46, 204, 113),
		message = "Estado de estabilidad civil restablecido. Ciudadanos: retomen sus actividades.",
		sound = "buttons/blip1.wav"
	},
	{
		name = "Inestabilidad marginal",
		color = Color(241, 196, 15),
		message = "Inestabilidad marginal detectada. Ciudadanos: colaboren con la Protección Civil.",
		sound = "buttons/blip1.wav"
	},
	{
		name = "Disturbio civil",
		color = Color(231, 76, 60),
		message = "Disturbio civil. Renuncia al juicio en vigor. Ciudadanos: regresen a sus bloques de vivienda.",
		sound = "ambient/alarms/klaxon1.wav"
	},
	{
		name = "Juicio autónomo",
		color = Color(40, 40, 40),
		message = "Juicio autónomo en vigor. Toda presencia en la vía pública será considerada hostil.",
		sound = "ambient/alarms/klaxon1.wav"
	}
}

function PLUGIN:GetCode()
	return self.codes[GetNetVar("cityCode", 1)] or self.codes[1]
end

ix.command.Add("SetCityCode", {
	description = "Cambia el código de la ciudad (1 verde, 2 amarillo, 3 rojo, 4 negro).",
	arguments = {ix.type.number},
	OnRun = function(self, client, index)
		if (not Schema:CanManageCombine(client)) then
			return "No tienes autoridad para cambiar el código."
		end

		index = math.floor(index)

		if (not PLUGIN.codes[index]) then
			return "Código inválido. Usa un número del 1 al 4."
		end

		PLUGIN:SetCode(index)
	end
})

if (SERVER) then
	util.AddNetworkString("ixCityCode")

	function PLUGIN:SetCode(index)
		SetNetVar("cityCode", index)
		self:SaveData()

		net.Start("ixCityCode")
			net.WriteUInt(index, 4)
		net.Broadcast()
	end

	function PLUGIN:SaveData()
		self:SetData(GetNetVar("cityCode", 1))
	end

	function PLUGIN:LoadData()
		SetNetVar("cityCode", self:GetData(1) or 1)
	end
else
	net.Receive("ixCityCode", function()
		local code = PLUGIN.codes[net.ReadUInt(4)]

		if (code) then
			chat.AddText(code.color, "[" .. code.name .. "] ", color_white, code.message)
			surface.PlaySound(code.sound)
		end
	end)

	function PLUGIN:HUDPaint()
		local client = LocalPlayer()

		if (not IsValid(client) or not client:GetCharacter()) then
			return
		end

		local code = self:GetCode()
		local text = "CÓDIGO: " .. code.name:upper()

		surface.SetFont("ixSmallFont")

		local width, height = surface.GetTextSize(text)
		local x, y = ScrW() - width - 24, 16

		surface.SetDrawColor(0, 0, 0, 180)
		surface.DrawRect(x - 8, y - 4, width + 16, height + 8)
		surface.SetDrawColor(code.color)
		surface.DrawRect(x - 8, y + height + 4, width + 16, 2)
		draw.SimpleText(text, "ixSmallFont", x, y, color_white)
	end
end
