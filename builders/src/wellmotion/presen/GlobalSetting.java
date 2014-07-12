package wellmotion.presen;

import java.io.*;
import java.util.Properties;

public class GlobalSetting extends Properties {
	private static final long serialVersionUID = -1864194331302651158L;
	public static final String SENDSERVER_KEY = "sendserver";
	public static final String DBHOST_KEY = "dbhost";
	public static final String DBNAME_KEY = "dbname";
	public static final String DBUSER_KEY = "dbuser";
	public static final String DBPASS_KEY = "dbpass";

	public static final String FILEHOST_KEY = "filehost";
	public static final String FILEPORT_KEY = "fileport";
	public static final String FILEUSER_KEY = "fileuser";
	public static final String FILEPASS_KEY = "filepass";
	public static final String FILEPOSTDIR_KEY = "filepostdir";

	private final String mode;

	public GlobalSetting(String workDir, String mode) throws IOException {
		InputStream is = new BufferedInputStream(new FileInputStream(workDir + File.separator + "globalsetting.txt"));
		this.load(is);
		is.close();
		this.mode = mode;
	}

	public boolean sendToServer() {
		Object obj = super.get(SENDSERVER_KEY);
		return Boolean.valueOf(obj == null ? "false" : obj.toString());
	}

	@Override
	public String getProperty(String key) {
		return super.getProperty(mode.length() == 0 ? key : mode + "." + key);
	}
}
