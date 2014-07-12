package wellmotion.projectbuilder;

import java.io.*;
import java.util.List;

import au.com.bytecode.opencsv.CSVReader;

public class CSVFileReader {

	public static List<String[]> read(File file) {
		InputStreamReader isr = null;
		BufferedReader br = null;
		CSVReader reader = null;
		try {
			isr = new InputStreamReader(new FileInputStream(file), "utf-8");
			br = new BufferedReader(isr);
			reader = new CSVReader(br);
			return reader.readAll();
		} catch (IOException e) {
			throw new IllegalStateException(e);
		} finally {
			close(reader);
			close(br);
			close(isr);
		}
	}

	private static void close(Closeable r) {
		if (r != null) {
			try {
				r.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}
}
