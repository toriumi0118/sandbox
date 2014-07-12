package wellmotion.projectbuilder;

import java.io.*;
import java.util.*;
import java.util.regex.*;

import javax.xml.parsers.*;

import org.w3c.dom.*;
import org.xml.sax.SAXException;

public class Dao {
	private static final String CREATE_TABLE_REGEX = "CREATE\\s+TABLE\\s+(\\w*\\s+)*(\\w+)\\s+\\(";
	private static final int TABLE_NAME_INDEX_OF_REGEX = 2;
	private static final Pattern CREATE_PATTERN;

	static {
		// 大文字小文字を区別しないため、第二引数にCASE_INSENSITIVEを付与。
		CREATE_PATTERN = Pattern.compile(CREATE_TABLE_REGEX, Pattern.CASE_INSENSITIVE);
	}

	public static void buildTables(BuilderConnection bc, String createDirPath, boolean rebuild, boolean sqlite) throws IllegalStateException {
		if (createDirPath == null) {
			throw new IllegalStateException();
		}
		File[] createSqls = getExecutable(createDirPath);
		try {
			for (File createSql : createSqls) {
				System.out.printf("Create SQL file name is : %s (%s) %n", createSql.getCanonicalPath(), createSql.getName());
				buildTable(bc, createSql, rebuild, sqlite);
			}
		} catch (IOException e) {
			throw new IllegalStateException(e);
		}
	}

	private static void buildTable(BuilderConnection bc, File createSql, boolean rebuild, boolean sqlite) {
		ArrayList<String> sqls = getSQLs(createSql);
		for (String sql : sqls) {
			if (rebuild && sql.indexOf("CREATE") != -1) {
				bc.execSQL(generateDropFromCreate(sql));
			}
			if (sqlite && sql.contains("AUTOINCREMENT")) {
				System.out.println(String.format("[[WARN]] AUTOINCREMENTの記載があるのでAUTO_INCREMENTに変更します。"));
				sql = sql.replaceAll("AUTOINCREMENT", "AUTO_INCREMENT");
			}
			bc.execSQL(sql);
		}
	}

	private static ArrayList<String> getSQLs(File sql) {
		ArrayList<String> sqls = new ArrayList<String>();
		InputStream is = getInputStream(sql);
		Document doc = getDoc(is);
		NodeList nodeList = doc.getElementsByTagName("sql");
		for (int i = 0; i < nodeList.getLength(); i++) {
			Element e = (Element)nodeList.item(i);
			if (!e.getAttribute("exec_on_db_build").isEmpty() && !Boolean.valueOf(e.getAttribute("exec_on_db_build"))) {
				continue;
			}
			sqls.add(e.getTextContent());
		}
		return sqls;
	}

	private static String generateDropFromCreate(String createSentence) {
		if (createSentence == null) {
			throw new IllegalArgumentException();
		}
		String tableName = getTableNameFromCreate(createSentence);
		StringBuilder sb = new StringBuilder();
		sb.append("DROP");
		sb.append(" TABLE ");
		sb.append(" IF EXISTS ");
		sb.append(tableName);
		sb.append(" ;");
		return sb.toString();
	}

	private static String getTableNameFromCreate(String createSentence) {
		Matcher m = CREATE_PATTERN.matcher(createSentence);
		if (m.find()) {
			System.out.println(String.format("対象テーブル : %s", m.group(TABLE_NAME_INDEX_OF_REGEX)));
			return m.group(TABLE_NAME_INDEX_OF_REGEX);
		} else {
			throw new IllegalStateException(String.format("正規表現'%s'に一致しません。", CREATE_TABLE_REGEX));
		}
	}

	private static Document getDoc(InputStream is) {
		try {
			return DocumentBuilderFactory.newInstance().newDocumentBuilder().parse(is);
		} catch (SAXException e) {
			throw new IllegalStateException(e);
		} catch (IOException e) {
			throw new IllegalStateException(e);
		} catch (ParserConfigurationException e) {
			throw new IllegalStateException(e);
		}
	}

	private static InputStream getInputStream(File file) {
		try {
			return new BufferedInputStream(new FileInputStream(file));
		} catch (FileNotFoundException e) {
			throw new IllegalStateException(e);
		}
	}

	public static void insertData(BuilderConnection bc, String dataDirPath) throws IllegalStateException {
		if (dataDirPath == null) {
			throw new IllegalStateException();
		}
		File[] dataSqls = getExecutable(dataDirPath);
		try {
			for (File dataSql : dataSqls) {
				System.out.printf("Data SQL file name is : %s %n", dataSql.getCanonicalPath());
				insert(bc, dataSql);
			}
		} catch (IOException e) {
			throw new IllegalStateException(e);
		}
	}

	public static void insertDataAll(BuilderConnection bc, String parentDirPath, final String dataDirPath) {
		File parent = new File(parentDirPath);
		if (!parent.exists() || !parent.isDirectory()) {
			throw new IllegalStateException();
		}
		File[] childDir = parent.listFiles(new FileFilter() {
			@Override
			public boolean accept(File pathname) {
				String name = pathname.getName();
				if (name.startsWith(dataDirPath)) {
					return true;
				}
				return false;
			}
		});
		for (File child : childDir) {
			insertData(bc, child.getPath());
		}
	}

	/**
	 * フォルダ内のファイルをArray<File>として返す。
	 * dirPathの中身が空なら、空のarrayが返る。
	 * IOエラーの場合はnullが返る。
	 * @param dirPath
	 * @return
	 */
	private static File[] getExecutable(final String dirPath) {
		File dir = new File(dirPath);
		if (dir.isFile()) {
			throw new IllegalStateException();
		}
		if (!dir.exists()) {
			System.out.println(String.format("[[WARN]] %s フォルダは存在しません。", dirPath));
			return new File[] {};
		}

		File[] fileList = dir.listFiles(new FileFilter() {
			@Override
			public boolean accept(File file) {
				if (file.getName().endsWith("gitkeeper")) {
					System.out.println("skip gitkeeper file in " + dirPath);
					return false;
				}
				if (file.isFile()) {
					return true;
				}
				return false;
			}
		});
		if (fileList == null || fileList.length == 0) {
			System.out.println(String.format("[[WARN]] %s フォルダの中身が空です。", dirPath));
		}
		Arrays.sort(fileList);
		return fileList;
	}

	private static void insert(BuilderConnection bc, File dataSql) {
		List<String[]> csv = CSVFileReader.read(dataSql);
		String[] heads = csv.get(0);
		for (int i = 1; i < csv.size(); i++) {
			String tableName = dataSql.getName().split("_", 3)[2].replaceAll("\\.dat", "");
			System.out.println(String.format("対象テーブル : %s @ %d", tableName, i));
			String[] line = csv.get(i);
			Map<String, String> values = createValues(heads, line);
			bc.insert(tableName, values);
		}
	}

	private static Map<String, String> createValues(String[] heads, String[] line) {
		Map<String, String> values = new HashMap<String, String>();
		for (int i = 0; i < heads.length; i++) {
			if (line[i].isEmpty()) {
				continue;
			}
			values.put(heads[i], line[i]);
		}
		return values;
	}

}
