Net Speech API
==============

Java API for the following online speech recognition services:

- [Ruby PocketSphinx Server](https://github.com/alumae/ruby-pocketsphinx-server)
- [Kaldi Offline Transcriber](https://github.com/alumae/kaldi-offline-transcriber)
- [Kaldi GStreamer server](https://github.com/alumae/kaldi-gstreamer-server)

For example, this library is used by

- [Kõnele](http://kaljurand.github.io/K6nele/)
- [Diktofon](https://github.com/Kaljurand/Diktofon)

Building
--------

Building the jar-file with and without testing:

    $ mvn package
    $ mvn package -DskipTests

Building the Javadoc/website:

    $ mvn site

Building the Android library:

    $ gradle clean assembleRelease


Setting up an Eclipse project
-----------------------------

The Eclipse (or any other IDE) project files are not included in
this repository. To generate the required Eclipse files, run:

    $ mvn -Declipse.workspace=/home/yourname/workspace/ eclipse:configure-workspace
    $ mvn eclipse:eclipse
