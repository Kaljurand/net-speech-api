# @deprecated
# Linux commandline client for the realtime Estonian speech recognition service
# Author: Kaarel Kaljurand
# Version: 2011-05-25
#
# Dependencies:
#	arecord/aplay, tested with 1.0.23
#	curl, tested with 7.21.0
#	bash, tested with 4.1.5(1)-release
#	echo
#
# Usage:
# 1. Start up: bash realtime_recognizer.bash
# 2. Talk into the microphone (stop recording by pressing Ctrl-C)
# 3. (Optional for testing: play back the result)
# 4. Post the raw audio data file to the recognition server
#
# One file is created into the current directory:
# raw recording (raw).

recognizer="http://bark.phon.ioc.ee/realtime/recognizer"

timestamp=`date '+%Y%m%d-%H%M%S'`
raw="$timestamp.raw"

echo
echo "Recording into ${raw}, press Ctrl-C to stop..."
echo

trap "echo Stopping the recording" SIGINT
arecord --file-type raw --format=S16_LE --channels 1 --rate 16000 $raw
trap - SIGINT

echo
echo "Just a test: playing, press Ctrl-C to stop..."
echo
trap "echo Stopping the playback" SIGINT
aplay --file-type raw --format=S16_LE --channels 1 --rate 16000 $raw
trap - SIGINT

echo "curl -X POST ${recognizer}"
id=$(curl -X POST ${recognizer} | grep "<id>" | sed "s/^.*>\(.*\)<.*/\1/")

echo "Session ID = $id"

echo "curl -X PUT --data-binary @$raw ${recognizer}/${id}"
curl -X PUT --data-binary @$raw ${recognizer}/${id}

echo "curl -X GET ${recognizer}/${id}"
curl -X GET ${recognizer}/${id}

echo "curl -X PUT ${recognizer}/${id}/end"
curl -X PUT ${recognizer}/${id}/end

echo
echo "Done."
