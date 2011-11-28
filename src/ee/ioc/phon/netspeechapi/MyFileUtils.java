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

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

public class MyFileUtils {

	private static final Map<String, String> sMimeToExt;

	static {
		Map<String, String> aMap = new HashMap<String, String>();
		aMap.put(Constants.MIME_WAV, Constants.EXT_WAV);
		aMap.put("audio/ogg", ".ogg");
		aMap.put("audio/mpeg", ".mp3");
		aMap.put("audio/mp4", ".mp4");
		aMap.put("audio/AMR", ".amr");
		aMap.put("audio/amr", ".amr");
		aMap.put("audio/3gpp", ".3gpp");
		aMap.put("audio/aac", ".aac");
		aMap.put("audio/flac", ".flac");
		aMap.put("audio/x-flac", ".flac");
		aMap.put("audio/aiff", ".aiff");
		aMap.put("audio/x-matroska", ".mka");
		aMap.put("video/x-matroska", ".mkv");
		sMimeToExt = Collections.unmodifiableMap(aMap);
	}


	public static String createRandomFilename(String mimeType) {
		return UUID.randomUUID().toString() + getExtensionFromMime(mimeType);
	}


	public static String getExtensionFromMime(String mimeType) {
		String ext = sMimeToExt.get(mimeType);
		if (ext == null) {
			return Constants.EXT_WAV;
		}
		return ext;
	}
}
