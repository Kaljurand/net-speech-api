package ee.ioc.phon.netspeechapi.recsession;

import static org.junit.Assert.*;

import java.io.File;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;


import org.apache.commons.io.FileUtils;
import org.junit.Test;

import ee.ioc.phon.netspeechapi.Settings;
import ee.ioc.phon.netspeechapi.recsession.ChunkedWebRecSession;
import ee.ioc.phon.netspeechapi.recsession.NotAvailableException;

public class ChunkedWebRecSessionTest {

	public static final String DEFAULT_WS_URL = "http://bark.phon.ioc.ee/test/speech-api/v1/recognize";

	private static final String MSG_NOT_AVAILABLE_EXCEPTION = "should not throw NotAvailableException";
	private static final String MSG_IO_EXCEPTION = "should not throw IOException";
	private static final String MSG_MALFORMED_URL_EXCEPTION = "should not throw MalformedURLException";

	private static final String USER_AGENT_COMMENT = "ChunkedWebRecSessionTest";
	private static final File T2_FILE = new File(Settings.DIR + "test_12345.raw");

	private static final File T3_FILE = new File(Settings.DIR + "test_mine_edasi.flac");
	private static final String T3_CONTENT_TYPE = "audio/x-flac;rate=16000";
	private static final String T3_LM = "http://kaljurand.github.com/Grammars/grammars/pgf/Go.pgf";
	private static final List<String> T3_RESPONSE = new ArrayList<String>();

	private static final File T4_FILE = new File(Settings.DIR + "test_kaks_minutit_sekundites.raw");
	private static final String T4_LANG = "et";
	private static final String T4_LM = "http://kaljurand.github.com/Grammars/grammars/pgf/Calc.pgf";
	private static final String T4_OUTPUT_LANG = "App";
	private static final String T4_DEVICE_ID = "设备ID";
	private static final String T4_PHRASE = "সেকেন্ড থেকে দুই মিনিট";
	private static final List<String> T4_RESPONSE = new ArrayList<String>();

	private static URL sWsUrl;
	private static URL sT3LmUrl;
	private static URL sT4LmUrl;
	private static byte[] sBytes;

	static {
		try {
			sWsUrl = new URL(DEFAULT_WS_URL);
		} catch (MalformedURLException e) {
			fail(MSG_MALFORMED_URL_EXCEPTION);
		}

		try {
			sT3LmUrl = new URL(T3_LM);
		} catch (MalformedURLException e) {
			fail(MSG_MALFORMED_URL_EXCEPTION);
		}

		try {
			sT4LmUrl = new URL(T4_LM);
		} catch (MalformedURLException e) {
			fail(MSG_MALFORMED_URL_EXCEPTION);
		}

		try {
			sBytes = FileUtils.readFileToByteArray(T2_FILE);
		} catch (IOException e) {
			e.printStackTrace();
			fail(MSG_IO_EXCEPTION);
		}

		// TODO: the audio currently contains "mine edasi",
		// but the grammar does not support this sentence.
		// Make an audio that contains "mine neli meetrit edasi".
		T3_RESPONSE.add("mine neli");

		T4_RESPONSE.add("convert 2 ' to \"");
		T4_RESPONSE.add("convert 2 min to s");
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
			e.printStackTrace();
			fail(MSG_IO_EXCEPTION);
		} catch (NotAvailableException e) {
			e.printStackTrace();
			fail(MSG_NOT_AVAILABLE_EXCEPTION);
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
			e.printStackTrace();
			fail(MSG_IO_EXCEPTION);
		} catch (NotAvailableException e) {
			e.printStackTrace();
			fail(MSG_NOT_AVAILABLE_EXCEPTION);
		}

