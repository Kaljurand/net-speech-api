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

package ee.ioc.phon.netspeechapi.recsession;

import java.util.List;

/**
 * <p>The result of transcription is a complex object,
 * possibly containing:</p>
 *
 * <ul>
 * <li>multiple transcription hypothesis with optional confidence scores;</li>
 * <li>the raw recognition result, Utterance (<code>String</code>),
 * as well as normalizations into languages identified by language codes (Linearizations).</li>
 * </ul>
 *
 * @author Kaarel Kaljurand
 */
public interface RecSessionResult {

	/**
	 * <p>Returns a flat list of linearizations where
	 * the information about which hypothesis produced
	 * the linearizations and what is the language of
	 * the linearization is not preserved.</p>
	 *
	 * <p>The implementation MUST return a (possibly empty) list
	 * which MUST NOT contain empty <code>String</code>s.
	 * <code>null</code> is not allowed as a return value.</p>
	 *
	 * @return (flat) list of linearizations
	 */
	public List<String> getLinearizations();


	/**
	 * <p>The implementation MUST return a (possibly empty) list
	 * which MUST NOT contain empty <code>String</code>s
	 * <code>null</code> is not allowed as a return value.</p>
	 *
	 * @return list of utterances
	 */
	public List<String> getUtterances();

	public List<Hypothesis> getHypotheses();

}
