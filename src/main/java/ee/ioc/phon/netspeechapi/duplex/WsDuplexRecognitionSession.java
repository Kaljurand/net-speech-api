package ee.ioc.phon.netspeechapi.duplex;

import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;
import org.json.simple.parser.JSONParser;
import org.java_websocket.client.WebSocketClient;
import org.java_websocket.handshake.ServerHandshake;

public class WsDuplexRecognitionSession implements DuplexRecognitionSession {

	
	
	class MyWsClient extends WebSocketClient {

		private JSONParser parser=new JSONParser();
		
		public MyWsClient(URI serverURI) {
			super(serverURI);
		}

		@Override
		public void onClose(int code, String reason, boolean remote) {
			for (RecognitionEventListener listener : recognitionEventListeners) {
				listener.onClose();
			}
		}

		@Override
		public void onError(Exception arg0) {
			
		}

		@Override
		public void onMessage(String msg) {
			RecognitionEvent event = parseRecognitionEventJson(msg);
			if (event != null) {
				for (RecognitionEventListener listener : recognitionEventListeners) {
					listener.onRecognitionEvent(event);
				}
			}
		}

		@Override
		public void onOpen(ServerHandshake arg0) {
			
		}
		
	}
	
	private String serverUrl;
	
	private MyWsClient wsClient;
	private List<RecognitionEventListener> recognitionEventListeners = new LinkedList<RecognitionEventListener>();
	private Map<String, String> parameters;
	
	public WsDuplexRecognitionSession(String serverUrl) throws IOException, URISyntaxException {		
		this.serverUrl = serverUrl;
		this.parameters = new HashMap<String, String>();
		this.parameters.put("content-type", "audio/x-raw, layout=(string)interleaved, rate=(int)16000, format=(string)S16LE, channels=(int)1");
	}

	public void connect() throws IOException {
		String parameterString = "";
		
		if (parameters != null) {
			for (Map.Entry<String, String> entry : parameters.entrySet()) {
				if (parameterString.isEmpty()) {
					parameterString = "?";
				} else {
					parameterString += "&";
				}
				parameterString +=  URLEncoder.encode(entry.getKey() + "=" + entry.getValue(), "UTF-8");
			}
		}
		
		URI serverURI;
		try {
			serverURI = new URI(this.serverUrl  + parameterString);
			wsClient = new MyWsClient(serverURI);
			
			wsClient.connectBlocking();
		} catch (URISyntaxException e) {
			throw new IOException(e);
		} catch (InterruptedException e) {
			throw new IOException(e);
		}
		
	}
	
	public void addRecognitionEventListener(
			RecognitionEventListener recognitionEventListener) {
		recognitionEventListeners.add(recognitionEventListener);
	}

	public void sendChunk(byte[] bytes, boolean isLast) throws IOException {
		// FIXME: check if connected?
		wsClient.send(bytes);
		if (isLast) {
			wsClient.send("EOS");
		}
	}
	
	public static RecognitionEvent parseRecognitionEventJson(String json) {
		Object obj = JSONValue.parse(json);

		if (obj == null) {
			return null;
		}
		JSONObject jsonObj = (JSONObject) obj;
		long status = (Long)jsonObj.get("status");
		RecognitionEvent.Result result = null;
		if (jsonObj.containsKey("result")) {
			JSONObject jo1 = (JSONObject) jsonObj.get("result");
			
			boolean isFinal = (Boolean)jo1.get("final");
			List<RecognitionEvent.Hypothesis> hyps = new ArrayList<RecognitionEvent.Hypothesis>();
			for (Object o1 : (JSONArray) jo1.get("hypotheses")) {
				JSONObject jo2 = (JSONObject) o1;
				String transcript = (String)jo2.get("transcript");
				double confidence = 1.0;
				if (jo2.containsKey("confidence")) {
					confidence = (Double) jo2.get("confidence");
				}
				hyps.add(new RecognitionEvent.Hypothesis(transcript, (float) confidence));
			}
			result = new RecognitionEvent.Result(isFinal, hyps);
		}
		
		return new RecognitionEvent((int)status, result); 

	}

	public void setContentType(String contentType) {
		this.parameters.put("content-type", contentType);
	}
	
	/**
	 * Set user who is using the service. Sent to the server.
	 * @param userId
	 */
	public void setUserId(String userId) {
		this.parameters.put("user-id", userId);
	}

	/**
	 * Set the content ID that is being dictated. For special purposes.
	 * 
	 * @param contentId
	 */
	public void setContentId(String contentId) {
		this.parameters.put("content-id", contentId);
	}
	
}
