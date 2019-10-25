#!/bin/bash

dir="dirVideo/outroDir"
awsProfile="israel"
bucketVideos="futshowme-videos"
videoAWSList=`aws s3 ls s3://${bucketVideos} --profile ${awsProfile} | rev | cut -d " " -f1 | rev`

for video in $(echo $videoAWSList); do
	 
	imagem_abertura="imagem.png"
	imagem_propaganda="propaganda.mp4"
	video_normal="${video}"
	video_slow="${video}-slow"

	echo "ffmpeg -y \ 
-loop 1 -t 3 \
-i $imagem_abertura \
-loop 1 -t 3 \
-i $imagem_propaganda \
-i $video_normal -an \
-i $video_slow -an \
-filter_complex \
'"'[3:v]setpts=1.7*PTS[v0]; \
[0:v]scale=1440x900,setdar=8:5,setsar=1:1[v1]; \
[1:v]scale=1440x900,setdar=8:5,setsar=1:1[v2];\
[1:v]scale=1440x900,setdar=8:5,setsar=1:1[v3];\
[v1][2:v][v2][v0][v3]concat=n=5:v=1,format=yuv420p[out]'"' -map '"'[out] -c copy'"' $dir/FutShow-`date +%d-%m-%Y_%H:%M:%S`.mp4"
	echo
	echo	
	echo
done
