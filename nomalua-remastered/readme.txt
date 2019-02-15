Nomalua remastered v1.01 ( publié le 15.02.2019 )

Nomalua remastered est un scanner de logiciels malveillants pour les fichiers GMod Lua.  

Il analyse les fichiers Lua sur le serveur (y compris ceux montés via les fichiers Steam Workshop GMA) et signale tout code ou modèle de code suspect qui pourrait justifier une enquête plus approfondie.

IL EST IMPORTANT de comprendre que la détection par Nomalua ne signifie PAS nécessairement que vous avez un problème - simplement qu'il existe une construction ou un modèle de code qui répond aux critères de Nomalua pour la déclaration.  

** La grande majorité des alertes seront de faux positifs **. 

Cependant, lorsque vous exécutez un addon, vous faites confiance à l'auteur pour être un bon citoyen. 

Les addons peuvent héberger des portes dérobées et d'autres codes malveillants.  

Il vaut mieux faire confiance mais vérifier plutôt que simplement faire confiance aveuglément. 

Nomalua permet aux administrateurs de serveurs d'avoir une meilleure vue d'ensemble de ce qui fonctionne sans avoir à analyser chaque addon ligne par ligne. 

Ceci est d'autant plus vrai que de plus en plus d'administrateurs de serveurs utilisent des addons via le Steam Workshop, 

ce qui rend la révision du code et le suivi des mises à jour plus difficiles pour les administrateurs.

--------------./> DÉVELOPPEUR ET SUPPORT <\.--------------

Nomalua a été développé par BuzzKill est améliorer par AllSchool.

GitHub de BuzzKill: 
https://github.com/THABBuzzkill/nomalua 

./> pour les téléchargements, les rapports de bogues, le support et les informations sur les versions.

--------------./> EXIGENCES <\.--------------

Nomalua n'a pas d'exigences. 

--------------./> INSTALLATION <\.--------------

Pour installer Nomalua, il suffit d'extraire les fichiers de l'archive dans votre dossier garrysmod/addons.

Quand vous l'aurez fait, vous devriez avoir une structure de fichier comme celle-ci--
 
<garrysmod>/addons/nomalua/lua/autorun/init.lua
	
<garrysmod>/addons/nomalua/lua/sv_nomalua.lua

etc...

Veuillez noter que l'installation est la même sur les serveurs dédiés. 

L'installation nécessite un redémarrage du serveur.

--------------./> USAGE <\.--------------

LES COMMANDES DE LA CONSOLE :

.:> nomalua scan <:.

Une fois installé et le serveur redémarré, vous pouvez exécuter le scanner en ouvrant la console et en lançant la commande "nomalua scan".

Si vous exécutez directement sur le serveur, vous devriez immédiatement commencer à voir la sortie (exemple ci-dessous).

Si vous utilisez un client, vous devez avoir les privilèges superadmin. 

Lors de l'exécution dans une console client, il peut y avoir un délai avant que la sortie ne soit rendue. 

Nomalua est assez gourmand en ressources, il n'est donc pas recommandé de l'exécuter lorsque le serveur est particulièrement occupé. 

Exemple : balayage nomalua

Nomalua rapporte ce qui suit (échantillon) 

1 2 - AUTHENT (Présence de Steam ID) gamemodes/jailbreak/gamemode/core/cl_menu_help_options.lua:218 : Excl (STEAM_0:0:0:19441588) - Développeur principal en charge de Jail Break depuis la version 1
2 4 - NETWORK (appel serveur HTTP) addons/hatschat2/lua/hatschat/cl_init.lua:196 http.Fetch( FUrl, function( body, len, header, code)
3 2 - BANMGMT (Bannir par adresse IP) addons/customcommands_onecategory/lua/ulx/modules/sh/cc_util.lua:283 local banip = ulx.command("Custom", "ulx banip", ulx.banip )
4 2 - DYNCODE (Exécution du code dynamique) lua/autorun/luapad.lua:152 RunString(file.Read("luapad/_server_globals.txt", "DATA")) ;
5 2 - FILESYS (Suppression de fichiers) addons/customcommands_onecategory/lua/ulx/modules/sh/cc_util.lua:909 file.Delete("watchlist/"... id... ".txt" )
6 3 - OBFUSC (code obscurci / crypté) lua/includes/extensions/string.lua:34 str = str:gsub("\226\128\168", "\\\\\226\128\168") )

La première colonne est simplement le numéro de séquence (ID) de l'entrée de balayage. Ceci peut être utilisé lors de l'ajout d'éléments en liste blanche.

La deuxième colonne contient la cote de risque, le type de contrôle et la description.

Actuellement, Nomalua détecte le code dynamique (code qui s'exécute dynamiquement, à l'aide d'une chaîne de compilation, etc.), 

les contrôles d'authentification (références aux Steam IDs), l'activité réseau (appels à http.Post et Fetch), les éléments liés au bannissement (modifications du statut du bannissement), 

le code masqué (bytecode, cryptage) et les appels système (suppression de fichier). La cote de risque va de 1 à 5, 5 étant la plus élevée.

À l'heure actuelle, le système de cotation est plutôt arbitraire - il sera renforcé avec le temps.

La troisième colonne indique le numéro de fichier et de ligne de la détection.  Notez que si cet addon est contenu dans un GMA, 

vous devrez décompresser manuellement le fichier.gma afin de visualiser le fichier directement.

La quatrième colonne affiche la ligne elle-même, 

la phrase de détection étant surlignée en jaune. 

::::: : nomalua dumpfile <filepath> ::::: :

Cette commande videra le contenu d'un fichier dans la console pour une enquête plus approfondie.
