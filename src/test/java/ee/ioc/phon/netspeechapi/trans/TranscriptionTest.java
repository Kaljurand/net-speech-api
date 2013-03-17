package ee.ioc.phon.netspeechapi.trans;

import com.google.common.base.Strings;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableSet;
import ee.ioc.phon.netspeechapi.Settings;
import org.junit.Test;

import java.io.File;
import java.io.IOException;

import static org.junit.Assert.fail;


import static org.junit.Assert.*;

import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

public class TranscriptionTest {

	private static final File T1_FILE = new File(Settings.DIR + "/trans/" + "1362033893856.mp3.xml");
	private static final File T2_FILE = new File(Settings.DIR + "/trans/" + "2007-04-29_1.mp3.xml");

	private static final Transcription T1_TRANS;
	private static final Transcription T2_TRANS;

	static {
		T1_TRANS = createTranscription(T1_FILE);
		T2_TRANS = createTranscription(T2_FILE);
	}

	@Test
	public final void testTrans1() {
		assertTrue(T1_TRANS != null);
	}

	@Test
	public final void testTrans2() {
		assertEquals("a388d699ae488990d8dd42c7c840f176ad2557db", T1_TRANS.getId());
	}

	@Test
	public final void testTrans3() {
		assertEquals(8, T1_TRANS.getIdToSpeaker().size());
	}

	@Test
	public final void testGetTurnStartTime() {
		NodeList nodes = T1_TRANS.getTurns();
		assertEquals(102230, Transcription.getStartTime(nodes.item(0)));
	}

	@Test
	public final void testGetTurnEndTime() {
		NodeList nodes = T1_TRANS.getTurns();
		assertEquals(103800, Transcription.getEndTime(nodes.item(0)));
	}

	@Test
	public final void testGetTurnText1() {
		NodeList nodes = T1_TRANS.getTurns();
		Turn turn = new Turn(nodes.item(0));
		assertEquals(ImmutableList.of("1", "2", "2", "3", "4", "1", "3", "4", "5"), turn.getWords());
		assertEquals(ImmutableSet.of("1", "2", "3", "4", "5"), turn.getUniqueWords());
	}

	@Test
	public final void testGetTurnDuration1() {
		NodeList nodes = T1_TRANS.getTurns();
		int totalDuration = 0;
		int excerptLen = 30;

		for (int i = 0; i < nodes.getLength(); i++) {
			Turn turn = new Turn(nodes.item(i));
			String text = turn.getText();
			int duration = turn.getDuration();
			totalDuration += duration;

			String excerpt = "";
			if (text.length() < excerptLen) {
				excerpt = Strings.padEnd(text, excerptLen, '_');
			} else {
				excerpt = text.substring(0, excerptLen);
			}

			int uniqueWordsSize = turn.getUniqueWords().size();
			if (uniqueWordsSize == 0) {
				uniqueWordsSize = 1;
			}
			int millisPerWord = duration / uniqueWordsSize;

			// nonSpeech == 1 sec per unique word

			System.out.format("%4s %s %5d %5d %10d %10d%n",
					turn.getSpeakerId(),
					excerpt,
					turn.getWords().size(),
					turn.getUniqueWords().size(),
					duration,
					millisPerWord
					);
		}
		assertEquals(2897850, totalDuration);
	}


	private static Transcription createTranscription(File file) {
		try {
			return new Transcription(file);
		} catch (SAXException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return null;
	}

	private void show(Object obj) {
		System.out.println(obj);
	}
}