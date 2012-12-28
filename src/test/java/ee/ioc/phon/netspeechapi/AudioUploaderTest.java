package ee.ioc.phon.netspeechapi;

import static org.junit.Assert.*;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;


import org.apache.http.client.ClientProtocolException;
import org.apache.http.entity.mime.MultipartEntity;
import org.apache.http.entity.mime.content.FileBody;
import org.junit.Test;

import ee.ioc.phon.netspeechapi.AudioUploader;
import ee.ioc.phon.netspeechapi.Constants;
import ee.ioc.phon.netspeechapi.MyFileUtils;
import ee.ioc.phon.netspeechapi.Utils;

public class AudioUploaderTest {

	private static final String T1_FILE = Settings.DIR + "test_estspeechapi.wav";
	private static final String T1_MIME = Constants.MIME_WAV;
	private static final String T1_MPE = Settings.DIR + "test_estspeechapi.mpe";
	private static final String T2_FILE = Settings.DIR + "test_recognize1.wav";
	private static final String T3_FILE = Settings.DIR + "test_mine_edasi.flac";
	private static final String T3_MIME = Constants.MIME_FLAC;
	private static final String T3_MPE = Settings.DIR + "test_mine_edasi.mpe";
	private static final String USER_AGENT_COMMENT = "AudioUploaderTest";
	private static final String UNPREDICTABLE_TOKEN = "unpredictable_token";

	@Test
	public final void testUpload1() {
		AudioUploader hr = new AudioUploader(Settings.EMAIL);
		hr.setUserAgentComment(USER_AGENT_COMMENT);
		String token = null;
		try {
			token = hr.uploadFileUnderRandomName(new File(T1_FILE), Settings.MIME, Settings.RATE);
		} catch (ClientProtocolException e) {
			fail("should not throw ClientProtocolException");
			e.printStackTrace();
		} catch (IOException e) {
			fail("should not throw IOException");
			e.printStackTrace();
		}
		assertEquals(true, Utils.isLegalToken(token));
	}


	@Test
	public final void testUpload2() {
		AudioUploader hr = new AudioUploader(Settings.EMAIL);
		hr.setUserAgentComment(USER_AGENT_COMMENT);
		String token = null;
		try {
			token = hr.uploadFileUnderRandomName(new File(T2_FILE), Settings.MIME, Settings.RATE);
		} catch (ClientProtocolException e) {
			fail("should not throw ClientProtocolException");
			e.printStackTrace();
		} catch (IOException e) {
			fail("should not throw IOException");
			e.printStackTrace();
		}
		assertEquals(true, Utils.isLegalToken(token));
	}


	@Test
	public final void testCreateMultipartEntity() {
		File file = new File(T1_FILE);
		AudioUploader hr = new AudioUploader(Settings.EMAIL);
		hr.setUserAgentComment(USER_AGENT_COMMENT);
		String filename = MyFileUtils.createRandomFilename(T1_MIME);
		FileBody fileBody = new FileBody(file, filename, T1_MIME, null);
		MultipartEntity entity = hr.createMultipartEntity(fileBody, T1_MIME, Settings.RATE);
		try {
			entity.writeTo(new FileOutputStream(T1_MPE));
		} catch (FileNotFoundException e) {
			fail("should not throw FileNotFoundException");
			e.printStackTrace();
		} catch (IOException e) {
			fail("should not throw IOException");
			e.printStackTrace();
		}
		assertEquals(true, true);
	}

	@Test
	public final void testCreateMultipartEntity3() {
		File file = new File(T3_FILE);
		AudioUploader hr = new AudioUploader(Settings.EMAIL);
		hr.setUserAgentComment(USER_AGENT_COMMENT);
		String filename = MyFileUtils.createRandomFilename(T3_MIME);
		FileBody fileBody = new FileBody(file, filename, T3_MIME, null);
		MultipartEntity entity = hr.createMultipartEntity(fileBody, T3_MIME, Settings.RATE);
		try {
			entity.writeTo(new FileOutputStream(T3_MPE));
		} catch (FileNotFoundException e) {
			fail("should not throw FileNotFoundException");
			e.printStackTrace();
		} catch (IOException e) {
			fail("should not throw IOException");
			e.printStackTrace();
		}
		assertEquals(true, true);
	}
}