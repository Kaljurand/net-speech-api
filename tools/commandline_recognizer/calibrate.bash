# Linux commandline client for the realtime Estonian speech recognition service
# Author: Kaarel Kaljurand
# Version: 2012-01-21
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
# 1. Start up: bash calibrate.bash
# 2. Look at the displayed word/phrase
# 3. Say it into the microphone and press Ctrl-C
# 4. (Compress into Flac)
# 5. (Optional for testing: decompress the compression and playback the result)
# 5. (Post the Flac file to the recognition server)
# 6. Look at the returned transcription (pretty-printed JSON)
#
# Two files are created into the current directory:
# raw recording (wav) and compressed recording (flac)

recognize="http://bark.phon.ioc.ee/speech-api/v1/recognize?nbest=1&phrase="

agent="Calibrate/0.0.1"
#agent="RecognizerIntentActivity/0.8.10"

timestamp=`date '+%Y%m%d-%H%M%S'`
wav="$timestamp.wav"
flac="$timestamp.flac"

phrase="allmaaraudteejaam"

echo
echo
echo "Say \"${phrase}\" and press Ctrl-C..."
echo
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
curl --verbose -X POST --user-agent "${agent}; 1-2-3-4-5; calibrate" --data-binary @$flac -H "Content-Type: audio/x-flac; rate=16000" ${recognize}"${phrase}"

echo
echo "Done."
