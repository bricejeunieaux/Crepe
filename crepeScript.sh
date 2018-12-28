#!/bin/bash

######################################################	######################################################
#	   _____ _____  ______ _____  ______ 	     #	#                                     		     #
#	  / ____|  __ \|  ____|  __ \|  ____|	     #	#        SYSTÈME DE GESTION DE BASE DE DONNÉES       #
#	 | |    | |__) | |__  | |__) | |__   	     #	#                                     		     #
#	 | |    |  _  /|  __| |  ___/|  __|  	     #	#     Prototype actuel codé en script Bash Linux     #
#	 | |____| | \ \| |____| |    | |____ 	     #	#                                     		     #
#	  \_____|_|  \_\______|_|    |______|	     #	#             Version uploadée : 0.6.6.0             #
#                                     		     #	#                                     		     #
######################################################	######################################################

#Auteur du projet source : Jeunieaux Brice	-	JeunieauxBrice@hotmail.fr	brice_jeunieaux@member.fsf.org (XMPP/Pidgin)
#Github du projet	 : https://github.com/bricejeunieaux/databaseCrepe
#Licence GNU GPL v3	 : https://www.gnu.org/licenses/quick-guide-gplv3.fr.html





##############################  PARTIE 1 : PARAMÉTRAGE NON-IMPORTANTS	########################################
#####Ces paramétrages ne jouent pas un grand rôle dans le script (pas d'opérations)

initFenetre() {						#Dimensionnage fenêtre + effaçage

resize -s 35 120
clear

echo "PRÉPARATION DE LA BASE DE DONNÉES \"CRÊPE\" (v0.6.6.0) ..."		#Simple message inutile pour combler les 2 secondes de chargement au début

}

initFenetre ;

definitionCouleur() {					#Fonction pour faciliter la colorisation dans le script
							#à l'aide de variables contenant les "code-couleurs"
enDefaut='\033[0m' ;

fgBlanc='\033[37m' ;
fgCyan='\033[36m' ;
fgViolet='\033[35m' ;
fgBleu='\033[34m' ;
fgJaune='\033[33m' ;
fgVert='\033[32m' ;
fgRouge='\033[31m' ;
fgNoir='\033[30m' ;

bgBlanc='\033[47m' ;
bgCyan='\033[46m' ;
bgViolet='\033[45m' ;
bgBleu='\033[44m' ;
bgJaune='\033[43m' ;
bgVert='\033[42m' ;
bgRouge='\033[41m' ;
bgNoir='\033[40m' ;

enGras='\033[1m' ;
enSouligne='\033[4m' ;
enSurligne='\033[7m' ;

}

definitionCouleur ;


filenameBD="crepeBD.txt"				#Stockage BD par défaut crepeBD.txt dans une variable (!= en dur)





##############################  PARTIE 2 : PARAMÉTRAGE IMPORTANTS	########################################
#####Ce sont les paramétrages liés à une partie dynamique du programme (affichage, défilement des lignes/pages)
#####Ces paramétrages sont très liés aux fonctions mais contrairement aux fonctions périphériques, on n'y revient pas dessus.

nbLignesDonnees() {					#Calcul du nombre de lignes exploitables dans la BD pour le système d'affichage

nbLignesBD=$(grep -iG '^l[0-9]\{1,\}x' $filenameBD | wc -l)	#Nombre de lignes exploitables dans la BD

}

nbLignesDonnees ;

initNbLignesAfficheesEtPageActuelle() {				#Paramétrages du système de défilement des données dans le système de l'affichage

nbLignesAffichees=15 ;						#Nombre de lignes à afficher par page dans l'afficheur

pageActuelle=1 ;						#Page affichée au démarrage

}

initNbLignesAfficheesEtPageActuelle ;

