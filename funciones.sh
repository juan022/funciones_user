#! /bin/bash
#
# @Juan Sánchez
#
# Mar 2021
#
# Lista de scripts De usuarios
#

# Ejercicio 9: Mostrar todos los grupos del sistema ordenados por gname, se debe
## mostrar el nombre del grupo en el encabezado y a continuacion todos los usuarios
### que lo tengan como grupo principal ordenado por login

showallgroup(){
	linea=''
	gname=$(sort -t: -k1,1 /etc/group | sed 's/^.*:.*:/GGG/g')
	for group in $gname
	do
	 echo $group
	 echo $(grep ^$group: /etc/group | cut -d: -f4)
        done
	return 0


}




# Ejercicio 8: Ampliar ejercicio 7, formato de presentacion de los datos:

## a) Separados por un tabulador (cada campo del usuario)
function showgroupa(){
	 # Verificar num args
        if [ $# -ne 1 ]
        then
         echo "Error: num arg no valid"
         echo "Usage: $0 gname"
         return 1
        fi
        # Validar gname
        gname=$1
        grep ^$gname: /etc/group >> /dev/null
        if [ $? -ne 0 ]
        then
         echo "Error: el gname $gname no existe"
         echo "Usage: $0 gname"
         return 2
        fi
        # lista de users
        gid=$(grep ^$gname: /etc/group | cut -d: -f3)
        lista_users=$(grep ^.*:.*:.*:$gid: /etc/passwd | cut -d: -f1,3,6,7)
        # Mostra users e info
	grep ^.*:.*:.*:$gid: /etc/passwd | cut -d: -f1,3,6,7 | tr ':' '\t'
        return 0
}

## b) Separados cada campo por dos espacios
function showgroupb(){
         # Verificar num args
        if [ $# -ne 1 ]
        then
         echo "Error: num arg no valid"
         echo "Usage: $0 gname"
         return 1
        fi
        # Validar gname
        gname=$1
        grep ^$gname: /etc/group >> /dev/null
        if [ $? -ne 0 ]
        then
         echo "Error: el gname $gname no existe"
         echo "Usage: $0 gname"
         return 2
        fi
        # lista de users
        gid=$(grep ^$gname: /etc/group | cut -d: -f3)
        lista_users=$(grep ^.*:.*:.*:$gid: /etc/passwd | cut -d: -f1,3,6,7)
        # Mostra users e info
        grep ^.*:.*:.*:$gid: /etc/passwd | cut -d: -f1,3,6,7 | sed 's/:/  /g'
        return 0        
}

## c) Ordenados por login y separados por dos espacios
function showgroupc(){
         # Verificar num args
        if [ $# -ne 1 ]
        then
         echo "Error: num arg no valid"
         echo "Usage: $0 gname"
         return 1
        fi
        # Validar gname
        gname=$1
        grep ^$gname: /etc/group >> /dev/null
        if [ $? -ne 0 ]
        then
         echo "Error: el gname $gname no existe"
         echo "Usage: $0 gname"
         return 2
        fi
        # lista de users
        gid=$(grep ^$gname: /etc/group | cut -d: -f3)
        lista_users=$(grep ^.*:.*:.*:$gid: /etc/passwd | cut -d: -f1,3,6,7)
        # Mostra users e info
        grep ^.*:.*:.*:$gid: /etc/passwd | cut -d: -f1,3,6,7 | sort -t: -k1,1 | sed 's/:/  /g'
        return 0
}

## d) Ordenados por uid, seprados por un espacio y todo en mayusculas
function showgroupd(){
         # Verificar num args
        if [ $# -ne 1 ]
        then
         echo "Error: num arg no valid"
         echo "Usage: $0 gname"
         return 1
        fi
        # Validar gname
        gname=$1
        grep ^$gname: /etc/group >> /dev/null
        if [ $? -ne 0 ]
        then
         echo "Error: el gname $gname no existe"
         echo "Usage: $0 gname"
         return 2
        fi
        # lista de users
        gid=$(grep ^$gname: /etc/group | cut -d: -f3)
        lista_users=$(grep ^.*:.*:.*:$gid: /etc/passwd | cut -d: -f1,3,6,7)
        # Mostra users e info
        grep ^.*:.*:.*:$gid: /etc/passwd | cut -d: -f1,3,6,7 | sort -t: -k3,3 | tr ':' ' ' | tr '[:lower:]' '[:upper:]'
        return 0
}


# Ejercicio 7: Dado un gname mostrar el listado que tienen ese grupo como principal.
## Mostrar login, uid, dir y shell de cada user. Validar que se recibe un arg y el gname es valido

function showgroupmainmembers(){
	# Verificar num args
	if [ $# -ne 1 ]
	then
	 echo "Error: num arg no valid"
	 echo "Usage: $0 gname"
	 return 1
	fi
	# Validar gname
	gname=$1
	grep ^$gname: /etc/group >> /dev/null
	if [ $? -ne 0 ]
	then
	 echo "Error: el gname $gname no existe"
	 echo "Usage: $0 gname"
	 return 2
	fi
	# lista de users
	gid=$(grep ^$gname: /etc/group | cut -d: -f3)
	grep ^.*:.*:.*:$gid: /etc/passwd | cut -d: -f1,3,6,7
	return 0

}




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




# Ejercico 5: Misma funcion que showeruserlogin pero procesando n logins por argumento

function showuserlist(){
	for login in $*
	do
	 # Verificamos que el login exista
	 grep ^$login: /etc/passwd >> /dev/null
	 if [ $? -ne 0 ]
	 then
	  echo "Error: login $login no valid"
	  echo "Usage: $0 login[...]"
	 fi
	 # Extraemos datos del login
	 info=$(grep ^$login: /etc/passwd) 2> /dev/null
         uid=$(echo $info | cut -d: -f3)
         gid=$(echo $info | cut -d: -f4)
         gecos=$(echo $info | cut -d: -f5)
         home=$(echo $info | cut -d: -f6)
         shell=$(echo $info | cut -d: -f7)
	 # Mostramos los datos
	 echo "Info del user $login"
         echo "login: $login"
         echo "uid: $uid"
         echo "gid: $gid"
         echo "home: $home"
         echo "shell: $shell"
	 echo ""
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

