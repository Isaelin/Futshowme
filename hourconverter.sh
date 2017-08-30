#!/bin/bash
captura=$1
videoCaptura="video$$"
dir=`pwd`
workspace="$dir/tmp/video_extraido"

if [ $captura = "captura" ]; then
cronometro=`cat timeResult.txt`
fi
tempoPassado=`expr $cronometro - 5`
tempoFuturo=`expr $tempoPassado + 20`
trataCronometro()
{
local tempo=$1

if [ $tempo -ge 3600 ]; then
hora=$(($tempo / 3600))
resto=$(($tempo % 3600))
minuto=$(($resto / 60))
segundo=$(($resto % 60))
else
segundo=`expr $tempo % 60`
minuto=`expr $tempo / 60`
hora=`expr $tempo / 3600`
fi
HORASF=$(printf '%.2d' $hora)
MINUTOSF=$(printf '%.2d' $minuto)
SEGUNDOSF=$(printf '%.2d' $segundo)
hora="$HORASF:$MINUTOSF:$SEGUNDOSF"
export RETORNO=$hora
return
}
#sleep 20
trataCronometro $tempoPassado
horacorte=`echo $RETORNO`
trataCronometro $tempoFuturo
horaFutura=`echo $RETORNO`
sleep 16

mkdir $workspace

ffmpeg -i videoCamera.avi -vcodec copy -ss $horacorte -t $horaFutura -f avi pipe:1 | cat > $workspace/$videoCaptura.avi
