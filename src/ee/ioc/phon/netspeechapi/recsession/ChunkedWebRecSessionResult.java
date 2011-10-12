package ee.ioc.phon.netspeechapi.recsession;

import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;

public class ChunkedWebRecSessionResult implements RecSessionResult {

	private final List<String> mUtterances = new ArrayList<String>();
	private final List<String> mLinearizations = new ArrayList<String>();

	public ChunkedWebRecSessionResult(InputStreamReader reader) {
		Object obj = JSONValue.parse(reader);
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


	@Override
	public List<String> getUtterances() {
		return mUtterances;
	}


	private void add(List<String> list, Object obj) {
		if (obj != null) {
			list.add(obj.toString());
		}
	}
}