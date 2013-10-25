package ee.ioc.phon.netspeechapi.duplex;

import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
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
	private String contentType = "audio/x-raw, layout=(string)interleaved, rate=(int)16000, format=(string)S16LE, channels=(int)1";
	private MyWsClient wsClient;
	private List<RecognitionEventListener> recognitionEventListeners = new LinkedList<RecognitionEventListener>();
	
	public WsDuplexRecognitionSession(String serverUrl) throws IOException, URISyntaxException {
		this.serverUrl = serverUrl;
	}

	public void connect() throws IOException {
		// FIXME: or connectBlocking?
		String contentTypeParam = URLEncoder.encode("content-type=" + contentType, "UTF-8");
		
		URI serverURI;
		try {
			serverURI = new URI(this.serverUrl + "?" + contentTypeParam);
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
		this.contentType = contentType;
	}
}
