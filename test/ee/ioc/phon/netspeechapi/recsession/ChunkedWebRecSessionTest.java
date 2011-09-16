package ee.ioc.phon.netspeechapi.recsession;

import static org.junit.Assert.*;

import java.io.File;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;


import org.apache.commons.io.FileUtils;
import org.junit.Test;

import ee.ioc.phon.netspeechapi.Recognizer;
import ee.ioc.phon.netspeechapi.Settings;
import ee.ioc.phon.netspeechapi.recsession.ChunkedWebRecSession;
import ee.ioc.phon.netspeechapi.recsession.NotAvailableException;

public class ChunkedWebRecSessionTest {

	private static final String USER_AGENT_COMMENT = "ChunkedWebRecSessionTest";
	private static final File T2_FILE = new File(Settings.DIR + "test_12345.raw");

	private static final File T3_FILE = new File(Settings.DIR + "test_mine_edasi.raw");
	private static final String T3_RESPONSE = "mine edasi";

	/*
	 * Note: to register a grammar, first do a GET on:
	 * http://bark.phon.ioc.ee/speech-api/v1/fetch-jsgf?lm=http://net-speech-api.googlecode.com/hg/lm/robot.jsgf
	 */
	private static final String T3_LM = "http://net-speech-api.googlecode.com/hg/lm/robot.jsgf";

	private static URL sWsUrl;
	private static URL sT3LmUrl;
	private static byte[] sBytes;

	static {
		try {
			sWsUrl = new URL(Recognizer.DEFAULT_WS_URL);
		} catch (MalformedURLException e) {
			fail("should not throw MalformedURLException");
		}

		try {
			sT3LmUrl = new URL(T3_LM);
		} catch (MalformedURLException e) {
			fail("should not throw MalformedURLException");
		}

		try {
			sBytes = FileUtils.readFileToByteArray(T2_FILE);
		} catch (IOException e) {
			fail("should not throw IOException");
			e.printStackTrace();
		}
	}


	@Test
	public final void testRecognize1() {
		ChunkedWebRecSession recSession = new ChunkedWebRecSession(sWsUrl);
		recSession.setUserAgentComment(USER_AGENT_COMMENT);
		String response = null;
		try {
			recSession.create();
			// blocks if true
			recSession.sendChunk(sBytes, true);
			response = recSession.getCurrentResult();
		} catch (IOException e) {
			fail("should not throw IOException");
			e.printStackTrace();
		} catch (NotAvailableException e) {
			fail("should not throw NotAvailableException");
			e.printStackTrace();
		}
		assertEquals("1 2 3 4 5", response);
	}


	@Test
	public final void testRecognize2() {
		ChunkedWebRecSession recSession = new ChunkedWebRecSession(sWsUrl);
		recSession.setUserAgentComment(USER_AGENT_COMMENT);
		try {
			recSession.create();
		} catch (IOException e) {
			fail("should not throw IOException");
			e.printStackTrace();
		} catch (NotAvailableException e) {
			fail("should not throw NotAvailableException");
			e.printStackTrace();
		}

		int begin = 0;
		int chunkSize = 16000;
		while ((begin + chunkSize) < sBytes.length) {
			byte[] chunk = new byte[chunkSize];
			System.arraycopy(sBytes, begin, chunk, 0, chunkSize);
			try {
				recSession.sendChunk(chunk, false);
			} catch (IOException e) {
				fail("should not throw IOException");
				e.printStackTrace();
			}
			begin += chunkSize;
		}
		chunkSize = sBytes.length - begin;
		byte[] chunk = new byte[chunkSize];
		System.arraycopy(sBytes, begin, chunk, 0, chunkSize);
		try {
			recSession.sendChunk(chunk, true);
		} catch (IOException e) {
			fail("should not throw IOException");
			e.printStackTrace();
		}
		String response = null;
		try {
			response = recSession.getCurrentResult();
		} catch (IOException e) {
			fail("should not throw IOException");
			e.printStackTrace();
		}
		assertEquals("1 2 3 4 5", response);
	}


	@Test
	public final void testRecognize3() {
		ChunkedWebRecSession recSession = new ChunkedWebRecSession(sWsUrl, sT3LmUrl);
		recSession.setUserAgentComment(USER_AGENT_COMMENT);
		String response = null;
		try {
			recSession.create();
			// blocks if true
			recSession.sendChunk(fileToBytes(T3_FILE), true);
			response = recSession.getCurrentResult();
		} catch (IOException e) {
			fail("should not throw IOException");
			e.printStackTrace();
		} catch (NotAvailableException e) {
			fail("should not throw NotAvailableException");
			e.printStackTrace();
		}
		assertEquals(T3_RESPONSE, response);
	}


	private byte[] fileToBytes(File file) {
		try {
			return FileUtils.readFileToByteArray(file);
		} catch (IOException e) {
			fail("should not throw IOException");
			e.printStackTrace();
			return null;
		}
	}
}