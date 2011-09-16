# Linux commandline client for the realtime Estonian speech recognition service
# Author: Kaarel Kaljurand
# Version: 2011-04-14
#
# Dependencies:
#	arecord/aplay, tested with 1.0.23
#	flac, tested with 1.2.1
#	curl, tested with 7.21.0
#	json_xs
#	bash, tested with 4.1.5(1)-release
#	echo
#
# Usage:
# 1. Start up: bash recognize.bash
# 2. Talk into the microphone (stop recording by pressing Ctrl-C)
# 3. (Compress into Flac)
# 4. (Optional for testing: decompress the compression and playback the result)
# 5. (Post the Flac file to the recognition server)
# 6. Look at the returned transcription (pretty-printed JSON)
#
# Two files are created into the current directory:
# raw recording (wav) and compressed recording (flac)

recognize=http://bark.phon.ioc.ee/speech-api/v1/recognize
#recognize="https://www.google.com/speech-api/v1/recognize?xjerr=1&client=chromium&lang=en-US"

timestamp=`date '+%Y%m%d-%H%M%S'`
wav="$timestamp.wav"
flac="$timestamp.flac"

echo
echo "Recording into ${wav}, press Ctrl-C to stop..."
echo

trap "echo Stopping the recording" SIGINT
arecord --format=S16_LE --file-type wav --channels 1 --rate 16000 > $wav
trap - SIGINT

echo
echo "Compressing wav -> flac"
echo
flac -s -o $flac $wav

echo
echo "Just a test: de-compressing $flac and playing, press Ctrl-C to stop..."
echo
trap "echo Stopping the playback" SIGINT
flac -s -d $flac -c | aplay
trap - SIGINT

# Note: you can pipe the result through json_xs to get it pretty-printed.
# Then you also have to hide the header (i.e. remove -i)
echo "Wait a bit, transcribing..."
curl -i -X POST --data-binary @$flac -H "Content-Type: audio/x-flac; rate=16000" $recognize

echo
echo "Done."
