ITEM.name = "Tarjeta CID"
ITEM.description = "Una tarjeta de identificación ciudadana."
ITEM.model = "models/gibs/metal_gib4.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Documentos"

function ITEM:GetDescription()
	return string.format("Tarjeta de identificación ciudadana.\nTitular: %s\nNúmero: #%s\nEmitida: %s",
		self:GetData("name", "desconocido"), self:GetData("id", "00000"), self:GetData("issued", "?"))
end
