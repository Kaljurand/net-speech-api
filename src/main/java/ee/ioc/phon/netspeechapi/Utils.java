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

import java.io.IOException;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpUriRequest;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.protocol.HTTP;
import org.apache.http.util.EntityUtils;

/**
 * <p>Various static helper methods.</p>
 * 
 * @author Kaarel Kaljurand
 *
 */
public class Utils {

	private Utils() {}  // no instances allowed

	/**
	 * @see #getResponseEntityAsString(HttpClient client, HttpUriRequest request)
	 */
	public static String getResponseEntityAsString(HttpUriRequest request) throws IOException {
		return getResponseEntityAsString(new DefaultHttpClient(), request);
	}

	/**
	 * <p>Executes the given HTTP request using the given HTTP client,
	 * and returns the received entity as string.
	 * Returns <code>null</code> if the query was performed (i.e. the server
	 * was reachable) but resulted in a failure,
	 * e.g. 404 error.</p>
	 * 
	 * @param client HTTP client
	 * @param request HTTP request (e.g. GET or POST)
	 * @return response as String
	 * @throws IOException
	 */
	public static String getResponseEntityAsString(HttpClient client, HttpUriRequest request) throws IOException {
		try {
			HttpResponse response = client.execute(request);
			HttpEntity entity = response.getEntity();

			if (entity == null) {
				return null;
			}
			int statusCode = response.getStatusLine().getStatusCode();
			if (statusCode != HttpStatus.SC_OK) {
				return null;
			}
			if (entity.getContentEncoding() == null) {
				return EntityUtils.toString(entity, HTTP.UTF_8);
			}
			return EntityUtils.toString(entity);
		} finally {
			client.getConnectionManager().shutdown();
		}
	}


	/**
	 * <p>Returns <code>true</code> if the given string qualifies as
	 * a legal recognizer server response token.
	 * We currently check that its length is not bigger than a certain (small) value.</p>
	 */
	public static boolean isLegalToken(String token) {
		return (token != null && token.length() < Constants.MAX_TOKEN_LENGTH);
	}
}