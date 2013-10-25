package ee.ioc.phon.netspeechapi.duplex;

import java.util.List;


public class RecognitionEvent {
	public static final int STATUS_SUCCESS = 0;
	public static final int STATUS_NO_SPEECH = 1;
	public static final int STATUS_ABORTED = 2;
	public static final int STATUS_AUDIO_CAPTURE = 3;
	public static final int STATUS_NETWORK = 4;
	public static final int STATUS_NOT_ALLOWED = 5;
	public static final int STATUS_SERVICE_NOT_ALLOWED = 6;
	public static final int STATUS_BAD_GRAMMAR = 7;
	public static final int STATUS_LANGUAGE_NOT_SUPPORTED = 8;

	public static class Result {
		private boolean isFinal;
		private List<Hypothesis> hypotheses;

		public Result(boolean isFinal, List<Hypothesis> hypotheses) {
			this.isFinal = isFinal;
			this.hypotheses = hypotheses;
		}

		public boolean isFinal() {
			return isFinal;
		}

		public List<Hypothesis> getHypotheses() {
			return hypotheses;
		}

		@Override
		public int hashCode() {
			final int prime = 31;
			int result = 1;
			result = prime * result
					+ ((hypotheses == null) ? 0 : hypotheses.hashCode());
			result = prime * result + (isFinal ? 1231 : 1237);
			return result;
		}

		@Override
		public boolean equals(Object obj) {
			if (this == obj)
				return true;
			if (obj == null)
				return false;
			if (getClass() != obj.getClass())
				return false;
			Result other = (Result) obj;
			if (hypotheses == null) {
				if (other.hypotheses != null)
					return false;
			} else if (!hypotheses.equals(other.hypotheses))
				return false;
			if (isFinal != other.isFinal)
				return false;
			return true;
		}

		@Override
		public String toString() {
			return "Result [hypotheses=" + hypotheses + ", final=" + isFinal
					+ "]";
		}
	}
	
	public static class Hypothesis {
		private String transcript;
		private float confidence;
		
		public Hypothesis(String transcript, float confidence) {
			this.transcript = transcript;
			this.confidence = confidence;
		}

		public String getTranscript() {
			return transcript;
		}

		public float getConfidence() {
			return confidence;
		}

		@Override
		public int hashCode() {
			final int prime = 31;
			int result = 1;
			result = prime * result + Float.floatToIntBits(confidence);
			result = prime * result
					+ ((transcript == null) ? 0 : transcript.hashCode());
			return result;
		}

		@Override
		public boolean equals(Object obj) {
			if (this == obj)
				return true;
			if (obj == null)
				return false;
			if (getClass() != obj.getClass())
				return false;
			Hypothesis other = (Hypothesis) obj;
			if (Float.floatToIntBits(confidence) != Float
					.floatToIntBits(other.confidence))
				return false;
			if (transcript == null) {
				if (other.transcript != null)
					return false;
			} else if (!transcript.equals(other.transcript))
				return false;
			return true;
		}

		@Override
		public String toString() {
			return "Hypothesis [confidence=" + confidence + ", transcript="
					+ transcript + "]";
		}
	}
	
	private int status;
	private Result result;
	
	public RecognitionEvent(int status, Result result) {
		super();
		this.status = status;
		this.result = result;
	}

	public int getStatus() {
		return status;
	}

	public Result getResult() {
		return result;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result
				+ ((this.result == null) ? 0 : this.result.hashCode());
		result = prime * result + status;
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		RecognitionEvent other = (RecognitionEvent) obj;
		if (result == null) {
			if (other.result != null)
				return false;
		} else if (!result.equals(other.result))
			return false;
		if (status != other.status)
			return false;
		return true;
	}

	@Override
	public String toString() {
		return "RecognitionEvent [result=" + result + ", status=" + status
				+ "]";
	}
	
	
	
}
