-- - Version 1.01 Changelog
-- - Ajout d'un installations custom
-- - Ajout d'un rang de risque (actuellement de 1 à 5, 5 plus élevé.  Plutôt arbitraire pour l'instant.  Toujours bêta. Bon sang, tout le truc est toujours bêta)
-- - Code de définition du type de contrôle optimisé et de la définition du contrôle de modèle
-- - Correction d'un bogue dans le code de récursivité du répertoire
-- - optimisations mineures diverses
-- - Ajout de contrôles de motifs supplémentaires

-- Version 1.1 Changelog
-- Logique de récursivité de répertoire ajustée pour préfixer le répertoire racine de recherche
-- Ajout d'une liste blanche et de quelques éléments de liste blanche par défaut
-- Restructuration de la recherche de fichiers lua pour que les fichiers correspondants dans addons/<addonname>/lua/.... et lua/... se heurtent volontairement dans la table de stockage (de-dupe)
-- Refonte de la numérisation vers la sortie de la file d'attente, éliminant ainsi le besoin de passer le pli var autour de l'image.

if not NOMALUA then
	NOMALUA = {}
	NOMALUA.ScanResults = {}
	NOMALUA.Whitelist = {}
end

include('sh_nomalua.lua')
include('sv_nomalua_utils.lua')
include('sv_nomalua_checkdefs.lua')
include('sv_nomalua_whitelist.lua')

util.AddNetworkString( "NomaluaConsoleMsg" )


function NOMALUA.SaveWhitelist()
	local tab = util.TableToJSON( NOMALUA.Whitelist, true )
	file.CreateDir( "nomalua" ) -- Create the directory
	file.Write( "nomalua_remastered/whitelist.txt", tab )
end

local wlcontent = file.Read( "nomalua_remastered/whitelist.txt", "DATA" )
if (wlcontent != nil) then
	NOMALUA.Whitelist = util.JSONToTable( wlcontent )
else
	NOMALUA.AddDefaultWhiteListElements()
	NOMALUA.SaveWhitelist()
end

function NOMALUA.IsWhitelisted(filename, linenum, checktype)
	for k,whiteitem in pairs(NOMALUA.Whitelist) do
		if (string.match(filename, whiteitem.file) and 
			(whiteitem.line == linenum or whiteitem.line == 0) and 
			(whiteitem.check == checktype or whiteitem.check == "*")) then
			return true
		end
	end
	return false
end

-- - contrôle standardisé de la présence de token dans la chaîne de caractères
function NOMALUA.PatternCheck(src, filename, linenum, patternCheck)
	local result = string.match(src, patternCheck.Pattern)
	if (result != nil and not NOMALUA.IsWhitelisted(filename, linenum, patternCheck.CheckType)) then
		v = {}
		v.Src = src
		v.Filename = filename
		v.Linenum = linenum
		v.CheckType = patternCheck.CheckType
		v.Pattern = patternCheck.Pattern
		v.Desc = patternCheck.Desc
		v.Risk = patternCheck.Risk
		v.Tofind = result
		
		table.insert(NOMALUA.ScanResults, v)
	end
end

-- - main loop
function NOMALUA.CheckFiles()
	local luaFiles = {}
	luaFiles = NOMALUA.AddLuaFiles(luaFiles, "lua", true)
	luaFiles = NOMALUA.AddLuaFiles(luaFiles, "addons", true) -- - Exécutez toujours les addons *after* lua, pour prendre en charge le contrôle de la déduplication.
	luaFiles = NOMALUA.AddLuaFiles(luaFiles, "gamemodes", true)
	luaFiles = NOMALUA.AddLuaFiles(luaFiles, "script", false)

	for k,filename in pairs(luaFiles) do
		local content = file.Read( filename, "GAME" )

		if (content != nil) then

			content = string.gsub(content, "\r", "")  -- - meilleure façon de gérer win eol ?
			local content_lns = NOMALUA.split(content,"\n") -- - diviser la source en lignes
			for linenum,linesrc in pairs(content_lns) do
			
				linesrc = string.Trim(linesrc)
				if string.Left(linesrc,2) != "--" and string.Left(linesrc,2) != "//" then -- - not a rem statement
				
					for _, patternCheck in pairs (NOMALUA.PatternChecks) do
						NOMALUA.PatternCheck(linesrc, filename, linenum, patternCheck)
					end
				end
			end
		end
	end
end

function NOMALUA.OutputResults(ply)
	for k,output_value in pairs(NOMALUA.ScanResults) do
		NOMALUA.RenderNotice(k, output_value, ply)
	end
