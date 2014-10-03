package jp.java.test;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

public class Test {

    public static void main(String[] args) throws IOException
    {
    	WordsCounter table = new WordsCounter();
    	BufferedReader inputData = new BufferedReader(new InputStreamReader(System.in));

    	System.out.print("文字列を入力してください：");

        while (true) {
        	String inputString = inputData.readLine();
        	System.out.println(inputString);

        	//英字以外除去＆小文字に変換
        	inputString = inputString.toLowerCase();
            inputString = inputString.replaceAll("[^a-zA-Z]", " ");

            if (inputString == null || inputString.equals(""))
            {
            	System.out.println("文字が入力されていません。");
                break;
            }

            System.out.print("どの形式で出現回数を出力しますか？\n 1:単語  2:アルファベット 3:単語頭文字\n選択:");

            String selectNo = inputData.readLine();
            if(selectNo == null || selectNo.equals(""))
            {
            	System.out.println("出力形式が選択されていません。");
            	break;
            }

            switch(Integer.valueOf(selectNo))
            {
            	//単語出力
            	case 1:
                    for (String word : inputString.split("\\s+"))
                    {
                        if (! word.equals(""))
                        {
                            table.add(word);
                        }
                    }
            		break;

            	//アルファベット出力
            	case 2:
                	for(int count = 0; count < inputString.length(); count++)
                	{
                		char word = inputString.charAt(count);

                		if(word != ' ')
                		{
                			table.add(String.valueOf(word));
                		}
                	}
            		break;

            	//単語頭文字出力
            	case 3:
                    for (String word : inputString.split("\\s+"))
                    {
                        if (! word.equals(""))
                        {
                        	char firstChar = word.charAt(0);
                        	table.add(String.valueOf(firstChar));
                        }
                    }
            		break;
            }

            //ソートして出力
            for (String word : table.getKeysByCount())
            {
                int count = table.get(word);
                System.out.println(word + "\t" + count);
            }
            table.clear();

            break;
        }
    }

}