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

/**
 * <p>Representation of speakers. Every speaker has:
 * ID, name, gender, etc. In XML these are marked up
 * in the following way:</p>
 * 
 * <pre>
 * &lt;Speaker id="S1" name="K1" check="no" dialect="native" accent="" scope="local" type="male"/>
 * </pre>
 */
public class Speaker {

	private final String id;
	private final String name;
	//private final String check = null; // TODO: use boolean?
	//private final String dialect = null;
	//private final String accent = null;
	//private final String scope = null; // TODO: use enum?
	private final String type; // TODO: use enum

	public Speaker(String id) {
		this(id, null, null);
	}

	public Speaker(String id, String name, String type) {
		this.id = id;
		this.name = name;
		this.type = type;
	}

	public String getId() {
		return id;
	}

	public String getName() {
		return name;
	}


	public String getGender() {
		return type;
	}

	public String getScreenName() {
		if (name == null || name.length() == 0) {
			return id;
		}
		return name;
	}

	public String toString() {
		return getName() + " (" + getGender() + ")";
	}
}