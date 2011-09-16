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
import java.io.UnsupportedEncodingException;
import java.nio.charset.Charset;

import org.apache.http.Header;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.HttpVersion;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.mime.HttpMultipartMode;
import org.apache.http.entity.mime.MultipartEntity;
import org.apache.http.entity.mime.content.FileBody;
import org.apache.http.entity.mime.content.StringBody;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.params.CoreProtocolPNames;
import org.apache.http.protocol.HTTP;
import org.apache.http.util.EntityUtils;

/**
 * <p>Uploads an audio file to the speech recognition server,
 * and returns the token that can be later used to request
 * the transcription of the audio file.</p>
 * 
 * TODO: do we need to throw ClientProtocolException
 * TODO: support input as ByteArray in addition to File
 * 
 * @author Kaarel Kaljurand
 */
public class AudioUploader extends AbstractUserAgent {

	public static final String DEFAULT_WS_URL = "http://bark.phon.ioc.ee/webtrans/upload_file.php";
	public static final String RESPONSE_HEADER_WEBTRANS_ID = "X-webtrans-id";

	private final String mWsUrl;
	private final String mDecodingSpeed = "FAST"; // TODO: make settable
	private final boolean mIsSendEmail;
	private final String mEmail;


	/**
	 * <p>Create a file uploader that identifies itself to the server using
	 * the given email address.</p>
	 * 
	 * @param wsUrl URL of the webservice
	 * @param email Email address
	 * @param isSendEmail If <code>true</code> then sends the transcription via email
	 */
	public AudioUploader(String wsUrl, String email, boolean isSendEmail) {
		mWsUrl = wsUrl;
		mEmail = email;
		mIsSendEmail = isSendEmail;
	}


	/**
	 * @see #AudioUploader(String, String, boolean)
	 */
	public AudioUploader(String email, boolean isSendEmail) {
		this(DEFAULT_WS_URL, email, isSendEmail);
	}


	/**
	 * @see #AudioUploader(String, String, boolean)
	 */
	public AudioUploader(String email) {
		this(DEFAULT_WS_URL, email, false);
	}


	/**
	 * <p>Uploads the given file with a given MIME and given sample rate
	 * to the transcription server. Returns the identifier (token) that the
	 * server assigns to the transcription. This token can be later used to
	 * request the actual transcription.</p>
	 * 
	 * <p>TODO: test: If isSendEmail is set then sends the transcription by email instead.</p>
	 * 
	 * @param file audio file
	 * @param mimeType MIME-type of the file
	 * @param sampleRate sample rate of the file
	 * @return token that identifies the transcription on the server
	 * @throws ClientProtocolException
	 * @throws IOException
	 */
	public String upload(File file, String mimeType, int sampleRate) throws ClientProtocolException, IOException {
		MultipartEntity entity = createMultipartEntity(file, mimeType, sampleRate);
		String str = postMultipartEntity(entity);
		return str;
	}


	public String uploadFileUnderRandomName(File file, String mimeType, int sampleRate) throws ClientProtocolException, IOException {
		String filename = MyFileUtils.createRandomFilename(mimeType);
		FileBody fileBody = new FileBody(file, filename, mimeType, null);
		MultipartEntity entity = createMultipartEntity(fileBody, mimeType, sampleRate);
		return postMultipartEntity(entity);
	}


	public MultipartEntity createMultipartEntity(File file, String mimeType, int sampleRate) {
		return createMultipartEntity(new FileBody(file, mimeType), mimeType, sampleRate);
	}


	public MultipartEntity createMultipartEntity(FileBody fileBody, String mimeType, int sampleRate) {
		// see: http://stackoverflow.com/questions/3014633
		//MultipartEntity entity = new MultipartEntity(HttpMultipartMode.BROWSER_COMPATIBLE);
		MultipartEntity entity = new MultipartEntity(HttpMultipartMode.STRICT);

		try {
			entity.addPart("email", new StringBody(mEmail, "text/plain", Charset.forName("UTF-8")));
			entity.addPart("MODEL_SAMPLE_RATE", new StringBody(String.valueOf(sampleRate), "text/plain", Charset.forName("UTF-8")));
			entity.addPart("DECODING", new StringBody(mDecodingSpeed, "text/plain", Charset.forName("UTF-8")));
			String sendEmailAsString = "0";
			if (mIsSendEmail) {
				sendEmailAsString = "1";
			}
			entity.addPart("SEND_EMAIL", new StringBody(sendEmailAsString, "text/plain", Charset.forName("UTF-8")));
			entity.addPart("upload_wav", fileBody);
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}

		return entity;
	}


	private String postMultipartEntity(MultipartEntity entity) throws ClientProtocolException, IOException {
		HttpClient client = new DefaultHttpClient();
		client.getParams().setParameter(CoreProtocolPNames.PROTOCOL_VERSION, HttpVersion.HTTP_1_1);
		HttpPost post = new HttpPost(mWsUrl);
		setUserAgent(post);
		post.setEntity(entity);
		String responseAsString = "";

		try {
			HttpResponse response = client.execute(post);
			Header header = response.getFirstHeader(RESPONSE_HEADER_WEBTRANS_ID);
			if (header == null) {
				HttpEntity responseEntity = response.getEntity();
				responseAsString = EntityUtils.toString(responseEntity, HTTP.UTF_8);
			}
			else {
				// return the token
				responseAsString = header.getValue();
			}
		} finally {
			client.getConnectionManager().shutdown();
		}
		return responseAsString;
	}
}