end

function NOMALUA.StartScan(ply)
	NOMALUA.ScanResults = {}
	NOMALUA.SendNotice ( {"[Nomalua-Remastered] ./> /!\ ATTENTION RISQUE DE RALENTISSEMENT DU SERVEUR /!\<\.\n"} , ply)
	NOMALUA.SendNotice ( {"[Nomalua-Remastered] ./> Lancement de l'analyse en cours !<\.\n"} , ply)
	NOMALUA.CheckFiles()
	NOMALUA.SendNotice ( {"[Nomalua-Remastered] ./> Résultat de l'analyse en cours !<\.\n"} , ply)
	NOMALUA.OutputResults(ply)
	NOMALUA.SendNotice ( {"[Nomalua-Remastered] ./> Résultat de l'analyse complète !<\.\n"} , ply)
end

function NOMALUA.DumpFile(ply, filename)
	local content = file.Read( filename, "GAME" )
	if (content != nil) then
		content = string.gsub(content, "\r", "")  -- better way to handle win eol?
		local content_lns = NOMALUA.split(content,"\n") -- split source into lines
		for linenum,linesrc in pairs(content_lns) do
			NOMALUA.SendNotice ( {linesrc, "\n"} , ply)
		end
	end
end

function NOMALUA.ShowWhitelist(ply)
	for linenum,ele in pairs(NOMALUA.Whitelist) do
		NOMALUA.SendNotice ( {linenum, "\t", ele.file,"\t", ele.line, "\t", ele.check, "\n"} , ply)
	end
end

function NOMALUA.AddWhiteListItem(ply,itemid)
	local scanItem = NOMALUA.ScanResults[itemid]
	if (scanItem == nil) then
		NOMALUA.SendNotice ( {"Impossible de localiser un élément de numérisation pour l'identification "..itemid, "\n"} , ply)
	else
		table.insert(NOMALUA.Whitelist, {file=scanItem.Filename, line=scanItem.Linenum, check=scanItem.CheckType})
		NOMALUA.SaveWhitelist()
		NOMALUA.SendNotice ( {"Ajout d'une liste blanche\n"} , ply)
	end
end

function NOMALUA.AddWhiteListItem2(ply,filename, linenum, checktype)
	table.insert(NOMALUA.Whitelist, {file=filename, line=linenum, check=checktype})
	NOMALUA.SaveWhitelist()
	NOMALUA.SendNotice ( {"Ajout d'une liste blanche\n"} , ply)
end

function NOMALUA.DelWhiteListItem(ply,itemid)
	local wlItem = NOMALUA.Whitelist[itemid]
	if (wlItem == nil) then
		NOMALUA.SendNotice ( {"Impossible de localiser un élément de la liste blanche pour id "..itemid, "\n"} , ply)
	else
		table.remove(NOMALUA.Whitelist, itemid)
		NOMALUA.SaveWhitelist()
		NOMALUA.SendNotice ( {"Élément de la liste blanche supprimé\n"} , ply)
	end
end

concommand.Add( "server_scan", function( ply )
	if IsValid(ply) and not ply:IsSuperAdmin() then
		ply:PrintMessage(HUD_PRINTCONSOLE, "[Nomalua-Remastered] Seuls les superadmins ou la console peuvent lancer un scan :o")
	else
		NOMALUA.StartScan(ply)
	end
end )

concommand.Add( "nomalua_remastered", function( ply, cmd, args )
	if IsValid(ply) and not ply:IsSuperAdmin() then
		ply:PrintMessage(HUD_PRINTCONSOLE, "[Nomalua-Remastered] Seuls les superadministrateurs ou la console peuvent lancer Nomalua")
	else
		if (args[1] == "scan") then
			NOMALUA.StartScan(ply)
		elseif (args[1] == "dumpfile") then
			NOMALUA.DumpFile(ply, args[2])
		elseif (args[1] == "whitelist") then
			NOMALUA.ShowWhitelist(ply)
		elseif (args[1] == "lastscan") then
			NOMALUA.OutputResults(ply)
		elseif (args[1] == "addwl") then
			if (#args > 2) then
				NOMALUA.AddWhiteListItem2(ply,args[2],tonumber(args[3]), args[4])
			else
				NOMALUA.AddWhiteListItem(ply,tonumber(args[2]))
			end
		elseif (args[1] == "delwl") then
			NOMALUA.DelWhiteListItem(ply,tonumber(args[2]))
		end
		
	end
end )