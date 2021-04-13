# Example de funcions 


function creaEscola(){
  for classe in $* 
  do 
    creaClasse $classe
  done 
}




function creaClasse(){
  classe=$1 	
  llista_noms=$(echo ${classe}{01..02}) 	
  for user in $llista_noms
  do 
   useradd $user
   echo "$user:$PASSWD" | chpasswd
 #chpasswd > file   
 # echo "alum" | passwd --stdin $user &> /dev/null
  done 
}

function showAllGroups(){
  llista_gids=$(cut -d: -f4 /etc/passwd | sort -n| uniq) 
$MIN_USERS=2
for gid in  $llista_gids
do  
  count=$(grep "^[^:]*:[^:]*:$gid:" /etc/passwd | wc -l)
  if [ $count -ge $MIN_USERS ] 
  then
    gname=$(grep "^[^:]*:[^:]*:$gid:" /etc/group | cut -d: -f1 ) 
    echo "$gname($gid): $count" 
  
    grep "^[^:]*:[^:]*:[^:]*:$gid:" /etc/passwd | sort | cut -d: -f1,3,7 \
	 			| sed -r 's/^(.*)$/\t\1/' 
  fi 
done
return 0 
}
