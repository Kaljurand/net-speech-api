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

import java.io.File;
import java.io.IOException;

import org.apache.http.HttpEntity;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.ByteArrayEntity;
import org.apache.http.entity.FileEntity;

/**
 * <p>POSTs a file to the recognizer service, similarly to:</p>
 * 
 * <pre>
 * curl -X POST --data-binary @test.flac -H "Content-Type: audio/x-flac; rate=16000" $mWsUrl
 * </pre>
 * 
 * @author Kaarel Kaljurand
 */
public class Recognizer extends AbstractUserAgent {

	public static final String DEFAULT_WS_URL = "http://bark.phon.ioc.ee/speech-api/v1/recognize";

	private final String mWsUrl;

	/**
	 * <p>Constructs the Recognizer using the given webservice URL.</p>
	 * 
	 * @param wsUrl Speech recognizer webservice URL.
	 */
	public Recognizer(String wsUrl) {
		mWsUrl = wsUrl;
	}


	/**
	 * <p>Constructs the Recognizer using the default webservice URL.</p>
	 */
	public Recognizer() {
		this(DEFAULT_WS_URL);
	}


	/**
	 * <p>Posts the given audio file with the given MIME type and the given
	 * sample rate to the recognizer webservice.
	 * Returns the webservice response (JSON) as string.</p>
	 * 
	 * @param file audio file
	 * @param mimeType MIME type e.g. "audio/wav"
	 * @param rate sample rate, e.g. 16000 for 16kHz
	 * @return JSON string
	 * @throws ClientProtocolException
	 * @throws IOException
	 */
	public String recognize(File file, String mimeType, int rate) throws ClientProtocolException, IOException {
		return postFile(file, mimeType, rate);
	}


	/**
	 * <p>Posts the given byte array with the given MIME type and the given
	 * sample rate to the recognizer webservice.
	 * Returns the webservice response (JSON) as string.</p>
	 * 
	 * @param bytes audio content as byte array
	 * @param mimeType MIME type e.g. "audio/wav"
	 * @param rate sample rate, e.g. 16000 for 16kHz
	 * @return JSON string
	 * @throws ClientProtocolException
	 * @throws IOException
	 */
	public String recognize(byte[] bytes, String mimeType, int rate) throws ClientProtocolException, IOException {
		return postByteArray(bytes, mimeType, rate);
	}


	private String postFile(File file, String mime, int rate) throws ClientProtocolException, IOException {
		HttpPost post = new HttpPost(mWsUrl);
		setUserAgent(post);

		HttpEntity entity = new FileEntity(file, mime + "; rate=" + rate);
		post.setEntity(entity);

		return Utils.getResponseEntityAsString(post);
	}


	private String postByteArray(byte[] bytes, String mime, int rate) throws ClientProtocolException, IOException {
		HttpPost post = new HttpPost(mWsUrl);
		setUserAgent(post);

		ByteArrayEntity entity = new ByteArrayEntity(bytes);
		entity.setContentType(mime + "; rate=" + rate);
		post.setEntity(entity);

		return Utils.getResponseEntityAsString(post);
	}
}