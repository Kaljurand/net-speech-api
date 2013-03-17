package ee.ioc.phon.netspeechapi.trans;

import com.google.common.base.Splitter;
import com.google.common.collect.HashMultiset;
import com.google.common.collect.Lists;
import com.google.common.collect.Multiset;

import java.util.List;
import java.util.Set;

public class Tokenizer {

	public static final Splitter SPLITTER = Splitter.onPattern("[ .,:;?!\n\t\r-]").omitEmptyStrings().trimResults();

	private final List<String> mWords;
	private final Multiset<String> mUniqueWords;

	public Tokenizer(String str) {
		mWords = Lists.newArrayList(SPLITTER.split(str));
		mUniqueWords = HashMultiset.create(mWords);
	}

	public List<String> getWords() {
		return mWords;
	}

	public Set<String> getUniqueWords() {
		return mUniqueWords.elementSet();
	}
}