/*
 * This file is part of Net Speech API.
 * Copyright 2011, Institute of Cybernetics at Tallinn University of Technology
 *
 * Net Speech API is free software: you can redistribute it and/or modify it under the
 * terms of the GNU Lesser General Public License as published by the Free Software Foundation,
 * either version 3 of the License, or (at your option) any later version.
 *
 * Net Speech API is distributed in the hope that it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
 * PURPOSE. See the GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License along with ACE View.
 * If not, see http://www.gnu.org/licenses/.
 */

package ee.ioc.phon.netspeechapi.trans;

import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.w3c.dom.Node;
import org.w3c.dom.NamedNodeMap;

import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

import ee.ioc.phon.netspeechapi.XmlUtils;

import java.io.File;
import java.io.IOException;
import java.util.Map;
import java.util.HashMap;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;

/**
 * <p>Parses the transcription file and provides access to the
 * speakers, paragraphs, sync points, etc.</p>
 * 
 * @author Kaarel Kaljurand
 */
public class Transcription {

	private static final String EL_TURN = "Turn";
	private static final String EL_SPEAKERS = "Speakers";
	private static final String EL_SPEAKER = "Speaker";
	private static final String ATTR_START_TIME = "startTime";
	private static final String ATTR_END_TIME = "endTime";

	private final Map<String, Speaker> mIdToSpeaker = new HashMap<String, Speaker>();

	private final Element mRoot;
	private final String mId;

	/**
	 * <p>Parse the given transcription file.</p>
	 * 
	 * TODO: maybe use instead:
	 * 
	 * this(new InputSource(new BufferedReader(new FileReader(xmlFile))));
	 * 
	 * @param xmlFile File
	 * @throws SAXException if there are XML errors
	 * @throws IOException if the file is not accessible
	 */
	public Transcription(File xmlFile) throws SAXException, IOException {
		mRoot = XmlUtils.getDocumentElement(xmlFile);
		mId = createId();
		createIdToSpeaker();
	}


	public Transcription(InputSource is) throws SAXException, IOException {
		mRoot = XmlUtils.getDocumentElement(is);
		mId = createId();
		createIdToSpeaker();
	}


	/**
	 * <p>Returns the XML root element of this transcription.</p>
	 */
	public Element getRoot() {
		return mRoot;
	}


	/**
	 * <p>Returns the unique identifier of this transcription.</p>
	 */
	public String getId() {
		return mId;
	}


	/**
	 * <p>Returns all the turns as XML nodes.</p>
	 */
	public NodeList getTurns() {
		return mRoot.getElementsByTagName(EL_TURN);
	}


	/**
	 * <p>Returns the textual content of the given turn.</p>
	 * 
	 * @param turn XML node
	 * @return Textual content of the given turn.
	 */
	public String getTurnText(Node turn) {
		StringBuilder sb = new StringBuilder();
		XmlUtils.getText(turn, sb);
		return sb.toString();
	}


	/**
	 * <p>Returns the ID of the speaker of the given turn.
	 * (Every turn has at most one speaker.)
	 * Returns <code>null</code> if there is no speaker.</p>
	 * 
	 * @param turn XML node
	 * @return Speaker ID
	 */
	public String getTurnSpeakerId(Node turn) {
		return XmlUtils.getAttrValue(turn, "speaker");
	}

	public static String getSpeakerId(Node turn) {
		return XmlUtils.getAttrValue(turn, "speaker");
	}

	/**
	 * <p>Returns the time when the given turn starts in
	 * number of milliseconds from the beginning of the audio.</p>
	 *
	 * <p>If the transcription does not specify the time, or
	 * the specification contains a syntax error, then returns -1.</p>
	 *
	 * @param turn XML node
	 * @return Start time of the turn
	 * @deprecated
	 */
	public int getTurnStartTime(Node turn) {
		return getAttrValueAsMillis(turn, ATTR_START_TIME);
	}

