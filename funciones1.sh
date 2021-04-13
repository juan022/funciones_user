#! /bin/bish 
# Examples de funciones 


function showgroup(){

ERR_ARGS=1
ERR_NOGROUP=2

#1) validar si rep 1 arg 

if [ $# -lt 1 ]
then 
  echo "Error: # args incorrecto" 
  echo "Usage: $0 group "
  return $ERR_ARGS
fi

#2) validar si existe el grupo 

gname=$1
line=$(grep "^$gname:" /etc/group 2> /dev/null) 

if ! [ $? -eq 0 ]
then
  echo "Error: Group $gname no existe" 
  echo "Usage: $0 group"
  return $ERR_NOGROUP
fi

#3) Mostrar 

gid=$(echo $line|cut -d: -f3) 
g_users=$(echo $line|cut -d: -f4)

echo "gid: $gid"
echo "users: $g_users"

return 0 
}



function showuser(){

#1) Validar si rep 1 arg 
ERR_ARGS=1
ERR_NOLOGIN=2
OK=0
if [ $# -lt 1 ]
then
  echo "Error: # args incorrecto" 
  echo "Usage: $0 login" 
  return $ERR_ARGS
fi 

#2)validar si existe el usuario

login=$1 
line=$(grep "^$login:" /etc/passwd 2> /dev/null)

if ! [ $? -eq 0 ] 
then
  echo "Error: login $login no existe"
  echo "usage: $0 login"
  return $ERR_NOLOGIN
fi 


#3) Mostrar 

uid=$(echo $line|cut -d: -f3) 
gid=$(echo $line|cut -d: -f4)
gecos=$(echo $line|cut -d: -f5)
home=$(echo $line|cut -d: -f6)
shell=$(echo $line|cut -d: -f7)

echo "login: $login"
echo "uid: $uid"
echo "gid: $gid" 
echo "gecos: $gecos"
echo "home: $home"
echo "shell: $shell"

line2=$(grep "^$gid" /etc/group 2> /dev/null) 
gname=$(echo $line2|cut -d: -f1) 
echo "gname: $gname"

return 0 
}


function suma(){
	echo "La suma es: $(($1+$2))" 
	return 0  
}

function dia(){
 date 
 return 0 

}
