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

package ee.ioc.phon.netspeechapi;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.w3c.dom.Node;
import org.w3c.dom.NamedNodeMap;

import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import java.io.File;
import java.io.IOException;
import java.io.Reader;
import java.util.HashMap;
import java.util.Map;

/**
 * <p>Convenience methods for manipulating XML files.</p>
 */
public class XmlUtils {

	/**
	 * <p>Returns the value that corresponds to the given attribute name
	 * in the given node.
	 * Returns <code>null</code> if such an attribute does not exist.</p>
	 * 
	 * @param node XML node
	 * @param attrName XML attribute name
	 * @return Attribute value or <code>null</code>
	 */
	public static String getAttrValue(Node node, String attrName) {
		NamedNodeMap nodeMap = node.getAttributes();
		if (nodeMap == null) return null;
		Node attr = nodeMap.getNamedItem(attrName);
		if (attr == null) return null;
		return attr.getNodeValue();
	}


	/**
	 * <p>Parses the given XML file and returns its root node.</p>
	 * 
	 * @param xmlFile File
	 * @return Root element of the XML tree
	 * @throws SAXException e.g. if there are XML well-formedness errors
	 * @throws IOException e.g. if the input file is not available
	 */
	public static Element getDocumentElement(File xmlFile) throws SAXException, IOException {
		DocumentBuilder builder = getDocumentBuilder();
		Document dom = builder.parse(xmlFile);
		Element root = dom.getDocumentElement();
		// It turns out that sometimes getDocumentElement returns null.
		// We convert it into SAXException
		// TODO: find out how to handle it in the best way
		if (root == null) {
			throw new SAXException("getDocumentElement() == null");
		}
		return root;
	}


	public static Element getDocumentElement(InputSource is) throws SAXException, IOException {
		DocumentBuilder builder = getDocumentBuilder();
		Document dom = builder.parse(is);
		Element root = dom.getDocumentElement();
		// It turns out that sometimes getDocumentElement returns null.
		// We convert it into SAXException
		// TODO: find out how to handle it in the best way
		if (root == null) {
			throw new SAXException("getDocumentElement() == null");
		}
		return root;
	}


	/**
	 * <p>Returns the given element's first child that has the given name.</p>
	 * 
	 * @param node XML node
	 * @param childName XML element name
	 * @return XML child element that has the given name or <code>null</code>
	 */
	public static Element getChild(Node node, String childName) {
		NodeList children = node.getChildNodes();
		for (int i = 0; i < children.getLength(); i++) {
			Node childNode = children.item(i);
			if (childNode.getNodeType() == Node.ELEMENT_NODE && childNode.getNodeName().equals(childName)) {
				return (Element) node;
			}
		}
		return null;
	}


	/**
	 * <p>Constructs the textual content of the given node and
	 * recursively the textual content of its sub element nodes.
	 * Appends the result to the given StringBuilder.</p>
	 * 
	 * @param node XML node
	 * @param sb StringBuilder that will contain the textual content of the node
	 */
	public static void getText(Node node, StringBuilder sb) {
		NodeList children = node.getChildNodes();
		for (int i = 0; i < children.getLength(); i++) {
			Node child = children.item(i);
			if (child.getNodeType() == Node.TEXT_NODE) {
				sb.append(' '); // BUG: this is a hack
				sb.append(child.getNodeValue().trim());
			} else if (child.getNodeType() == Node.ELEMENT_NODE) {
				getText(child, sb);
			}
		}
	}


	/**
	 * Note: don't create new IOException(), Android prior to v2.3 doesn't like that.
	 * dalvik: Could not find method java.io.IOException.<init>
	 */
	public static Map<String, String> load(Reader reader) throws SAXException, IOException {
		DocumentBuilder db = getDocumentBuilder();
		Document doc = db.parse(new InputSource(reader));
		doc.getDocumentElement().normalize();

		Map<String, String> result = new HashMap<String, String>();
		loadFromElements(result, doc.getDocumentElement().getChildNodes(), 
				new StringBuffer(doc.getDocumentElement().getNodeName()));
		return result;
	}    


	/**
	 * Sets up an XML parser.
	 */
	private static DocumentBuilder getDocumentBuilder() {
		DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
		//factory.setCoalescing(true); // default = false
		factory.setExpandEntityReferences(true); // default = true
		factory.setIgnoringComments(true); // default = false
		//factory.setIgnoringElementContentWhitespace(false); // default = false // requires validating mode
		factory.setNamespaceAware(false); // default = false
		factory.setValidating(false); // default = false

		try {
			return factory.newDocumentBuilder();
		} catch (ParserConfigurationException e) {
			// We ignore this exception assuming that it is a programmer mistake.
			throw new RuntimeException(e);
		}
	}


	/**
	 * <p>This helper method loads the XML properties from a specific
	 *   XML element, or set of elements.</p>
	 *
	 * @param nodeList <code>List</code> of elements to load from.
	 * @param baseName the base name of this property.
	 */
	private static void loadFromElements(Map<String, String> result, NodeList nodeList, StringBuffer baseName) {
		// Iterate through each element
		for (int s = 0; s < nodeList.getLength(); s++) {
			Node current = nodeList.item(s);
			if (current.getNodeType() == Node.ELEMENT_NODE) {
				String name = current.getNodeName();
				String text = null;
				NodeList childNodes = current.getChildNodes();

				if (childNodes.getLength() > 0) {
					text = current.getChildNodes().item(0).getNodeValue();
				} 

				// String text = current.getAttributeValue("value");            

				// Don't add "." if no baseName
				if (baseName.length() > 0) {
					baseName.append(".");
				}            
				baseName.append(name);

				// See if we have an element value
				if ((text == null) || (text.equals(""))) {
					// If no text, recurse on children
					loadFromElements(result, current.getChildNodes(),
							baseName);
				} else {                
					// If text, this is a property
					result.put(baseName.toString(), text);
				}            

				// On unwind from recursion, remove last name
				if (baseName.length() == name.length()) {
					baseName.setLength(0);
				} else {                
					baseName.setLength(baseName.length() - 
							(name.length() + 1));
				}
			}
		}        
	}   
}