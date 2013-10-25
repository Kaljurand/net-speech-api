package ee.ioc.phon.netspeechapi.duplex;

import java.io.IOException;

public interface DuplexRecognitionSession {

	void connect() throws IOException;
	
	void sendChunk(byte[] bytes, boolean isLast) throws IOException;
	
	void addRecognitionEventListener(RecognitionEventListener recognitionEventListener);
}
