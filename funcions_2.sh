#! /bin/bash
# @edt ASIX M01-ISO
# funciones 21-25

#function getHoleList(){
#for login in $*
#do
#done 
#}

function getHome(){

login=$1
grep "^$login:" /etc/passwd &> /dev/null

if [ $? -eq 0 ]
then
  grep "^$login:" /etc/passwd | cut -d: -f6
  return 0 
else
  echo "Error: $login no existe" 
  return 1 

fi

}