calculNbPages() {						#Calcul du nombre de pages affichables à partir du nombre d'entrées
								#et du nombre de lignes à afficher (division euclidienne)
nbLignesRencontrees=0 ;

for (( a=1 ; a<=$nbLignesBD ; a++ )) do				#On fait une boucle for qui va compter le nombre de lignes.

	nbLignesRencontrees=$(($nbLignesRencontrees+1)) ;	#À chaque fois que l'on arrive à 15 lignes, on augmente le nombre
								#de pages de 1, puis on reset la variable dans laquelle on a
	if	[ $(($nbLignesRencontrees%15)) -eq 0 ]		#mis le nombre de lignes rencontrées
	then	nbPagesBD=$(($nbPagesBD+1))
		nbLignesRencontrees=0 ;				#Cela permet de gérer une certaine situation lorsque le reste d'un
	fi							#modulo sera non-nul (donc, une page ne comprenant pas 15 entrée)

done

if	[ $(($nbLignesRencontrees%15)) -gt 0 ]			#À la fin du comptage, on récupère le reste du modulo
then	nbPagesBD=$(($nbPagesBD+1))				#S'il est positif, cela veut dire qu'il y aura une page non-remplie.
	#nbLignesRencontrees=0 ;				#On ajoute donc une page pour pouvoir afficher ces données.
fi

}

calculNbPages ;





##############################  PARTIE 3 : PARTIE "ÉLOIGNÉE" DU CENTRE DU PROGRAMME	########################################
#####Le concept d'éloignement est très imagé, il s'agit ici d'une partie effectuant des opérations difficiles à appréhender
#####Pour cette partie, un commentaire est situé au début de chaque fonction pour rappeler à quelles fonctions elles sont rattachées
#####
#####Ces fonctions sont appelées de une à plusieurs fois au cours du programme : ainsi, elles sont essentielles à son fonctionnement

declare -A tab ;						#Tableau1 contenant les données du fichier .txt

traitementLDTab() {
	
	for (( a=1 ; a<=$nbPagesBD ; a++ )) do
		for (( b=$(($((15*$(($a-1))))+1)) ; b<=$((15*$a)) ; b++ )) do
			for (( c=2 ; c<=7 ; c++ )) do
				tab["Page$a,LD$b,Champ$c"]=$(grep -G '^l'$(($b))x crepeBD.txt | cut -d \; -f $c)
			done
		done
	done
	
}

traitementLDTab ;

defilement() {							#Fonction activable depuis le menu : défile les pages et en affiche les LD

	PageGauche() {
	
	pageActuelle=$(($pageActuelle-1))
	if	[ $pageActuelle -lt '1' ]
	then	pageActuelle=1
	fi

	affichage ;

	}

	PageDroite() {
	
	pageActuelle=$(($pageActuelle+1))
	if	[ $pageActuelle -gt $nbPagesBD ]
	then	pageActuelle=$nbPagesBD
	fi
	
	affichage ;
	
	}
	
	if	[ $1 = "PageGauche" ] && [ $nbPagesBD -gt 1 ] && [ $pageActuelle -ne 1 ]
	then	PageGauche ;
	elif	[ $1 = "PageDroite" ] && [ $nbPagesBD -gt 1 ] && [ $pageActuelle -ne $nbPagesBD ]
	then	PageDroite ;
	else	getToucheMenuFiltrage ;
	fi
	
}





##############################  PARTIE 4 : CŒUR DU PROGRAMME : MAXIMUM DE COMPRÉHENSION  ########################################
#####Ici se trouve le centre du programme comprenant toutes les fonctions que l'utilisateur pourra rencontrer en surface.
#####Bien plus appréhendables, ce sont elles que l'utilisateur peut voir en action (affichage, appui touche menu, ...)

