Nomalua remastered v1.01 ( publi� le 15.02.2019 )




Nomalua remastered est un scanner de logiciels malveillants pour les fichiers GMod Lua.  

Il analyse les fichiers Lua sur le serveur (y compris ceux mont�s via les fichiers Steam Workshop GMA) et signale tout code ou mod�le de code suspect qui pourrait justifier une enqu�te plus approfondie.



IL EST IMPORTANT de comprendre que la d�tection par Nomalua ne signifie PAS n�cessairement que vous avez un probl�me - simplement qu'il existe une construction ou un mod�le de code qui r�pond aux crit�res de Nomalua pour la d�claration.  

** La grande majorit� des alertes seront de faux positifs **. 

Cependant, lorsque vous ex�cutez un addon, vous faites confiance � l'auteur pour �tre un bon citoyen. 

Les addons peuvent h�berger des portes d�rob�es et d'autres codes malveillants.  

Il vaut mieux faire confiance mais v�rifier plut�t que simplement faire confiance aveugl�ment. 

Nomalua permet aux administrateurs de serveurs d'avoir une meilleure vue d'ensemble de ce qui fonctionne sans avoir � analyser chaque addon ligne par ligne. 

Ceci est d'autant plus vrai que de plus en plus d'administrateurs de serveurs utilisent des addons via le Steam Workshop, 

ce qui rend la r�vision du code et le suivi des mises � jour plus difficiles pour les administrateurs.




--------------./> D�VELOPPEUR ET SUPPORT <\.--------------



Nomalua a �t� d�velopp� par BuzzKill est am�liorer par AllSchool.

GitHub de BuzzKill: 
https://github.com/THABBuzzkill/nomalua 

./> pour les t�l�chargements, les rapports de bogues, le support et les informations sur les versions.

Mon GiTHuB:
https://github.com/AllSchool





--------------./> EXIGENCES <\.--------------



Nomalua n'a pas d'exigences. 





--------------./> INSTALLATION <\.--------------



Pour installer Nomalua, il suffit d'extraire les fichiers de l'archive dans votre dossier garrysmod/addons.


Quand vous l'aurez fait, vous devriez avoir une structure de fichier comme celle-ci--
 

<garrysmod>/addons/nomalua/lua/autorun/init.lua
	

<garrysmod>/addons/nomalua/lua/sv_nomalua.lua
etc.




Veuillez noter que l'installation est la m�me sur les serveurs d�di�s. 

L'installation n�cessite un red�marrage du serveur.





--------------./> USAGE <\.--------------



LES COMMANDES DE LA CONSOLE :





.:> nomalua scan <:.



Une fois install� et le serveur red�marr�, vous pouvez ex�cuter le scanner en ouvrant la console et en lan�ant la commande "nomalua scan".

Si vous ex�cutez directement sur le serveur, vous devriez imm�diatement commencer � voir la sortie (exemple ci-dessous).

Si vous utilisez un client, vous devez avoir les privil�ges superadmin. 

Lors de l'ex�cution dans une console client, il peut y avoir un d�lai avant que la sortie ne soit rendue. 

Nomalua est assez gourmand en ressources, il n'est donc pas recommand� de l'ex�cuter lorsque le serveur est particuli�rement occup�. 



Exemple : balayage nomalua

Nomalua rapporte ce qui suit (�chantillon) 

:

1 2 - AUTHENT (Pr�sence de Steam ID) gamemodes/jailbreak/gamemode/core/cl_menu_help_options.lua:218 : Excl (STEAM_0:0:0:19441588) - 

D�veloppeur principal en charge de Jail Break depuis la version 1
2 4 - NETWORK (appel serveur HTTP) addons/hatschat2/lua/hatschat/cl_init.lua:196 http.Fetch( FUrl, function( body, len, header, code)
3 2 - BANMGMT (Bannir par adresse IP) addons/customcommands_onecategory/lua/ulx/modules/sh/cc_util.lua:283 local banip = ulx.command("Custom", "ulx banip", ulx.banip )
4 2 - DYNCODE (Ex�cution du code dynamique) lua/autorun/luapad.lua:152 RunString(file.Read("luapad/_server_globals.txt", "DATA")) ;
5 2 - FILESYS (Suppression de fichiers) addons/customcommands_onecategory/lua/ulx/modules/sh/cc_util.lua:909 file.Delete("watchlist/"... id... ".txt" )
6 3 - OBFUSC (code obscurci / crypt�) lua/includes/extensions/string.lua:34 str = str:gsub("\226\128\168", "\\\\\226\128\168") )

La premi�re colonne est simplement le num�ro de s�quence (ID) de l'entr�e de balayage. Ceci peut �tre utilis� lors de l'ajout d'�l�ments en liste blanche.

La deuxi�me colonne contient la cote de risque, le type de contr�le et la description.

Actuellement, Nomalua d�tecte le code dynamique (code qui s'ex�cute dynamiquement, � l'aide d'une cha�ne de compilation, etc.), 

les contr�les d'authentification (r�f�rences aux Steam IDs), l'activit� r�seau (appels � http.Post et Fetch), les �l�ments li�s au bannissement (modifications du statut du bannissement), 

le code masqu� (bytecode, cryptage) et les appels syst�me (suppression de fichier). La cote de risque va de 1 � 5, 5 �tant la plus �lev�e.

� l'heure actuelle, le syst�me de cotation est plut�t arbitraire - il sera renforc� avec le temps.



La troisi�me colonne indique le num�ro de fichier et de ligne de la d�tection.  Notez que si cet addon est contenu dans un GMA, 

vous devrez d�compresser manuellement le fichier.gma afin de visualiser le fichier directement.

La quatri�me colonne affiche la ligne elle-m�me, 

la phrase de d�tection �tant surlign�e en jaune. 



::::: : nomalua dumpfile <filepath> ::::: :

Cette commande videra le contenu d'un fichier dans la console pour une enqu�te plus approfondie.
