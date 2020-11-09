#!/bin/bash
#Practica16
#https://github.com/a18danperllu/Practica16/dperez-afegir-usuari-local.sh
#He afegit que demanès la password forçada per ser un nou login, encara que no la demanaves per si de cas, encara que ho demanaves automatitzat.


if [[ "${UID}" -eq 0 ]]
then
	echo " "
	echo "Has executat l'ordre com a superuser."
	echo " "

	#Proporciona una declaracio d'us si l'user no proporciona un nom de compte a la linia d'ordres i retorna un estat de sortida d'1. 
	if [ -n "$1" ]
	then
		echo "Benvingut $1"
	else
		echo "ERROR: No has passat cap parametre."
		echo "Ajuda d'us: ./afegir-usuari-local.sh dani"
		exit 1
	fi

	#El primer paramentre consisteix en el nom de l'user.
	nom=$1

	#Opcionalment, tambe podeu proporcionar un comentari al compte com a argument.
	coment=$2

	#Es generara automaticament una password per al compte.
	pass=$(openssl rand -base64 14)
	echo "La teva password es: ${pass}"
	echo " "

	#Crea l'user amb la password.
	sudo useradd -m ${nom} -p ${pass} -c "${coment}"
	
	#Comprova si l'user ha sigut creat anteriorment.
	if [ $? -eq 0 ]
	then
		echo "S'ha creat l'user correctament."
		cat /etc/passwd | grep ${nom}
		echo " "
	else
		echo "ERROR: No s'ha pogut creat l'user."
		exit 1
	fi
	
	#Estableix la contrasenya.
	echo ${nom}":"${pass} | chpasswd
	
	#Comprova que la contrasenya s'hagi creat correctament.
	if [ $? -eq 0 ]
	then
		echo "S'ha creat correctament la constrasenya."
		echo " "
	else
		echo "ERROR: La contrasenya no s'ha pogut crear."
		exit 1
	fi

	#Obligar a fer el canvi de la contrasenya en el primer login.
	echo "Es obligatori canviar la password el primer cop que ingreses amb aquest user."
	echo " "
	chage -d 0 ${nom}
	read -s pass2
	echo ${nom}":"${pass2} | chpasswd

	#Es mostra el nom d'user, la contrasenya i l'amfitrio del compte (host).
	echo "El teu nom d'user es: ${nom}"
	echo "La teva contrasenya es: ${pass2}"
	echo "El teu host on ho has creat es: ${HOSTNAME}"

else
	echo "Has d'executar l'ordre com a superuser."
	exit 1
fi