getToucheMenuFiltrage() {				#Gestion de la touche appuyée lors de fnctn selectionModeAffichage()

	escape_char=$(printf "\u1b")
	read -rsn1 mode # get 1 character

	if	[[ $mode == $escape_char ]]
	then	read -rsn2 mode # read 2 more chars
	fi

	case $mode in

		'q') resize -s 24 80 ; clear ; tput cup 0 0 ; exit ;;
		'Q') resize -s 24 80 ; clear ; tput cup 0 0 ; exit ;;
		'0') modeAffichage=0 ; affichage ;;
		'-') defilement PageGauche ;;
		'+') defilement PageDroite  ;;
		#'1') modeAffichage=1 ; idClientVoulu=3 ; affichage ;;
		#'2') modeAffichage=2 ; idClientVoulu=12 ; affichage ;;
		*) >&2 getToucheMenuFiltrage ;;

	esac

}

affichageInfosDev() {

tput cup 0 0 ; echo -e "${fgBlanc}${bgViolet}Infos développeur :${enDefaut} nbLignesBD = $nbLignesBD ; nbLignesAffichees = $nbLignesAffichees ; nbPages = $nbPagesBD Page actuelle = $pageActuelle ; nbLignesRencontrees = $nbLignesRencontrees " ;
tput cup 1 0 ; echo -e "${fgBlanc}${bgViolet}Infos développeur :${enDefaut}" ;

}

header() {						#Affichage de l'en-tête de la BD

tput cup 3 5  ; echo -e "${bgBlanc}${fgNoir}NUM. COMMANDE${enDefaut}"
tput cup 3 24 ; echo -e "${bgBlanc}${fgNoir}NOM CLIENT${enDefaut}"
tput cup 3 50 ; echo -e "${bgBlanc}${fgNoir}ID. CLIENT${enDefaut}"
tput cup 3 66 ; echo -e "${bgBlanc}${fgNoir}QUANTITÉS${enDefaut}"
tput cup 3 81 ; echo -e "${bgBlanc}${fgNoir}ARTICLES${enDefaut}"

}

lignesDonnees() {					#Affichage des entrées de la BD

for (( b=$(($((15*$(($pageActuelle-1))))+1)) ; b<=$((15*$pageActuelle)) ; b++ )) do
	for (( c=2 ; c<=7 ; c++ )) do
		tput cup $(($b+4-$(($pageActuelle-1))*15)) 5 ; echo -e "${tab["Page$pageActuelle,LD$b,Champ4"]}" ;
		tput cup $(($b+4-$(($pageActuelle-1))*15)) 24 ; echo -e "${tab["Page$pageActuelle,LD$b,Champ3"]}" ;
		tput cup $(($b+4-$(($pageActuelle-1))*15)) 50 ; echo -e "${tab["Page$pageActuelle,LD$b,Champ2"]}" ;
		tput cup $(($b+4-$(($pageActuelle-1))*15)) 66 ; echo -e "${tab["Page$pageActuelle,LD$b,Champ5"]}" ;
		tput cup $(($b+4-$(($pageActuelle-1))*15)) 81 ; echo -e "${tab["Page$pageActuelle,LD$b,Champ6"]}" ;
	done
done

}

menuSelectionModeAffichage() {				#Menu pour choisir le mode d'affichage

tput cup 21 5 ; echo -e "${fgVert}[-] Changer de page [+]${enDefaut}          Page actuelle : $pageActuelle / $nbPagesBD"

tput cup 23 5   ; echo -e "${bgBlanc}${fgNoir}Rechercher des lignes selon un mode voulu (entrez le caractère associé) :${enDefaut}"
tput cup 24 5   ; echo -e "[0] Mode 0     [1] Mode 1     [2] Mode 2     [3] Mode 3     [4] Mode 4     [Q] Quitter"
tput cup 24 95 ;

getToucheMenuFiltrage ;

}

affichage() {						#Affichage de l'intégralité des infos que l'utilisateur doit voir

clear ;

affichageInfosDev ;

header ;						#Appel de l'header contenant les noms des données, pour affichage

lignesDonnees ;

menuSelectionModeAffichage ;

}

affichage ;

