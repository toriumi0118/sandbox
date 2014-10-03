package jp.java.test;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.List;

public class Test
{
    public static void main(String[] args) throws IOException {
    	BufferedReader inputData = new BufferedReader(new InputStreamReader(System.in));

        while (true) {
            System.out.print("文字列を入力してください：");

        	String inputString = inputData.readLine();
        	System.out.println(inputString);

            WordsCounter table = new WordsCounter(inputString);

            if (!table.isValid()) {
            	System.out.println("文字が入力されていません。");
                continue;
            }

            System.out.print("どの形式で出現回数を出力しますか？\n 1:単語  2:アルファベット 3:単語頭文字\n選択:");

            String selectNo = inputData.readLine();
            if(selectNo == null || selectNo.equals("") || !selectNo.matches("^[1-3]$")) {
            	System.out.println("出力形式は1-3から選択してください。");
            	continue;
            }

            List<String> countList = null;
            switch(Integer.valueOf(selectNo)) {
            	//単語出力
            	case 1:
                    countList = table.countNumberOfWords();
            		break;
            	//アルファベット出力
            	case 2:
                    countList = table.countNumberOfCharacters();
            		break;
            	//単語頭文字出力
            	case 3:
                    countList = table.countNumberOfInitials();
            		break;
                default:
                    break;
            }
            if (countList == null) {
                continue;
            }

            //ソートして出力
            for (String word : countList) {
                int count = table.getCount(word);
                System.out.println(word + "\t" + count);
            }
        }
    }

}