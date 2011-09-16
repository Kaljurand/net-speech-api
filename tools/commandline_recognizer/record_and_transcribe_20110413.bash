# Linux commandline client for the Estonian speech recognition service
# Author: Kaarel Kaljurand
# Version: 2011-04-13
# Dependencies: arecord/aplay, curl (tested with 7.21.0), bash, sleep, echo, cat
# Usage:
# 1. Start up: bash record_and_transcribe.bash
# 2. Talk into the microphone for 4 seconds
# 3. Listen to the playback
# 4. Wait some time to see the transcription
# Three files are stored into the current directory:
# audio, uploader response, transcription.

upload_file="http://bark.phon.ioc.ee/webtrans/upload_file.php"
get_result="http://bark.phon.ioc.ee/webtrans/get_result.php"

# Waiting time
# BUG: use waiting co-efficient instead and use the length of the recording
# to determine the actual waiting time.
waiting_time=20

# Poll 5 times
poll_amount=5

# Sleep 4 seconds between polls
poll_pause=5

timestamp=`date '+%Y%m%d-%H%M%S'`
audio="$timestamp.wav"
response="$audio.curl"
transcription="$audio.txt"

echo "Recording into ${audio}, press Ctrl-C to stop..."

# BUG: vumeter caused pulsating noise in the recording
##arecord --file-type wav --channels 1 --rate 16000 --vumeter=mono

trap "echo Stopping the recording" SIGINT
arecord --format=S16_LE --file-type wav --channels 1 --rate 16000 > $audio
trap - SIGINT

trap "echo Stopping the playback" SIGINT
aplay $audio
trap - SIGINT

echo "Uploading to server..."
curl -i -F email=kaljurand+curl@gmail.com -F MODEL_SAMPLE_RATE=16000 -F DECODING=FAST -F SEND_EMAIL=0 -F "upload_wav=@$audio;type=audio/wav" ${upload_file} > $response

id=`grep "^X-webtrans-id" $response | sed "s/X-webtrans-id: //"`

echo "Received transcription ID: $id"

echo "Sleeping ${waiting_time} seconds"
sleep ${waiting_time}

echo "Fetching transcription..."
curl --retry ${poll_amount} --retry-delay ${poll_pause} -i "${get_result}?id=$id" > $transcription

cat $transcription
