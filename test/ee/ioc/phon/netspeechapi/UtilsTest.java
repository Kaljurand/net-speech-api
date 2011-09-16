package ee.ioc.phon.netspeechapi;

import static org.junit.Assert.*;

import java.io.IOException;


import org.apache.http.client.methods.HttpPost;
import org.junit.Test;

import ee.ioc.phon.netspeechapi.Utils;

public class UtilsTest {

	@Test
	public final void testGetResponseEntityAsString() {

		HttpPost post = new HttpPost(Settings.NON_EXISTENT_URL);
		String response = null;

		try {
			response = Utils.getResponseEntityAsString(post);
		} catch (IOException e) {
			// The test should reach here
		}

		assertEquals(null, response);
	}
}