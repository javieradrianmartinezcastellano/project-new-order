ix.config.SetDefault("color", Color(60, 110, 140))
ix.config.SetDefault("music", "music/hl2_song19.mp3")
ix.config.SetDefault("maxCharacters", 3)

ix.config.Add("cityName", "C24", "Designación de la ciudad usada en los nombres de la Unión.", nil, {
	category = "New Order"
})

ix.config.Add("rationInterval", 60, "Minutos entre raciones para una misma tarjeta CID.", nil, {
	data = {min = 1, max = 1440},
	category = "New Order"
})

ix.config.Add("loyalRationThreshold", 10, "Puntos de lealtad necesarios para recibir raciones de lealtad.", nil, {
	data = {min = 1, max = 100},
	category = "New Order"
})

ix.config.Add("loyaltyStep", 5, "Máximo de puntos de lealtad que una unidad (no administrador) puede dar o quitar de una vez.", nil, {
	data = {min = 1, max = 50},
	category = "New Order"
})
