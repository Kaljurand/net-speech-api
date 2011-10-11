package ee.ioc.phon.netspeechapi.recsession;

import java.util.List;

public interface RecSessionResult {

	/**
	 * <p>Returns a flat list of linearizations where
	 * the information about which hypothesis produced
	 * the linearizations and what is the language of
	 * the linearization is not preserved.</p>
	 *
	 * <p>Note: the implementation should never return null.</p>
	 *
	 * @return (flat) list of linearizations
	 */
	public List<String> getLinearizations();


	/**
	 * <p>Note: the implementation should never return null.</p>
	 *
	 * @return list of utterances
	 */
	public List<String> getUtterances();

}