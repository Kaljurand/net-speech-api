GF grammars in speech recognition
=================================

Grammar authoring by the user
-----------------------------

The grammar author creates one abstract synatax (e.g. Go.gf) and
two concrete syntax files:

  * GoEst.gf: Estonian syntax (used by the recognizer)
  * GoApp.gf: normalization syntax (used as the final output of the recognizer service)

The grammar author compiles these files into a single PGF-file (Go.pgf)

    gf -make --optimize-pgf GoEst.gf GoApp.gf

... publishes it on some URL

    git push ...

... notifies the server that the grammar on this URL as been updated

    curl http://.../fetch-grammar?lm=http://.../Go.pgf

... and studies the output in order to be notified of possible problems.


Server (compile time)
---------------------

The speech recognition server downloads the grammar file

    curl http://.../Go.pgf > Go.pgf

and extracts from it the concrete syntaxes (GoEst and GoApp) in the JSGF-format

    gf -make --output-format=jsgf Go.pgf

The resulting GoEst.jsgf needs possibly some post-processing: conversion into Latin1-encoding
and removal of superfluous public-keywords (see the script Go/make_jsgf.sh).


Server (runtime)
----------------

Audio comes in, gets recognized using GoEst.jsgf, and saved into a string.
This string is normalized using GF with Go.pgf, i.e. parsed as GoEst and linearized as GoApp.

    echo "parse -lang=GoEst \"${recognizer_output}\"  | l -lang=GoApp" | gf --run Go.pgf

This linearization is returned to the client.