	public static int getStartTime(Node turn) {
		return getAttrValueAsMillis(turn, ATTR_START_TIME);
	}


	/**
	 * <p>Returns the time when the given turn ends in
	 * number of milliseconds from the beginning of the audio.</p>
	 *
	 * <p>If the transcription does not specify the time, or
	 * the specification contains a syntax error, then returns -1.</p>
	 *
	 * @param turn XML node
	 * @return End time of the turn
	 */
	public static int getEndTime(Node turn) {
		return getAttrValueAsMillis(turn, ATTR_END_TIME);
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
	 * <p>Returns the textual content of the complete transcription.</p>
	 */
	public String getPlainText() {
		NodeList turns = getTurns();
		StringBuilder sb = new StringBuilder();
		for (int i = 0; i < turns.getLength(); i++) {
			XmlUtils.getText(turns.item(i), sb);
			sb.append('\n');
		}
		return sb.toString();
	}


	/**
	 * <p>Returns sync points where each point is in milliseconds. Badly
	 * formatted syncpoints are not returned.</p>
	 *
	 * TODO: collect only the startTime of each Turn element (why do we need Sync at all?)
	 */
	public List<Integer> getSyncPoints() {
		List<Integer> syncPoints = new ArrayList<Integer>();
		NodeList nodeList = mRoot.getElementsByTagName("Sync");
		for (int i = 0; i < nodeList.getLength(); i++) {
			String time = XmlUtils.getAttrValue(nodeList.item(i), "time");
			if (time != null) {
				try {
					syncPoints.add(getMillis(time));
				} catch (NumberFormatException e) {
					// We ignore badly formatted timestamps
				}
			}
		}
		return syncPoints;
	}


	/**
	 * <p>Returns a map from speaker IDs to speaker objects.</p>
	 */
	public Map<String, Speaker> getIdToSpeaker() {
		return mIdToSpeaker;
	}


	/**
	 * <p>Returns the set of speaker IDs.</p>
	 */
	public Set<String> getSpeakerIds() {
		return mIdToSpeaker.keySet();
	}


	private String createId() {
		NodeList nodeList = mRoot.getElementsByTagName("Trans");
		String id = null;
		if (nodeList.getLength() > 0) {
			return XmlUtils.getAttrValue(nodeList.item(0), "audio_filename");
		}
		return id;
	}


	/**
	 * <p>Searches speakers under the given root, and assigns global IDs to the speakers.</p>
	 */
	private void createIdToSpeaker() {
		Element rootSpeakers = XmlUtils.getChild(mRoot, EL_SPEAKERS);
		if (rootSpeakers != null) {
			NodeList nodeList = rootSpeakers.getElementsByTagName(EL_SPEAKER);
			for (int i = 0; i < nodeList.getLength(); i++) {
				NamedNodeMap nodeMap = nodeList.item(i).getAttributes();
				if (nodeMap != null) {
					Node idNode = nodeMap.getNamedItem("id");
					Node nameNode = nodeMap.getNamedItem("name");
					Node typeNode = nodeMap.getNamedItem("type");
					if (idNode != null) {
						String localId = idNode.getNodeValue();
						String sId = mId + "_" + localId;
						if (nameNode != null && typeNode != null) {
							mIdToSpeaker.put(localId, new Speaker(sId, nameNode.getNodeValue(), typeNode.getNodeValue()));
						} else {
							mIdToSpeaker.put(localId, new Speaker(sId));
						}
					}
				}
			}
		}
	}


	/**
	 * <p>Parses time given as string in seconds, e.g. "4.12".
	 * Returns the number of corresponding milliseconds.</p>
	 * 
	 * <p>Throws: NumberFormatException - if the string does not contain a parsable float.</p>
	 */
	private static int getMillis(String timeAsString) {
		return (int) (Float.parseFloat(timeAsString) * 1000);
	}
}