		int begin = 0;
		int chunkSize = 16000;
		while ((begin + chunkSize) < sBytes.length) {
			byte[] chunk = new byte[chunkSize];
			System.arraycopy(sBytes, begin, chunk, 0, chunkSize);
			try {
				recSession.sendChunk(chunk, false);
			} catch (IOException e) {
				e.printStackTrace();
				fail(MSG_IO_EXCEPTION);
			}
			begin += chunkSize;
		}
		chunkSize = sBytes.length - begin;
		byte[] chunk = new byte[chunkSize];
		System.arraycopy(sBytes, begin, chunk, 0, chunkSize);
		try {
			recSession.sendChunk(chunk, true);
		} catch (IOException e) {
			e.printStackTrace();
			fail(MSG_IO_EXCEPTION);
		}
		String response = null;
		try {
			response = recSession.getCurrentResult();
		} catch (IOException e) {
			e.printStackTrace();
			fail(MSG_IO_EXCEPTION);
		}
		assertEquals("1 2 3 4 5", response);
	}


	@Test
	public final void testRecognize3() {
		ChunkedWebRecSession recSession = new ChunkedWebRecSession(sWsUrl, sT3LmUrl);
		List<String> response = null;
		try {
			response = sendFlac(recSession);
		} catch (IOException e) {
			e.printStackTrace();
			fail(MSG_IO_EXCEPTION);
		} catch (NotAvailableException e) {
			e.printStackTrace();
			fail(MSG_NOT_AVAILABLE_EXCEPTION);
		}
		assertEquals(T3_RESPONSE, response);
	}


	@Test
	public final void testRecognize4() {
		ChunkedWebRecSession recSession = new ChunkedWebRecSession(sWsUrl, sT4LmUrl, T4_OUTPUT_LANG, 1);
		recSession.setLang(T4_LANG);
		recSession.setDeviceId(T4_DEVICE_ID);
		recSession.setPhrase(T4_PHRASE);
		recSession.setUserAgentComment(USER_AGENT_COMMENT);
		List<String> response = null;
		try {
			recSession.create();
			// blocks if true
			recSession.sendChunk(fileToBytes(T4_FILE), true);
			response = recSession.getResult().getLinearizations();
		} catch (IOException e) {
			e.printStackTrace();
			fail(MSG_IO_EXCEPTION);
		} catch (NotAvailableException e) {
			e.printStackTrace();
			fail(MSG_NOT_AVAILABLE_EXCEPTION);
		}
		assertEquals(T4_RESPONSE, response);
	}


	@Test
	public final void testRecognize5() {
		URL urlWrong = null;
		try {
			urlWrong = new URL("http://bark.phon.ioc.ee/");
		} catch (MalformedURLException e) {
			fail(MSG_MALFORMED_URL_EXCEPTION);
		}
		ChunkedWebRecSession recSession = new ChunkedWebRecSession(urlWrong);
		try {
			sendFlac(recSession);
			fail("Nonparsable response should be converted to an IOException");
		} catch (IOException e) {
			assertEquals(e.getMessage(), "Server response is not well-formed");
		} catch (NotAvailableException e) {
			e.printStackTrace();
			fail(MSG_NOT_AVAILABLE_EXCEPTION);
		}
	}


	@Test
	public final void testRecognize6() {
		ChunkedWebRecSession recSession = new ChunkedWebRecSession(sWsUrl);
		recSession.setUserAgentComment(USER_AGENT_COMMENT);
		try {
			recSession.create();
		} catch (IOException e) {
			e.printStackTrace();
			fail(MSG_IO_EXCEPTION);
		} catch (NotAvailableException e) {
			e.printStackTrace();
			fail(MSG_NOT_AVAILABLE_EXCEPTION);
		}

		int begin = 0;
		int chunkSize = 6000;
		while ((begin + chunkSize) < sBytes.length) {
			try {
				Thread.sleep(100);
			} catch (InterruptedException e1) {
				e1.printStackTrace();
				fail();
			}
			byte[] chunk = new byte[chunkSize];
			System.arraycopy(sBytes, begin, chunk, 0, chunkSize);
			try {
				recSession.sendChunk(chunk, false);
			} catch (IOException e) {
				e.printStackTrace();
				fail(MSG_IO_EXCEPTION);
			}
			begin += chunkSize;
		}
		chunkSize = sBytes.length - begin;
		byte[] chunk = new byte[chunkSize];
		System.arraycopy(sBytes, begin, chunk, 0, chunkSize);
		try {
			recSession.sendChunk(chunk, true);
		} catch (IOException e) {
			e.printStackTrace();
			fail(MSG_IO_EXCEPTION);
		}
		String response = null;
		try {
			response = recSession.getResult().getUtterances().get(0);
		} catch (IOException e) {
			e.printStackTrace();
			fail(MSG_IO_EXCEPTION);
		}
		assertEquals("1 2 3 4 5", response);
	}


	private byte[] fileToBytes(File file) {
		try {
			return FileUtils.readFileToByteArray(file);
		} catch (IOException e) {
			e.printStackTrace();
			fail(MSG_IO_EXCEPTION);
			return null;
		}
	}


	private List<String> sendFlac(ChunkedWebRecSession recSession) throws IOException, NotAvailableException {
		recSession.setUserAgentComment(USER_AGENT_COMMENT);
		recSession.setContentType(T3_CONTENT_TYPE);
		List<String> response = null;
		recSession.create();
		// blocks if true
		recSession.sendChunk(fileToBytes(T3_FILE), true);
		response = recSession.getResult().getUtterances();
		return response;
	}
}