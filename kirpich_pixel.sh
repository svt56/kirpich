#!/bin/bash

token="0000000000:AAAAAAAAAAAAAASSAAAAAAAAAAAAAAA"
#function send message
function sendtlg {
id=(1111011111 222222222) #telegramm id for recive notifly
url="https://api.telegram.org/bot$token/sendMessage"
for i in ${!id[@]};do
curl -s -X POST $url -d chat_id=${id[$i]} -d text="$1" -d protect_content="1"
done
}
#function openconnect
function fnopened {
 userO=$(echo $1 | cut -d' ' -f11 | cut -d'(' -f1)
 ipp=$(who | grep "$userO" | tr -s ' ' | cut -d' ' -f5 | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}')
 tiime=$(echo $1 | cut -d' ' -f3)
 textO="Server%20ASTERISK%0AOPEN%20connect%20from%20user%20"$userO"%20с%20adress%20"$ipp"%20in%20"$tiime
 sendtlg $textO
 #list session
 readarray -t who < <(who)
 var=$( IFS=$";"; echo "${who[*]}" )
 var=${var//;/%0A}
 sendtlg ${var// /%20}
 return
}
#function closed
function fnclosed {
 userC=$(echo $1 | cut -d' ' -f11)
 textC="Cloused%20connection%20user%20"$userC"%20in%20"$(date +%T)
 sendtlg $textC
return
}
while true
 do
 sleep 2
  opened=$(tail -n 3 /var/log/auth.log | grep opened | tr -s ' ')
  markerO=$(echo $opened | cut -d' ' -f1)
if [ -n "$markerO" ]; then 
  if [ "$opened" != "$opened2" ]; then 
   fnopened "$opened"
   opened2=$opened
  fi
fi
  closed=$(tail -n 3 /var/log/auth.log | grep closed | tr -s ' ')
  markerC=$(echo $closed | cut -d' ' -f1)
if [ -n "$markerC" ]; then 
  if [ "$closed" != "$closed2" ]; then 
   fnclosed "$closed"
   closed2=$closed
  fi
fi
done 
