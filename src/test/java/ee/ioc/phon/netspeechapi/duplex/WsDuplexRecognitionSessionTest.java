package ee.ioc.phon.netspeechapi.duplex;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNull;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedList;
import java.util.List;

import org.junit.Test;

import ee.ioc.phon.netspeechapi.Settings;

public class WsDuplexRecognitionSessionTest {

	public static final String DEFAULT_WS_URL = "ws://bark.phon.ioc.ee:82/dev/ws-speech/speech";
	private static final File T1_FILE = new File(Settings.DIR + "test_lause2.raw");
	private static final File T2_FILE = new File(Settings.DIR + "test_2lauset.ogg");
	
	static class RecognitionEventAccumulator implements RecognitionEventListener {

		private List<RecognitionEvent> events = new ArrayList<RecognitionEvent>();
		private boolean closed = false;
		
		public void onClose() {
			closed = true;
			this.notifyAll();
		}

		public void onRecognitionEvent(RecognitionEvent event) {
			events.add(event);
			System.err.println("Got event:" + event);
		}

		public List<RecognitionEvent> getEvents() {
			return events;
		}

		public boolean isClosed() {
			return closed;
		}
	}
	
	@Test
	public void testParseRecognitionEventJson() {
		String simpleJson = "{\"status\": 0, \"result\": {\"hypotheses\": [{\"transcript\": \"see on teine lause\"}], \"final\": true}}";
		RecognitionEvent event = WsDuplexRecognitionSession.parseRecognitionEventJson(simpleJson);
		RecognitionEvent expected = new RecognitionEvent(0, 
				new RecognitionEvent.Result(true, 
						Arrays.asList(new RecognitionEvent.Hypothesis[] {
							new RecognitionEvent.Hypothesis("see on teine lause", 1)	
						})));
		assertEquals(expected, event);
		
		String onlyStatusJson = "{\"status\": 2}";
		event = WsDuplexRecognitionSession.parseRecognitionEventJson(onlyStatusJson);
		assertEquals(2, event.getStatus());
		assertNull(event.getResult());
	}
	
	@Test
	public void testRecognition() throws MalformedURLException, IOException, URISyntaxException, InterruptedException {
		WsDuplexRecognitionSession session = new WsDuplexRecognitionSession(DEFAULT_WS_URL);
		RecognitionEventAccumulator eventAccumulator = new RecognitionEventAccumulator();
		session.addRecognitionEventListener(eventAccumulator);
		session.connect();
		sendFile(session, T1_FILE, 16000*2);
		while (!eventAccumulator.isClosed()) {
			synchronized (eventAccumulator) {
				eventAccumulator.wait(1000);
			}
		}
		RecognitionEvent lastEvent = eventAccumulator.getEvents().get(eventAccumulator.getEvents().size() - 1);
		assertEquals(0, lastEvent.getStatus());
		assertEquals(true, lastEvent.getResult().isFinal());
		assertEquals("see on teine lause", lastEvent.getResult().getHypotheses().get(0).getTranscript());
	}

	
	@Test
	public void testRecognition2() throws MalformedURLException, IOException, URISyntaxException, InterruptedException {
		WsDuplexRecognitionSession session = new WsDuplexRecognitionSession(DEFAULT_WS_URL);
		session.setContentType("audio/ogg");
		RecognitionEventAccumulator eventAccumulator = new RecognitionEventAccumulator();
		session.addRecognitionEventListener(eventAccumulator);
		session.connect();
		sendFile(session, T2_FILE, (int)(85.9*1024/8));
		while (!eventAccumulator.isClosed()) {
			synchronized (eventAccumulator) {
				eventAccumulator.wait(1000);
			}
		}
		LinkedList<String> finalTranscripts = new LinkedList<String>();
		finalTranscripts.add("see on esimene lause");
		finalTranscripts.add("see on teine lause");
		for (RecognitionEvent event : eventAccumulator.getEvents()) {
			if (event.getResult().isFinal()) {
				assertEquals(finalTranscripts.removeFirst(), event.getResult().getHypotheses().get(0).getTranscript());
			}
		}
	}

	
	private void sendFile(DuplexRecognitionSession session, File file, int bytesPerSecond) throws IOException, InterruptedException {
		InputStream in = new FileInputStream(file);
		byte buf[] = new byte[bytesPerSecond];
		
		while (true) {
			long millisWithinSecond = System.currentTimeMillis() % 1000;
			int size = in.read(buf);
			if (size < 0) {
				break;
			}
			if (size == bytesPerSecond) {
				session.sendChunk(buf, false);
			} else {
				byte buf2[] = Arrays.copyOf(buf, size);
				session.sendChunk(buf2, true);
				break;
			}
			Thread.sleep(1000 - millisWithinSecond);
		}
	}
}
