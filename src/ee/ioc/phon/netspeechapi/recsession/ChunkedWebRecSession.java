/*
 * This file is part of Net Speech API.
 * Copyright 2011, Institute of Cybernetics at Tallinn University of Technology
 *
 * Net Speech API is free software: you can redistribute it and/or modify it under the
 * terms of the GNU Lesser General Public License as published by the Free Software Foundation,
 * either version 3 of the License, or (at your option) any later version.
 *
 * Net Speech API is distributed in the hope that it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
 * PURPOSE. See the GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License along with ACE View.
 * If not, see http://www.gnu.org/licenses/.
 */

package ee.ioc.phon.netspeechapi.recsession;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Properties;

import ee.ioc.phon.netspeechapi.UserAgent;

public class ChunkedWebRecSession implements RecSession, UserAgent {

	public static final String CONF_BASE_URL = "base_url";

	// API identifier in the User-Agent
	public static final String USER_AGENT = "ChunkedWebRecSession/0.0.3";

	private String userAgent = USER_AGENT;

	private Properties configuration = new Properties();

	private HttpURLConnection connection;
	private OutputStream out;

	private ChunkedWebRecSessionResult result;
	private boolean finished = false;

	public ChunkedWebRecSession()  {
		// set default base URL
		configuration.setProperty(CONF_BASE_URL, "http://localhost:8080/");
	}


	public ChunkedWebRecSession(URL wsUrl)  {
		this(wsUrl, null, null);
	}


	public ChunkedWebRecSession(URL wsUrl, URL lmUrl) {
		this(wsUrl, lmUrl, null);
	}


	/**
	 * <p>Recognizer session is constructed on the basis of the recognizer
	 * webservice URL. Optionally one can specify the speech recognition grammar
	 * to guide the recognizer. The grammar must be in either JSGF or PGF format.
	 * In the latter case, one can also specify a language into which the
	 * raw recognition result is translated. Specifying the language without the
	 * grammar does not make sense and in this case the language is ignored.</p>
	 *
	 * @param wsUrl Recognizer webservice URL
	 * @param lmUrl Language model (JSGF or PGF grammar) URL
	 * @param lang  Target language to which to translate the raw recognizer output (in case PGF)
	 */
	public ChunkedWebRecSession(URL wsUrl, URL lmUrl, String lang) {
		if (lmUrl == null) {
			configuration.setProperty(CONF_BASE_URL, wsUrl.toExternalForm());
		} else if (lang == null) {
			configuration.setProperty(CONF_BASE_URL, wsUrl.toExternalForm() + "?lm=" + lmUrl.toExternalForm());
		} else {
			configuration.setProperty(CONF_BASE_URL, wsUrl.toExternalForm() + "?lm=" + lmUrl.toExternalForm() + "&output-lang=" + lang);
		}
	}


	@Override
	public void create() throws IOException, NotAvailableException {
		URL url = new URL(configuration.getProperty(CONF_BASE_URL));
		connection = (HttpURLConnection) url.openConnection();
		connection.setChunkedStreamingMode(1024);
		connection.setRequestMethod("POST");
		connection.setDoOutput(true);
		connection.setDoInput(true);
		connection.setRequestProperty("Content-Type", "audio/x-raw-int; rate=16000;channels=1;signed=true;endianness=1234;depth=16;width=16");
		connection.setRequestProperty("User-Agent", userAgent);
		connection.connect();
		out = connection.getOutputStream();

		// System.out.println("Created connection: " + connection);
	}


	/**
	 * @deprecated
	 */
	@Override
	public String getCurrentResult() throws IOException {
		if (result == null || result.getUtterances().isEmpty()) {
			return "";
		}
		return result.getUtterances().get(0);
	}


	@Override
	public ChunkedWebRecSessionResult getResult() throws IOException {
		return result;
	}


	@Override
	public boolean isFinished() {
		return finished;
	}

	@Override
	public void sendChunk(byte[] bytes, boolean isLast) throws IOException {
		if (bytes.length > 0) {
			out.write(bytes);
			// System.out.println("Wrote " + bytes.length + " bytes");
		}
		if (isLast) {
			try {
				out.close();
				InputStream is = connection.getInputStream();
				result = new ChunkedWebRecSessionResult(new InputStreamReader(is));
			} finally {
				connection.disconnect();
				finished = true;
			}
		}

	}



	public Properties getConfiguration() {
		return configuration;
	}

	public void setConfiguration(Properties configuration) {
		this.configuration = configuration;
	}

	@Override
	public void cancel() {
		try {
			connection.disconnect();
		} catch (Exception e) {
			// silent OK
		} finally {
			finished = true;
		}
	}

	/**
	 * <p>
	 * Adds an additional identifier to the User-Agent string.
	 * </p>
	 * 
	 * @param userAgentComment
	 *            Application identifier in the User-Agent
	 */
	public void setUserAgentComment(String userAgentComment) {
		userAgent = USER_AGENT + " (" + userAgentComment + ")";
	}
}