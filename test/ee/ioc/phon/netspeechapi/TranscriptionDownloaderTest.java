package ee.ioc.phon.netspeechapi;

import static org.junit.Assert.*;

import java.io.File;
import java.io.IOException;
import java.io.StringReader;


import org.apache.http.client.ClientProtocolException;
import org.junit.Test;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

import ee.ioc.phon.netspeechapi.AudioUploader;
import ee.ioc.phon.netspeechapi.TranscriptionDownloader;
import ee.ioc.phon.netspeechapi.Utils;
import ee.ioc.phon.netspeechapi.trans.Transcription;

public class TranscriptionDownloaderTest {

	private static final String TEST_FILE_NAME = Settings.DIR + "test_estspeechapi.wav";
	private static final String TOKEN_ERROR = "token_error";

	private static final String T1_TOKEN = "328c5f7ae94b5357a9d965deca9e367682ea6c7d";
	private static final String T1_TRANS_PLAIN = "Pere ära on väljas üsna ilus ilm lund ei saja võib olla lääne suur hakkama äkki tuleb ka. .";
	private static final int T1_SPEAKER_COUNT = 1;

	private static final String USER_AGENT_COMMENT = "TranscriptionDownloaderTest";


	@Test
	public final void testGetTranscription1() {
		TranscriptionDownloader td = new TranscriptionDownloader();
		td.setUserAgentComment(USER_AGENT_COMMENT);
		Transcription trans = null;
		try {
			trans = new Transcription(new InputSource(new StringReader(td.download(T1_TOKEN))));
		} catch (IOException e) {
			fail("should not throw IOException: " + e.getMessage());
			e.printStackTrace();
		} catch (SAXException e) {
			fail("should not throw SAXException: " + e.getMessage());
			e.printStackTrace();
		}
		if (trans == null) {
			fail("Transcription == null");
		}
		assertEquals(T1_TRANS_PLAIN, trans.getPlainText().trim());
	}


	@Test
	public final void testGetTranscription2() {
		TranscriptionDownloader td = new TranscriptionDownloader();
		td.setUserAgentComment(USER_AGENT_COMMENT);
		String trans = null;
		try {
			trans = td.download(TOKEN_ERROR);
		} catch (IOException e) {
			fail("should not throw IOException: " + e.getMessage());
			e.printStackTrace();
		}
		assertEquals(null, trans);
	}


	@Test
	public final void testGetTranscriptionSpeakers1() {
		TranscriptionDownloader td = new TranscriptionDownloader();
		td.setUserAgentComment(USER_AGENT_COMMENT);
		Transcription trans = null;
		try {
			trans = new Transcription(new InputSource(new StringReader(td.download(T1_TOKEN))));
		} catch (IOException e) {
			fail("should not throw IOException: " + e.getMessage());
			e.printStackTrace();
		} catch (SAXException e) {
			fail("should not throw SAXException: " + e.getMessage());
			e.printStackTrace();
		}
		if (trans == null) {
			fail("Transcription == null");
		}
		assertEquals(T1_SPEAKER_COUNT, trans.getIdToSpeaker().size());
	}


	/**
	 * TODO: there should be a class that does these two steps
	 * in sequence, and this test should be among the test
	 * cases of this new class.
	 */
	@Test
	public final void testHttpRecognizerAndTranscriptionDownloader() {
		AudioUploader up = new AudioUploader(Settings.EMAIL);
		up.setUserAgentComment(USER_AGENT_COMMENT);
		String token = "";
		try {
			token = up.uploadFileUnderRandomName(new File(TEST_FILE_NAME), Settings.MIME, Settings.RATE);
		} catch (ClientProtocolException e) {
			fail("should not throw ClientProtocolException");
			e.printStackTrace();
		} catch (IOException e) {
			fail("should not throw IOException");
			e.printStackTrace();
		}
		if (! Utils.isLegalToken(token)) {
			fail("Malformed token: " + token);
		}

		TranscriptionDownloader down = new TranscriptionDownloader();
		down.setUserAgentComment(USER_AGENT_COMMENT);
		String trans = null;
		try {
			trans = down.download(token);
		} catch (IOException e) {
			fail("should not throw IOException");
			e.printStackTrace();
		}
		assertEquals(null, trans);
	}
}