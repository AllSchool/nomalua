
function NOMALUA.AddWhiteListElement(filename, linenum, checktype)
	table.insert(NOMALUA.Whitelist, {file=filename, line=linenum, check=checktype})
end

function NOMALUA.AddDefaultWhiteListElements()

	-- - supprimer les faux positifs de son propre code de contrôle
	NOMALUA.AddWhiteListElement("addons/nomalua/lua/sv_nomalua_checkdefs.lua", 0, "*")

	-- - Faux positifs CAC
	NOMALUA.AddWhiteListElement("addons/cac%-release%-.*.lua", 0, "*")

	-- ULIB/ULX faux positifs
	NOMALUA.AddWhiteListElement("addons/ulib/lua/ulib/server/player.lua", 0, NOMALUA.CheckTypes.BANMGMT)

	NOMALUA.AddWhiteListElement("gamemodes/sandbox/entities/weapons/gmod_tool/stools/wheel.lua", 274, NOMALUA.CheckTypes.OBFUSC)
	NOMALUA.AddWhiteListElement("gamemodes/sandbox/entities/weapons/gmod_tool/stools/wheel.lua", 275, NOMALUA.CheckTypes.OBFUSC)
	NOMALUA.AddWhiteListElement("gamemodes/sandbox/entities/weapons/gmod_tool/stools/wheel.lua", 276, NOMALUA.CheckTypes.OBFUSC)
	NOMALUA.AddWhiteListElement("gamemodes/sandbox/entities/weapons/gmod_tool/stools/wheel.lua", 277, NOMALUA.CheckTypes.OBFUSC)
	NOMALUA.AddWhiteListElement("gamemodes/sandbox/entities/weapons/gmod_tool/stools/wheel.lua", 278, NOMALUA.CheckTypes.OBFUSC)

end