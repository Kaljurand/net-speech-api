GF grammars in speech applications
==================================

Introduction
------------

This document describes the current thinking of how to use GF grammars in speech-enabled applications.

The main idea is that every grammar comes with two concrete syntaxes. One corresponds
to the spoken input and the other to the desired output, either (1) the language that the user wants
to eventually see/read or (2) the language (machine code) that an application can
directly process.

In case of (1) the "raw" recognizer output will undergo some normalization

  * converting numbers to digits ("two" -> "2"),
  * converting spoken language to written language ("kakskend obust" -> "kakskümmend hobust")

The user will receive such normalized output and will do something with it (e.g. post it
to Twitter), sometimes relaunching the recognizer service because the result was incorrect.

In case of (2) the "raw" output will be converted into some machine code which the user will
not directly see, but which will be executed by his/her application. To handle the case that
the recognition result is wrong, the application must
provide a way to ask the user for a confirmation or allow for an UNDO.

The following gives the technical details of grammar creation and usage by the server.
The following examples use a grammar called "Go".

TODO: describe also error handling


Compile time
------------

The grammar author creates

  * one abstract syntax
  * at least one concrete syntax that corresponds to the spoken input (possibly more that one, because in general the input can be in different languages or dialects)
  * zero or more concrete syntaxes that correspond to the desired service output (possibly zero, in case the user wants to have the "raw" recognizer output returned)

For example:

  * Go.gf: abstract syntax
  * GoEst.gf: concrete Estonian syntax (spoken input)
  * GoApp.gf: concrete syntax, machine code for machine App (desired output)

The grammar author compiles these files into a single PGF-file (Go.pgf)

    gf -make --optimize-pgf GoEst.gf GoApp.gf

publishes it on some URL, e.g.

    git commit Go.pgf; git push ...
    cp Go.pgf ~/Dropbox/Public/...

notifies the server that the grammar on this URL has been updated

    curl http://.../fetch-grammar?lm=http://.../Go.pgf

and studies the server output in order to be notified of possible problems.


The speech recognition server downloads the grammar file

    curl http://.../Go.pgf > Go.pgf

and extracts from it the spoken input syntax(es) in the JSGF-format

    gf -make --output-format=jsgf Go.pgf

(TODO: the above commandline converts all the concrete syntaxes into JSGF, how
to specify that only some have to be converted.)

The resulting JSGF-files need possibly some post-processing: conversion into Latin1-encoding
and removal of superfluous public-keywords (see the script Go/make_jsgf.sh).


Run time
--------

The user sends a query to the server giving as input:

  * the audio data
  * the URL of the PGF-grammar
  * the identifier of the language used in the audio (e.g. "Est")
  * zero or more identifiers of the desired output language (e.g. "App")

The server recognizes the audio using GoEst.jsgf, resulting in a string.
This string is returned as is to the user if he/she has specified no "desired" output syntaxes.
Otherwise the string is parsed using the same syntax as used for the speech-to-text and
then linearized into all the desired syntaxes.

For example

    echo "parse -lang=GoEst \"${recognizer_output}\"  | linearize -lang=GoApp" | gf --run Go.pgf

The (simple plain text) linearization is the returned to the client.
In case more outputs are desired then some container format must be used.

Note also, that parsing can result in more than one parse tree.
This is the case when the input is ambiguous, e.g. "2 - 3 - 4" with respect
to a simple calculator grammar:

    minus : Exp -> Exp -> Exp;
    number : Number -> Exp;

in case the concrete syntax (which describes the "-" sign) does not specify the associativity.
As a result of multiple parse trees also multiple linearizations are produced
which are not necessarily different. The server would then need to post-process the
linearizations to preserve only the first, or to preserve only the different ones and
return them in a container format.
Another example of ambiguity is the phrase "5 minutes in seconds" where `minutes' and `seconds'
can either refer to time or angles. This ambiguity might not reveal itself in natural
language concrete syntaxes, but would in a mathematical syntax (`sec' vs `"').
Also, the ambiguity might not reveal itself in the ``final answer'' (1 min in sec = 60).


Grammars
--------

A little comparison of the grammars included in this directory.

### Unitconv

Linguistically and structurally most complicated.

  * different morphological forms
  * variants
  * type agreement
  * ...

### Expr

Computationally most compilcated (contains recursion).

### Address

Very large in terms of terminals, otherwise very simple.
