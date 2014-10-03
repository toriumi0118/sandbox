package jp.java.test;

import java.util.*;

public class WordsCounter
{
    private Map<String, Integer> wordMap;
    private String inputString;

    // [input] コンストラクタ
    public WordsCounter(String text) {
        wordMap = new HashMap<String, Integer>();

        // 英字以外除去＆小文字に変換
        inputString = text.toLowerCase().replaceAll("[^a-z0-9]", " ");
    }

    // 入力が正常か
    public boolean isValid() {
        return (inputString != null && !inputString.equals(""));
    }

    // 単語毎に数える
    public List<String> countNumberOfWords() {
        for (String word : inputString.split("\\s+")) {
            if (! word.equals("")) {
                // 集計
                add(word);
            }
        }
        return getKeysByCount();
    }

    // 文字毎に数える
    public List<String> countNumberOfCharacters() {
        for(int count = 0; count < inputString.length(); count++) {
            char word = inputString.charAt(count);
            if ('a' <= word && word <= 'z') {
                add(String.valueOf(word));
            }
        }
        return getKeysByCount();
    }

    // 頭文字毎に数える
    public List<String> countNumberOfInitials() {
        for (String word : inputString.split("\\s+")) {
            if (! word.equals("")) {
                char firstChar = word.charAt(0);
                add(String.valueOf(firstChar));
            }
        }
        return getKeysByCount();
    }

    // 指定された文字列が登録された回数を返す
    // 一度も登録されていない場合は，0を返す。
    public int getCount(String searchWord) {
        int count = 0;
        if (wordMap.containsKey(searchWord)){
            count = wordMap.get(searchWord);
        }
        return count;
    }

    // [集計]
    // 入力文字列をカウンタに登録する． 同じ文字列が登録された回数を覚える．
    private void add(String registWord) {
        int count = getCount(registWord);
        wordMap.put(registWord, count + 1);
    }

    // [output] 登録されている文字列を登録回数の降順でソート
    private List<String> getKeysByCount() {
        Set<String> set = wordMap.keySet();
        List<String> wordList = new ArrayList<String>(set);

        Collections.sort(wordList, new Comparator<String>()
        {
                public int compare(String word1, String word2)
                {
                    int count1 = getCount(word1);
                    int count2 = getCount(word2);
                    if (count1 != count2)
                        return count1 > count2 ? -1 : 1;
                    return word1.compareTo(word2);
            }
            });
        return wordList;
    }
}