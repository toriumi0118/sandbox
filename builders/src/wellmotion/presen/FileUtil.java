package wellmotion.presen;

import java.io.*;
import java.nio.channels.FileChannel;

public class FileUtil {
	public static void pour(String path, String content) throws IOException {
		BufferedWriter bw = null;
		try {
			bw = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(path), "UTF-8"));
			bw.write(content);
			bw.flush();
		} finally {
			bw.close();
		}

	}

	public static void delete(File f) {
		if (f.exists() == false) {
			return;
		}

		if (f.isFile()) {
			f.delete();
		}

		if (f.isDirectory()) {
			File[] files = f.listFiles();
			for (int i = 0; i < files.length; i++) {
				delete(files[i]);
			}
			f.delete();
		}
	}

	public static String pullout(String top, String file) throws IOException {
		File f = new File(top + File.separator + file);
		if (!f.exists()) {
			throw new IllegalStateException(f.getPath() + "が存在しません。");
		}
		BufferedReader br = null;
		try {
			br = new BufferedReader(new FileReader(f));
			StringBuilder s = new StringBuilder();
			String line = null;
			while ((line = br.readLine()) != null) {
				s.append(line);
				s.append("\r\n");
			}
			return s.toString();
		} finally {
			br.close();
		}
	}

	public static void copyDirectory(String oldDirName, String newDirName) {
		File rootDir = new File(newDirName);
		if (!rootDir.exists()) {
			System.out.println(newDirName + "            Directory");
			rootDir.mkdirs();
		}
		File[] fileArray = new File(oldDirName).listFiles();
		for (int i = 0; i < fileArray.length; i++) {
			String fileName = fileArray[i].getName();
			if (!".".equals(fileName) && !"..".equals(fileName)) {
				if (!fileArray[i].isDirectory()) {
					copyFile(fileArray[i].getAbsolutePath(), newDirName + File.separator + fileName);
				} else {
					copyDirectory(fileArray[i].getAbsolutePath(), newDirName + File.separator + fileName);
				}
			}
		}
	}

	public static void copyFile(String oldFile, String newFile) {
		System.out.println(newFile + "            File");
		FileChannel ich = null;
		FileChannel och = null;
		try {
			ich = new FileInputStream(new File(oldFile)).getChannel();
			och = new FileOutputStream(new File(newFile)).getChannel();
			ich.transferTo(0, ich.size(), och);
		} catch (FileNotFoundException e) {
		} catch (IOException e) {
		} finally {
			try {
				ich.close();
			} catch (IOException e) {
			}
			try {
				och.close();
			} catch (IOException e) {
			}
		}
	}

}
