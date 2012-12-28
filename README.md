Net Speech API
==============

Java API for the online speech recognition services provided by phon.ioc.ee.

This library is used e.g. by the Android apps Kõnele and Diktofon.

See more at: <http://code.google.com/p/net-speech-api/>

Building
--------

Building the jar-file with and without testing:

	$ mvn package
	$ mvn package -DskipTests

Building the Javadoc/website:

	$ mvn site


Setting up an Eclipse project
-----------------------------

The Eclipse (or any other IDE) project files are not included in
this repository. To generate the required Eclipse files, run:

	$ mvn -Declipse.workspace=/home/yourname/workspace/ eclipse:configure-workspace
	$ mvn eclipse:eclipse
