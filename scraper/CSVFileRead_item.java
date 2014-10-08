import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;


public class CSVFileRead {

	private final static String inputCsvFile = "C:\\Users\\Sagehari Maiko\\Documents\\11_home_care.csv";	//パス変える
	private final static String outputCsvFile = "C:\\Users\\Sagehari Maiko\\Documents\\11_home_care_items.py";	//パス変える
	
	public static void main(String[] args) {
		String line;
		String[] csvArray;
		File inputFile = new File(inputCsvFile);
		File outputFile = new File(outputCsvFile);
		BufferedReader in = null;
		BufferedWriter out = null;
		int count = 0;
	try {
			in = new BufferedReader(new FileReader(inputFile));
			out = new BufferedWriter(new FileWriter(outputFile));
			
			out.write("# -*- coding: utf-8 -*-");
			out.newLine();
			out.newLine();
			out.write("# Define here the models for your scraped items");
			out.newLine();
			out.write("#");
			out.newLine();
			out.write("# See documentation in:");
			out.newLine();
			out.write("# http://doc.scrapy.org/en/latest/topics/items.html");
			out.newLine();
			out.newLine();
			out.write("import scrapy");
			out.newLine();
			out.newLine();
			out.write("class HoumonItem(scrapy.Item):");
			out.newLine();
			out.newLine();

			/** １行ずつ読み込み */
			while ((line = in.readLine()) != null){
				//区切り文字カンマ[,]で、区切られた文字列を配列に格納する
				csvArray = line.split("\\,");
				count++;
				if(count > 5 && csvArray.length >= 10){
					out.write("	 " + csvArray[1] + " = scrapy.Field()");
					//改行する
					out.newLine();
				}
			}
			
		}catch(FileNotFoundException e){
			e.printStackTrace();
		}catch(IOException e){
			e.printStackTrace();
		}finally{
			try{
				if (in != null){
					in.close();
				}
				if(out != null){
					out.close();
				}
			}catch(IOException e){
				System.out.println("close fail");
				e.printStackTrace();
			}
		}
	}

}
