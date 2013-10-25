package ee.ioc.phon.netspeechapi.duplex;

public interface RecognitionEventListener {

	void onRecognitionEvent(RecognitionEvent event);
	
	void onClose();
}
