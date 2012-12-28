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

package ee.ioc.phon.netspeechapi.recsession;

import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;

/**
 *
 * @author Kaarel Kaljurand
 *
 */
public class ChunkedWebRecSessionResult implements RecSessionResult {

	private final List<String> mUtterances = new ArrayList<String>();
	private final List<String> mLinearizations = new ArrayList<String>();

	public ChunkedWebRecSessionResult(InputStreamReader reader) throws IOException {
		Object obj = JSONValue.parse(reader);

		if (obj == null) {
			throw new IOException("Server response is not well-formed");
		}

		JSONObject jsonObj = (JSONObject) obj;
		for (Object o1 : (JSONArray) jsonObj.get("hypotheses")) {
			JSONObject jo1 = (JSONObject) o1;
			add(mUtterances, jo1.get("utterance"));
			Object lins = jo1.get("linearizations");
			if (lins != null) {
				for (Object o2 : (JSONArray) lins) {
					JSONObject jo2 = (JSONObject) o2;
					add(mLinearizations, jo2.get("output"));
				}
			}
		}
	}


	public List<String> getLinearizations() {
		if (mLinearizations.isEmpty()) {
			return mUtterances;
		}
		return mLinearizations;
	}


	public List<String> getUtterances() {
		return mUtterances;
	}


	private void add(List<String> list, Object obj) {
		if (obj != null) {
			String str = obj.toString();
			if (str.length() > 0) {
				list.add(str);
			}
		}
	}
}
