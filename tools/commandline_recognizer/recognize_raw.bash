# Linux commandline client for the realtime Estonian speech recognition service
# Author: Kaarel Kaljurand
# Version: 2011-06-23
#
# Dependencies:
#	arecord/aplay, tested with 1.0.24.2
#	curl, tested with 7.21.3
#	bash, tested with 4.2.8(1)-release
#	echo
#
# Usage:
# 1. Start up: bash recognize_raw.bash
# 2. Talk into the microphone (stop recording by pressing Ctrl-C)
# 4. (Optional for testing: playback the result)
# 5. (Post the audio file to the recognition server)
# 6. Look at the returned transcription (JSON)
#
# One file is created into the current directory:
# raw recording (raw)

recognize=http://bark.phon.ioc.ee/speech-api/v1/recognize
#recognize="https://www.google.com/speech-api/v1/recognize?xjerr=1&client=chromium&lang=en-US"

timestamp=`date '+%Y%m%d-%H%M%S'`
raw="$timestamp.raw"

echo
echo "Recording into ${raw}, press Ctrl-C to stop..."
echo

trap "echo Stopping the recording" SIGINT
arecord --format=S16_LE --file-type raw --channels 1 --rate 16000 > $raw
trap - SIGINT

echo
echo "Just a test: playing, press Ctrl-C to stop..."
echo
trap "echo Stopping the playback" SIGINT
cat $raw | aplay --format=S16_LE --file-type raw --channels 1 --rate 16000
trap - SIGINT

# Note: you can pipe the result through json_xs to get it pretty-printed.
# Then you also have to hide the header (i.e. remove -i)
echo "Wait a bit, transcribing..."
curl -i -X POST --data-binary @$raw -H "Content-Type: audio/x-raw-int; rate=16000" $recognize

echo
echo "Done."
