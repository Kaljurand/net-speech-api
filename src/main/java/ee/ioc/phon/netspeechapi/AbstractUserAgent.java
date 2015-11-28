/*
 * This file is part of Net Speech API.
 * Copyright 2011-2012, Institute of Cybernetics at Tallinn University of Technology
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

import org.apache.http.client.methods.HttpUriRequest;

/**
 * <p>Every class that communicates to the speech recognition server
 * should extend this class which specifies the User-Agent identifier
 * of this API (e.g. "NetSpeechApi/0.0.1"),
 * and allows the user to add an additional string that
 * identifies his/her application, so that the final User-Agent
 * would be e.g. "NetSpeechApi/0.0.1 (Diktofon 0.1)".</p>
 * 
 * @author Kaarel Kaljurand
 */
public abstract class AbstractUserAgent implements UserAgent {

	// API identifier in the User-Agent
	public static final String USER_AGENT = "NetSpeechApi/0.2.0";

	private String mUserAgent = USER_AGENT;

	/**
	 * <p>Adds an additional identifier to the User-Agent string.</p>
	 * 
	 * @param userAgentComment Application identifier in the User-Agent
	 */
	public void setUserAgentComment(String userAgentComment) {
		mUserAgent = USER_AGENT + " (" + userAgentComment + ")";
	}

	/**
	 * <p>Sets the User-Agent field in the given request.</p>
	 * 
	 * @param request HTTP request (e.g. GET or POST)
	 */
	protected void setUserAgent(HttpUriRequest request) {
		request.setHeader("User-Agent", mUserAgent);
	}
}
