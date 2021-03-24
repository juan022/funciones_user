#! /bin/bash
#
# @Juan Sánchez
#
# Mar 2021
#
# Lista de scripts De usuarios
#

# Ejercicio 6: Mostrar info de un user proocesado por la entrada estandar.

function showuserin(){
        # Leer entrada estandar
	while read -r line
	do
        # Validar la existenica del login (en bucle por si hay mas
         login=$line
	 grep ^$login: /etc/passwd >> /dev/null
         if [ $? -ne 0 ];
         then
          echo "Error: login inexistent"
          echo "Usage: $0 login"
          return 2
         fi
        #Extraer info de cada campo
         info=$(grep ^$1: /etc/passwd) 2> /dev/null
         uid=$(echo $info | cut -d: -f3)
         gid=$(echo $info | cut -d: -f4)
         gecos=$(echo $info | cut -d: -f5)
         home=$(echo $info | cut -d: -f6)
         shell=$(echo $info | cut -d: -f7)

        #Mostrar info linea a linea
         echo "Info del user $login"
         echo "login: $login"
         echo "uid: $uid"
         echo "gid: $gid"
         echo "home: $home"
         echo "shell: $shell"
         done
         return 0
 }







# Ejercicio 4: introducir un login por argumento y mostrar su informacion y su gname


function showusergname(){
	# Validar num arg
	if [ $# -ne 1 ]
	then
	 echo "Error: num args no valid"
	 echo "Usage: $0 login"
	 return 1
	fi

	# Validar la existencia del login
	login=$1
	grep ^$login: /etc/passwd >> /dev/null
	if [ $? -ne 0 ]
	then
	 echo "Error: login $login no existe"
	 echo "Usage: $0 login"
	 return 2
	fi

	# Extarer info
	info=$(grep ^$login: /etc/passwd) 2> /dev/null
        uid=$(echo $info | cut -d: -f3)
        gid=$(echo $info | cut -d: -f4)
        gecos=$(echo $info | cut -d: -f5)
        home=$(echo $info | cut -d: -f6)
        shell=$(echo $info | cut -d: -f7)
	gname=$(grep ^.*:.*:$gid: /etc/group | cut -d: -f1)

	# Mostrar
	echo "Info del user $1"
        echo "login: $1"
        echo "uid: $uid"
        echo "gid: $gid"
        echo "home: $home"
        echo "shell: $shell"
        echo "gname: $gname"
	return 0
 }






# Ejercicio 3: introducir un gname por argumento y mostrar su informacion

function showgroup(){
 # Validar
 if [ $# -ne 1 ]
 then
  echo "Error: num arg no valid"
  echo "Usage: $0 gname"
  return 1
 fi

 # Validar su existencia
 grep ^$1: /etc/group >> /dev/null
 if [ $? -ne 0 ]
 then
  echo "Error gname no existe"
  echo "Usage: $0 gname"
  return 2
 fi

 # Extraer datos
 info=$(grep ^$1: /etc/group) 2> /dev/null
 gname=$1
 gid=$(echo $info | cut -d: -f3)
 users=$(echo $info | cut -d: -f4)

 # Mostrar
 echo "Info del grupo $1"
 echo "gname: $gname"
 echo "gid: $gid"
 echo "users: $users"
 return 0

}






# ejercicio 1: Recibir un login por argumento y mostrar campo a campo los datos del usuario

function showuserlogin(){
	# Validar # arg
	if [ $# -ne 1 ];
	then
	 echo "Error: num args no valido"
	 echo "Usage: $0 login"
	 return 1
	fi
	
	# Validar la existenica del login (en bucle por si hay mas
	 grep ^$1: /etc/passwd >> /dev/null 
	 if [ $? -ne 0 ];
	 then
	  echo "Error: login inexistent"
	  echo "Usage: $0 login"
	  return 2
	 fi
	#Extraer info de cada campo
	 info=$(grep ^$1: /etc/passwd) 2> /dev/null
	 uid=$(echo $info | cut -d: -f3)
	 gid=$(echo $info | cut -d: -f4)
	 gecos=$(echo $info | cut -d: -f5)
	 home=$(echo $info | cut -d: -f6)
	 shell=$(echo $info | cut -d: -f7)
	
	#Mostrar info linea a linea
	 echo "Info del user $1"
	 echo "login: $1"
	 echo "uid: $uid"
	 echo "gid: $gid"
	 echo "home: $home"
	 echo "shell: $shell"
	 return 0
 }

