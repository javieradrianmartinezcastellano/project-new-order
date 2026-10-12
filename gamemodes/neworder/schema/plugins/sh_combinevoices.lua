local PLUGIN = PLUGIN

PLUGIN.name = "Voces de la Unión"
PLUGIN.author = "Project: New Order"
PLUGIN.description = "Reproduce frases de voz cuando una unidad dice una frase reconocida."

-- Por uniqueID de facción. Clave: texto exacto en minúsculas. Valor: sonido.
PLUGIN.voices = {
	mpf = {
		["afirmativo"] = "npc/metropolice/vo/affirmative.wav",
		["copiado"] = "npc/metropolice/vo/copy.wav",
		["10-4"] = "npc/metropolice/vo/ten4.wav",
		["circule"] = "npc/metropolice/vo/movealong.wav",
		["siga moviéndose"] = "npc/metropolice/vo/keepmoving.wav",
		["alto"] = "npc/metropolice/vo/holdit.wav",
		["al suelo"] = "npc/metropolice/vo/getdown.wav",
		["recoge la lata"] = "npc/metropolice/vo/pickupthecan1.wav",
		["puede irse"] = "npc/metropolice/vo/allrightyoucango.wav",
		["primer aviso"] = "npc/metropolice/vo/firstwarningmove.wav",
		["segundo aviso"] = "npc/metropolice/vo/secondwarning.wav",
		["último aviso"] = "npc/metropolice/vo/finalwarning.wav",
		["anticiudadano"] = "npc/metropolice/vo/anticitizen.wav",
		["refuerzos"] = "npc/metropolice/vo/backup.wav"
	},
	ota = {
		["afirmativo"] = "npc/combine_soldier/vo/affirmative.wav",
		["copiado"] = "npc/combine_soldier/vo/copythat.wav",
		["contacto"] = "npc/combine_soldier/vo/contact.wav",
		["despejado"] = "npc/combine_soldier/vo/cleaned.wav"
	}
}

local voiceChats = {ic = true, w = true, y = true, radio = true}

if (SERVER) then
	function PLUGIN:PlayerMessageSend(speaker, chatType, text)
		if (not voiceChats[chatType]) then
			return
		end

		local faction = ix.faction.indices[speaker:Team()]
		local voices = faction and self.voices[faction.uniqueID]
		local sound = voices and voices[text:lower():gsub("[%.!¡]", ""):Trim()]

		if (sound) then
			speaker:EmitSound(sound, 80)
		end
	end
end
