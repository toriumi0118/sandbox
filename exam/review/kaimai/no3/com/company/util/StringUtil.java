package com.company.util;

import java.util.*;

public class StringUtil {
    private static final String DELIMITER = " .,:;'";

    private interface Tokenizer {
        public void text2tokens(String text, List<String> tokens);
    }

    private static List<Map.Entry<String, Integer>> countText(String text, Tokenizer tokenier) {
        List<Map.Entry<String, Integer>> countList = new ArrayList<Map.Entry<String, Integer>>();
        if (text == null || 0 >= text.length()) {
            return countList;
        }

        List<String> tokens = new ArrayList<String>();
        tokenier.text2tokens(text.toLowerCase(), tokens);
        Map<String, Integer> tokenMap =  new HashMap<String, Integer>();
        for (String key : tokens) {
            if (tokenMap.containsKey(key)) {
                tokenMap.put(key, (int) tokenMap.get(key) + 1);
            } else {
                tokenMap.put(key, 1);
            }
        }

        countList.addAll(tokenMap.entrySet());
        Collections.sort(countList, new Comparator<Map.Entry<String, Integer>>() {
            @Override
            public int compare(Map.Entry<String,Integer> a, Map.Entry<String,Integer> b) {
                int ret = ((Integer) a.getValue()).compareTo((Integer) b.getValue()) * -1;
                if (ret != 0) {
                    return ret;
                }
                return ((String) a.getKey()).compareTo((String) b.getKey());
            }
        });
        return countList;
    }

    // 単語(数字含む)の出現回数
    public static List<Map.Entry<String, Integer>> countNumberOfWords(String text) {
        return countText(text, new Tokenizer() {
            @Override
            public void text2tokens(String text, List<String> tokens) {
                StringTokenizer tokenizer = new StringTokenizer(text, DELIMITER);
                while (tokenizer.hasMoreTokens()) {
                    tokens.add(tokenizer.nextToken());
                }
            }
        });
    }

    // アルファベットの出現回数
    public static List<Map.Entry<String, Integer>> countNumberOfCharacters(String text) {
        return countText(text, new Tokenizer() {
            @Override
            public void text2tokens(String text, List<String> tokens) {
                for (char character : text.toCharArray()) {
                    if ('a' <= character && character <= 'z') {
                        tokens.add(String.valueOf(character));
                    }
                }
            }
        });
    }

    // 頭文字(数字含む)の出現回数
    public static List<Map.Entry<String, Integer>> countNumberOfInitials(String text) {
        return countText(text, new Tokenizer() {
            @Override
            public void text2tokens(String text, List<String> tokens) {
                StringTokenizer tokenizer = new StringTokenizer(text, DELIMITER);
                while (tokenizer.hasMoreTokens()) {
                    tokens.add(tokenizer.nextToken().substring(0, 1));
                }
            }
        });
   }
}