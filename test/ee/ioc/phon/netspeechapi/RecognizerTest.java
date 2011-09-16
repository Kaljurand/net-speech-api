package ee.ioc.phon.netspeechapi;

import static org.junit.Assert.*;

import java.io.File;
import java.io.IOException;


import org.apache.commons.io.FileUtils;
import org.apache.http.client.ClientProtocolException;
import org.junit.Test;

import ee.ioc.phon.netspeechapi.Constants;
import ee.ioc.phon.netspeechapi.Recognizer;

public class RecognizerTest {

	private static final int T_RATE = 16000;
	private static final File T1_FILE = new File(Settings.DIR + "test_recognize1.flac");
	private static final String T1_MIME = Constants.MIME_FLAC;
	private static final File T2_FILE = new File(Settings.DIR + "test_12345.raw");
	private static final String T2_MIME = Constants.MIME_RAW;
	private static final String USER_AGENT_COMMENT = "RecognizerTest";

	@Test
	public final void testRecognize1() {
		Recognizer r = new Recognizer();
		r.setUserAgentComment(USER_AGENT_COMMENT);

		String response = "";

		try {
			response = r.recognize(T1_FILE, T1_MIME, T_RATE);
		} catch (ClientProtocolException e) {
			fail("should not throw ClientProtocolException");
			e.printStackTrace();
		} catch (IOException e) {
			fail("should not throw IOException");
			e.printStackTrace();
		}

		System.out.print("JSON: " + response);
		assertTrue(response.startsWith("{"));
	}


	@Test
	public final void testRecognize2() {
		Recognizer r = new Recognizer();
		r.setUserAgentComment(USER_AGENT_COMMENT);

		String response = "";

		try {
			response = r.recognize(T2_FILE, T2_MIME, T_RATE);
		} catch (ClientProtocolException e) {
			fail("should not throw ClientProtocolException");
			e.printStackTrace();
		} catch (IOException e) {
			fail("should not throw IOException");
			e.printStackTrace();
		}

		System.out.print("JSON: " + response);
		assertTrue(response.startsWith("{"));
	}


	@Test
	public final void testRecognize3() {
		byte[] bytes = null;
		try {
			bytes = FileUtils.readFileToByteArray(T2_FILE);
		} catch (IOException e) {
			fail("should not throw IOException");
			e.printStackTrace();
		}
		Recognizer r = new Recognizer();
		r.setUserAgentComment(USER_AGENT_COMMENT);

		String response = "";

		try {
			response = r.recognize(bytes, T2_MIME, T_RATE);
		} catch (ClientProtocolException e) {
			fail("should not throw ClientProtocolException");
			e.printStackTrace();
		} catch (IOException e) {
			fail("should not throw IOException");
			e.printStackTrace();
		}

		System.out.print("JSON: " + response);
		assertTrue(response.startsWith("{"));
	}
}