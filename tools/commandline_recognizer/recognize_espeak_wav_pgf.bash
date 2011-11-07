# Linux commandline client for the realtime Estonian speech recognition service
#
# This script demonstrates PGF-driven recognition of synthesized Finnish speech ;)
#
# Author: Kaarel Kaljurand
# Version: 2011-11-07
#
# Dependencies:
#   espeak, tested with 1.44.04
#	aplay, tested with 1.0.24.2
#	curl, tested with 7.21.3
#	bash, tested with 4.2.8(1)-release
#	echo
#
# Usage:
# 1. Start up: bash recognize_espeak_wav_pgf.bash
# 2. (Optional for testing: playback the result)
# 3. (Post the audio file to the recognition server)
# 4. Look at the returned transcription (JSON)
#
recognize="http://bark.phon.ioc.ee/speech-api/v1/recognize?lm=http://kaljurand.github.com/Grammars/grammars/pgf/Calc.pgf&output-lang=App"

timestamp=`date '+%Y%m%d-%H%M%S'`
audio="$timestamp.wav"

espeak -v finnish "Pii" -w $audio

echo
echo "Just a test: playing, press Ctrl-C to stop..."
echo
trap "echo Stopping the playback" SIGINT
cat $audio | aplay
trap - SIGINT

echo "Wait a bit, transcribing..."
curl -i -X POST --data-binary @$audio -H "Content-Type: audio/x-wav" $recognize

echo
echo "Done."
