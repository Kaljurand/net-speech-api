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

package ee.ioc.phon.netspeechapi;

import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpUriRequest;

import java.io.IOException;

/**
 * <p>Fetches the transcription from the server. The requested transcription is
 * identified by the token (String).</p>
 * 
 * @author Kaarel Kaljurand
 *
 */
public class TranscriptionDownloader extends AbstractUserAgent {

	public static final String DEFAULT_WS_URL = "http://bark.phon.ioc.ee/webtrans/get_result.php?type=trs&id=";

	private final String mWsUrl;

	/**
	 * <p>Constructs the transcription downloader.</p>
	 * 
	 * @param wsUrl partial URL to which the token will be concatenated to form the URL to be queried
	 */
	public TranscriptionDownloader(String wsUrl) {
		mWsUrl = wsUrl;
	}


	/**
	 * <p>Constructs the transcription downloader using the default server URL.</p>
	 */
	public TranscriptionDownloader() {
		this(DEFAULT_WS_URL);
	}


	/**
	 * <p>Returns the content of the transcription, or null if the transcription is not
	 * (yet) present, or throws an exception if something is wrong with the connection.</p>
	 * 
	 * @param token token that identifies the transcription on the server
	 * @return Transcription as String
	 * @throws IOException
	 */
	public String download(String token) throws IOException {
		HttpUriRequest request = new HttpGet(mWsUrl + token);
		setUserAgent(request);
		return Utils.getResponseEntityAsString(request);
	}
}