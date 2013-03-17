package ee.ioc.phon.netspeechapi.trans;

import ee.ioc.phon.netspeechapi.XmlUtils;
import org.w3c.dom.Node;

import java.util.List;
import java.util.Set;

public class Turn {

	private static final String ATTR_SPEAKER = "speaker";
	private static final String ATTR_START_TIME = "startTime";
	private static final String ATTR_END_TIME = "endTime";

	private final Node mNode;
	private final String mText;
	private final Tokenizer mTokenizer;

	public Turn(Node node) {
		mNode = node;
		mText = createText(node);
		mTokenizer = new Tokenizer(mText);
	}

	/**
	 * @return textual content of the given turn.
	 */
	public String getText() {
		return mText;
	}

	public List<String> getWords() {
		return mTokenizer.getWords();
	}

	public Set<String> getUniqueWords() {
		return mTokenizer.getUniqueWords();
	}

	public String getSpeakerId() {
		return XmlUtils.getAttrValue(mNode, ATTR_SPEAKER);
	}

	/**
	 * <p>Returns the time when this turn starts in
	 * number of milliseconds from the beginning of the audio.</p>
	 * <p/>
	 * <p>If the transcription does not specify the time, or
	 * the specification contains a syntax error, then returns -1.</p>
	 *
	 * @return start time of the turn
	 */
	public int getStartTime() {
		return getAttrValueAsMillis(mNode, ATTR_START_TIME);
	}


	/**
	 * <p>Returns the time when this turn ends in
	 * number of milliseconds from the beginning of the audio.</p>
	 * <p/>
	 * <p>If the transcription does not specify the time, or
	 * the specification contains a syntax error, then returns -1.</p>
	 *
	 * @return end time of the turn
	 */
	public int getEndTime() {
		return getAttrValueAsMillis(mNode, ATTR_END_TIME);
	}

	public int getDuration() {
		return getEndTime() - getStartTime();
	}


	private static int getAttrValueAsMillis(Node node, String attr) {
		String value = XmlUtils.getAttrValue(node, attr);
		if (value == null) {
			return -1;
		}
		try {
			return getMillis(value);
		} catch (NumberFormatException e) {
			return -1;
		}
	}


	/**
	 * <p>Parses time given as string in seconds, e.g. "4.12".
	 * Returns the number of corresponding milliseconds.</p>
	 * <p/>
	 * <p>Throws: NumberFormatException - if the string does not contain a parsable float.</p>
	 */
	private static int getMillis(String timeAsString) {
		return (int) (Float.parseFloat(timeAsString) * 1000);
	}

	private static String createText(Node node) {
		StringBuilder sb = new StringBuilder();
		XmlUtils.getText(node, sb);
		return sb.toString();
	}

}