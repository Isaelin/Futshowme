#!/bin/bash

python Camera_record_start.py 

stauts=$?

if [ $status != 0 ]; then
   echo "Erro ao startar a Camera, verifique e reinicie"
   exit 3
else

   sh cronometro.sh &
   #Copiar fluxo de video da live para a pasta local
   ffmpeg -i rtsp://192.168.42.1:554/live -crf 30 -preset ultrafast -r 30 -codec:v copy videoCamera.avi &
 
fi

