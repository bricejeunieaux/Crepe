# CRÊPE - Une base de données manipulable en Bash
##### Auteur : Brice Jeunieaux____________________Version actuelle : 0.7.7.0/i____________________Licence : GNU GPL v3
##### Date de début du projet : 24 Février 2018

-----------------------------------------------------------------------------------------------
### Petit mot pour l'utilisateur :
Merci d'utiliser CRÊPE, un système de gestion de base de donnée en Bash.
Ce projet est né de la nécessité de stocker différentes variables d'un jeu dans un fichier .txt.
Le but était de pouvoir les afficher, les modifier, et les ré-écrire dans le fichier .txt.
Mon esprit est naturellement parti sur l'idée de concevoir une base de données **_simplissime_**, programmée sur deux fichiers, qui prendrait **_relativement peu de place_** tout en étant intuitive et **_facile à la prise en main_** pour l'utilisateur.

-----------------------------------------------------------------------------------------------
### Explication sur les fichiers :
- _crepeBD.txt_ : il contient toutes les données, organisées en lignes.
Chaque ligne de données (LD) contient différents champs, séparés par un point-virgule.
Ces différents champs au sein d'une LD peuvent être de nature différentes (nombre, chaîne de caractères).
- _crepeScript.txt_ : c'est lui qui va aller chercher l'information dans le premier fichier.
Ensuite, l'information est traitée et affichée. Par la suite se sont ajoutées différentes fonctionnalités.
- _versions.txt_ : il contient une liste de toutes les versions de CRÊPE à ce jour, avec des détails sur les ajouts, retraits et modifications des fonctionnalités, ainsi que les correctifs.
- _README.md_ : le fichier que vous êtes actuellement en train de lire, cela va de soi...
- _LICENSE_ : un fichier de la _Free Software Foundation_ expliquant la licence GNU GPL v3

Afin de démarrer correctement le système CRÊPE, il vous est recommandé de rendre exécutable, si ce n'est déjà fait, le fichier _crepeScript.sh_ avec la commande `chmod +x crepeScript.sh`, puis de démarrer CRÊPE avec la commande `./crepeScript.sh`.

-----------------------------------------------------------------------------------------------
### Contacts :
Pour toute question/suggestion/signalement d'un problème/autre, vous pouvez me contacter via :

Pidgin : brice_jeunieaux@member.fsf.org _(de préférence)_  
E-mail : JeunieauxBrice@hotmail.fr
