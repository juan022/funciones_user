#! /bin/bash
#edt @asix m01
#diego sanchez piedra
#-------------------------
#25) getAllUserZise
function getAllUserZise(){
  while read -r line;do
   getSize $(echo $line | cut -d: -f6)
  done < /etc/passwd
}

#--------------------------
#24) getSizeIn
function getSizeIn(){
  status=0
  while read -r login; do
  	#validar login
  	egrep "^$login:" /etc/passwd &> /dev/null
  	if [ $? -ne 0 ]; then
  	  echo "error: login $login no existeix"
  	  ((status++))
  	#xixa
  	else
  	  home=$(getHome $login)
  	  getSize $home
  	fi
  done
  return $status
}
#23) getSize homedir
function getSize(){
  if ! [ -d $1 ]; then
  	return 1
  fi
  du -s -b $1 2> /dev/null | cut -f1
  return 0
}
#--------------------------
#22) getHoleList login[...]
function getHoleList(){
  ERR_NARGS=1
  status=0
  #valdidar nº d'args
  if [ $# -lt 1 ]; then
  	echo "erro nº d'args $# incorrecte" >> /dev/stderr
  	echo "usage: getHoleList login[...]" >> /dev/stderr
  fi
  #xixa
  loginList=$*
  for login in $loginList; do
  	#validar el login
  	egrep "^$login:" /etc/passwd &> /dev/null
  	if [ $? -ne 0 ]; then
  	  echo "error: el login $login no existeix" >> /dev/stderr
  	  ((status++))
  	else
  	  #xixa
  	  getHome $login
  	fi
  done
  return $status
}
#--------------------------
#21) getHome
function getHome(){
  login=$1
  egrep "^$login:" /etc/passwd &> /dev/null
  if [ $? -ne 0 ]; then
    return 1
  fi 
  egrep "^$login:" /etc/passwd | cut -d: -f6
}
#--------------------------
#20) showPedidos
function showPedidos(){
  ERR_NARGS=1
  ERR_OFI=2
  OK=0
  #validar args
  if [ $# -ne 1 ]; then
  	echo "error: nº d'args $# incorrecte" >> /dev/stderr
  	echo "usage: showPedidos (nº oficina)" >> /dev/stderr
  	return $ERR_NARGS
  fi
  #validar nº d'oficina
  oficina=$1
  if ! [ $oficina -ge 11 -a $oficina -le 13 -o $oficina -ge 21 -a $oficina -le 22 ]; then
  	echo "error: oficina $oficina no valida" >> /dev/stderr
  	return $ERR_OFI
  fi

  #xixa
  repList=$(egrep "^[^:]*:[^:]*:[^:]*:$oficina:" /tmp/training/repventas.txt | cut -d: -f1)
  for rep in $repList;do
  	echo $rep
  	egrep "^[^:]*:[^:]*:[^:]*:$rep:" /tmp/training/pedidos.txt
  done
  return $OK
}
#--------------------------
#19) showGidMembers2
function showGidMembers2(){
  ERR_NARGS=1
  ERR_FILE=2
  status=0
  #validar args
  if [ $# -gt 1 ]; then
    echo "error: nº d'args incorrecte" >> /dev/stderr
    echo "usage: function file" >> /dev/stderr
    return $ERR_NARGS
  fi
  fileIn=/dev/stdin
  if [ $# -eq 1 ]; then
    if ! [ -f $1 ]; then
      #validar que l'arg sigui un regular file i exisitex
      echo "error: file $1 no es un regular file o no existeix"
      echo "usage: function file|stdin"
      return $ERR_FILE
    else
      fileIn=$1
    fi
  fi
  #xixa
  while read -r gid; do
    egrep "^[^:]*:[^:]*:$gid:" /etc/group &> /dev/null
    if [ $? -ne 0 ]; then
      echo "error el gid $gid no existeix" >> /dev/stderr
      ((status++))
    else
      wc=$(egrep "^[^:]*:[^:]*:[^:]*:$gid:" /etc/passwd | wc -l)
      if [ $wc -ge 3 ]; then
        egrep "^[^:]*:[^:]*:[^:]*:$gid:" /etc/passwd | cut -d: -f1,3,6
      fi
    fi
  done < $fileIn
  return $status
}
#18) showGidMembers
function showGidMembers(){
  ERR_NARGS=1
  ERR_FILE=2
  status=0
  #validar args
  if [ $# -gt 1 ]; then
    echo "error: nº d'args incorrecte" >> /dev/stderr
    echo "usage: function file" >> /dev/stderr
    return $ERR_NARGS
  fi
  fileIn=/dev/stdin
  if [ $# -eq 1 ]; then
    if ! [ -f $1 ]; then
      #validar que l'arg sigui un regular file i exisitex
      echo "error: file $1 no es un regular file o no existeix"
      echo "usage: function file|stdin"
      return $ERR_FILE
    else
      fileIn=$1
    fi
  fi
  #xixa
  while read -r gid; do
    egrep "^[^:]*:[^:]*:$gid:" /etc/group &> /dev/null
    if [ $? -ne 0 ]; then
      echo "error el gid $gid no existeix" >> /dev/stderr
      ((status++))
    else
      egrep "^[^:]*:[^:]*:[^:]*:$gid:" /etc/passwd | cut -d: -f1,3,6
    fi
  done < $fileIn
  return $status
}
#--------------------------
#11) showAllGroupMembers2
function showAllGroupsMembers2(){
  OK=0
  gnameList=$(sort /etc/group | cut -d: -f1)
  for gname in $gnameList; do
  	gid=$(egrep "^$gname:" /etc/group | cut -d: -f3)
  	wc=$(egrep "^[^:]*:[^:]*:[^:]*:$gid" /etc/passwd | wc -l)
  	echo "($gname): $wc"
  	egrep "^[^:]*:[^:]*:[^:]*:$gid" /etc/passwd | sort | cut -d: -f1,3,6,7
  done
  return $OK
}
#---------------------------
#9) showAllGroupsMembers
function showAllGroupsMembers(){
  OK=0
  gnameList=$(sort /etc/group | cut -d: -f1)
  for gname in $gnameList; do
  	gid=$(egrep "^$gname:" /etc/group | cut -d: -f3)
  	echo "($gname)"
  	egrep "^[^:]*:[^:]*:[^:]*:$gid" /etc/passwd | sort
  done
  return $OK
}
