-- Radio de la Unión: la oyen todas las unidades y la Administración.
ix.chat.Register("radio", {
	color = Color(75, 150, 50),
	CanSay = function(self, speaker, text)
		if (not speaker:IsCombine() and not speaker:IsCityAdmin()) then
			speaker:Notify("No tienes acceso a la red de radio.")
			return false
		end

		return true
	end,
	CanHear = function(self, speaker, listener)
		return listener:IsCombine() or listener:IsCityAdmin()
	end,
	OnChatAdd = function(self, speaker, text)
		chat.AddText(self.color, string.format("%s por radio: \"%s\"", speaker:Name(), text))
	end,
	prefix = {"/R", "/Radio"},
	description = "Habla por la red de radio de la Unión."
})

-- Dispatch: anuncio global de la Overwatch.
ix.chat.Register("dispatch", {
	color = Color(192, 57, 43),
	CanSay = function(self, speaker, text)
		if (not Schema:CanManageCombine(speaker)) then
			speaker:Notify("No tienes autoridad para usar el dispatch.")
			return false
		end

		return true
	end,
	CanHear = function(self, speaker, listener)
		return true
	end,
	OnChatAdd = function(self, speaker, text)
		chat.AddText(self.color, "Dispatch: ", color_white, text)
	end,
	prefix = {"/Dispatch"},
	description = "Emite un anuncio de la Overwatch a toda la ciudad."
})

-- Retransmisión de la Administración Civil.
ix.chat.Register("broadcast", {
	color = Color(150, 125, 175),
	CanSay = function(self, speaker, text)
		if (not speaker:IsCityAdmin() and not speaker:IsAdmin()) then
			speaker:Notify("Solo la Administración puede retransmitir.")
			return false
		end

		return true
	end,
	CanHear = function(self, speaker, listener)
		return true
	end,
	OnChatAdd = function(self, speaker, text)
		chat.AddText(self.color, string.format("%s retransmite: \"%s\"", speaker:Name(), text))
	end,
	prefix = {"/Broadcast"},
	description = "Retransmite un mensaje a toda la ciudad."
})

-- Solicitud a la Protección Civil mediante dispositivo de solicitud.
ix.chat.Register("request", {
	color = Color(210, 160, 60),
	CanSay = function(self, speaker, text)
		local character = speaker:GetCharacter()

		if (not character or not character:GetInventory():HasItem("request_device")) then
			speaker:Notify("Necesitas un dispositivo de solicitud.")
			return false
		end

		return true
	end,
	CanHear = function(self, speaker, listener)
		return listener == speaker or listener:IsCombine() or listener:IsCityAdmin()
	end,
	OnChatAdd = function(self, speaker, text)
		chat.AddText(self.color, string.format("[SOLICITUD] %s: \"%s\"", speaker:Name(), text))
	end,
	prefix = {"/Request", "/Solicitud"},
	description = "Envía una solicitud a la Protección Civil."
})
