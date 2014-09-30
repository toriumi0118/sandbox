package jp.java.test;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Set;

public class WordsCounter extends HashMap<String,Integer>
{
    //入力文字列をカウンタに登録する． 同じ文字列が登録された回数を覚える．
    public void add(String registWord)
    {
        int count = get(registWord);
        put(registWord, count + 1);
    }

	//指定された文字列が登録された回数を返す
	//一度も登録されていない場合は，0を返す。
    public int get(String searchWord)
    {
        int count = 0;

        if (containsKey(searchWord)){
            count = super.get(searchWord);
        }

        return count;
    }

    //登録している単語を空にする
    public void clear() {
        super.clear();
    }

    //登録されている文字列を登録回数の降順でソート
    public List<String> getKeysByCount()
    {
        Set<String> set = keySet();
        List<String> wordList = new ArrayList<String>(set);

        Collections.sort(wordList, new Comparator<String>()
        {
                public int compare(String word1, String word2)
                {
                    int count1 = get(word1);
                    int count2 = get(word2);
                    if (count1 != count2)
                        return count1 > count2 ? -1 : 1;
                    return word1.compareTo(word2);
                }
            });

        return wordList;
    }
}