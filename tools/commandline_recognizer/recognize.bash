# Linux commandline client for the realtime Estonian speech recognition service
# Author: Kaarel Kaljurand
# Version: 2012-12-11
#
# Dependencies:
#	arecord/aplay, tested with 1.0.25
#	flac, tested with 1.2.1
#	curl, tested with 7.22.0
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

test="test"
lang="en-US"
nbest="10"

pgf="http://kaljurand.github.com/Grammars/grammars/pgf/Action.pgf"
recognize="http://bark.phon.ioc.ee/${test}/speech-api/v1/recognize?lm=${pgf}&output-lang=Eng,App,Est&lang=${lang}&nbest=${nbest}"

# Google works with both HTTP and HTTPS
#recognize="https://www.google.com/speech-api/v1/recognize?xjerr=1&client=chromium&lang=en-US"
#recognize="http://www.google.com/speech-api/v1/recognize?xjerr=1&client=chromium&lang=en-US"

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

# To pretty-print JSON, pipe the result through json_xs, json_pp or python -mjson.tool.
# To show various meta data, add one of:
# -i (only headers)
# -v (more verbose)
# --trace-ascii - (very verbose)
echo "Wait a bit, transcribing..."
curl -v -X POST --data-binary @$flac -H "Content-Type: audio/x-flac; rate=16000" $recognize
#curl -X POST --data-binary @$flac -H "Content-Type: audio/x-flac; rate=16000" $recognize | json_pp

echo
echo "Done."
