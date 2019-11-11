#!/bin/bash

nome_videos() {

	pathVideos=$1
	videos=`ls $pathVideos`
	echo $videos

}

tira_audio() {

	pathVideos=$1
	videos=`ls  $pathVideos | grep .avi`
	
	status=$?

	if [ $status != 0 ]; then
		   echo "Erro ao capturar Videos para edição"
		   exit 3
	fi

	cd $pathVideos
	for video in $( echo $videos); do
		semAudio="NoAudio${video}"
		ffmpeg -i $video -y -an $semAudio
	done
}


gera_slow() {

	pathVideos=$1
        videos=`ls  $pathVideos | grep .avi | grep -v NoAudio`

	status=$?

        if [ $status != 0 ]; then
                   echo "Erro ao capturar Videos para edição"
                   exit 3
        fi

	cd $pathVideos
	for video in $( echo $videos); do
                nome_slow="Slow${video}"
                ffmpeg -i $video -y -filter:v setpts=1.2*PTS $nome_slow
        done
}

repo_propagandas() {

	path_propagandas=$1
	propagandas=`ls $path_propagandas`
	echo $propagandas

}

	pathVideos="/home/isaelin/FutShowMe/videos/videos_teste"
        pathPropagandas="/home/isaelin/FutShowMe/videos/propagandas"

	videos=`nome_videos $pathVideos`

	tira_audio $pathVideos

	gera_slow $pathVideos

	prop=`repo_propagandas $pathPropagandas`

	cd $pathVideos
	for video in $(echo $videos); do

		videoNoAudio=`ls | grep $video | grep NoAudio`
		videoSlow=`ls | grep $video | grep Slow`

		sh /home/isaelin/FutShowMe/finalizaVideo.sh $pathVideos $videoNoAudio $videoSlow

	done
