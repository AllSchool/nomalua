if SERVER then
	AddCSLuaFile()
	AddCSLuaFile('cl_nomalua.lua')
	AddCSLuaFile('sh_nomalua.lua')

	include('sv_nomalua.lua')
	
	print("[Nomalua] ------ Nomalua remastered v1.01 (Remasterisé par AllSchool ) Charger avec succès ! ------")
end

if CLIENT then
	include('cl_nomalua.lua')
end