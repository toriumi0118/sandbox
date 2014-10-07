import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;


public class CSVFileRead {

	private final static String inputCsvFile = "C:\\Users\\Sagehari Maiko\\Documents\\11_home_care.csv";	//パス変える
	private final static String outputCsvFile = "C:\\Users\\Sagehari Maiko\\Documents\\11_out_home_care.py";	//パス変える
	private final static String type1 = ".innerHTML";
	private final static String type2 = "\".attr(\"\"href\"\")\"";
	private final static String type3 = "\".attr(\"\"alt\"\")\"";
	
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
			out.write("import scrapy");
			out.newLine();
			out.write("from scraper.util import *");
			out.newLine();
			out.write("from scraper.items import HoumonItem");
			out.newLine();
			out.write("from scrapy.contrib.spiders import CrawlSpider, Rule");
			out.newLine();
			out.write("from bs4 import BeautifulSoup");
			out.newLine();
			out.write("class BasicSpider(CrawlSpider):");
			out.newLine();
			out.newLine();
			out.write("	name = \"basicSpider\"");
			out.newLine();
			out.write("	allowed_domains = [\"kaigokensaku.jp\"]");
			out.newLine();
			out.write("	start_urls = getStartUrls(110)");
			out.newLine();
			out.newLine();
			out.write("	def parse(self, response):");
			out.newLine();
			out.write("		tree = BeautifulSoup(response.body)");
			out.newLine();
			out.write("		item = HoumonItem()");
			out.newLine();
			out.newLine();

			/** １行ずつ読み込み */
			while ((line = in.readLine()) != null){
				//区切り文字カンマ[,]で、区切られた文字列を配列に格納する
				csvArray = line.split("\\,");
				count++;
				if(count > 5 && csvArray.length >= 10){
					if(type1.equals(csvArray[9])){
						out.write("		item['" + csvArray[1] + "'] = " + "getTextById(tree," + csvArray[8] + ")");
					}else if(type2.equals(csvArray[9])){
						out.write("		item['" + csvArray[1] + "'] = " + "getAttributeValueById(tree," + csvArray[8] + ",\"href\")");
					}else if(type3.equals(csvArray[9])){
						out.write("		item['" + csvArray[1] + "'] = " + "getAttributeValueById(tree," + csvArray[8] + ",\"alt\")");
					}
					//改行する
					out.newLine();
				}
			}
			out.newLine();
			out.write(" yield item");
			out.newLine();
			
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
