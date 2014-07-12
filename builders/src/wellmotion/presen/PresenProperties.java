package wellmotion.presen;

import java.io.*;
import java.util.Properties;

public class PresenProperties extends Properties {
	private static final long serialVersionUID = 1L;

	private final static String SETTING_FILE_NAME = "setting.txt";

	// keys
	private final static String TEMPLATE = "template";

	public enum TEMPLATE_TYPE {
		A, B, C, D, E, F, G, H, I, J, K, NOTSET
	};

	public PresenProperties(File officeDir) throws IOException {
		InputStreamReader is = new InputStreamReader(new BufferedInputStream(new FileInputStream(officeDir.getPath()
				+ File.separator + SETTING_FILE_NAME)), "utf-8");
		load(is);
		is.close();
	}

	public TEMPLATE_TYPE getTemplateType() {
		return TEMPLATE_TYPE.valueOf(this.getProperty(TEMPLATE, "NOTSET"));
	}
}
