#!/usr/bin/env bash

pathVideos=$1
video_normal=$2
video_slow=$3
imagem_abertura="/home/isaelin/FutShowMe/videos/propagandas/futshow_branco_1920_1080.png"
imagem_propaganda="/home/isaelin/FutShowMe/videos/propagandas/futshow_preto_1920_1080.png"

bucketName="futshowme-videos"
awsProfile="israel"
pathVideosExtraidos="${pathVideos}/tmp/video_extraido"
dir=`pwd`

mkdir -p $pathVideosExtraidos

cd $pathVideos

ffmpeg -y \
 -loop 1 -t 3 \
 -i $imagem_abertura \
 -loop 1 -t 3 \
 -i $imagem_propaganda \
 -i $2 -an \
 -i $3 -an \
-filter_complex \
"[3:v]setpts=1.7*PTS[v0]; \
 [0:v]scale=1280x720,setdar=8:5,setsar=1:1[v1]; \
 [1:v]scale=1280x720,setdar=8:5,setsar=1:1[v2];\
 [1:v]scale=1280x720,setdar=8:5,setsar=1:1[v3];\
 [v1][2:v][v2][v0][v3]concat=n=5:v=1,format=yuv420p[out]" -map "[out] -c copy" $pathVideosExtraidos/FutShow-`date +%d-%m-%Y_%H:%M:%S`.mp4
 
 aws s3 cp $pathVideosExtraidos s3://${bucketName} --recursive --profile $awsProfile
