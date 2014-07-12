package wellmotion.projectbuilder;

import java.util.*;

public class Argument extends HashMap<String, String> {
	private static final long serialVersionUID = -6430914195715612793L;
	public static final String TARGET_VER_OPTION = "--target-ver";
	public static final String VERSION_DIR_OPTION = "--version-dir";
	public static final String REQ_USR_DATA_OPTION = "--req-usr-data";
	public static final String REBUILD_OPTION = "--rebuild";

	static final String DBHOST_OPTION = "--dbhost";
	static final String DBNAME_OPTION = "--dbname";
	static final String DBUSER_OPTION = "--dbuser";
	static final String DBPASS_OPTION = "--dbpass";

	public Argument(String[] args) {
		for (int i = 0; i < args.length; i++) {
			putArg(args, i, REQ_USR_DATA_OPTION, this, "false");
			putArg(args, i, REBUILD_OPTION, this, "false");
			putValidArg(args, i, TARGET_VER_OPTION, this);
			putValidArg(args, i, VERSION_DIR_OPTION, this);
			putValidArg(args, i, DBHOST_OPTION, this);
			putValidArg(args, i, DBNAME_OPTION, this);
			putValidArg(args, i, DBUSER_OPTION, this);
			putValidArg(args, i, DBPASS_OPTION, this);
		}
		if (this.size() < 6) {
			throw new IllegalArgumentException("引数が足りません");
		}
	}

	/** 必須ではない引数 */
	private void putArg(String[] args, int index, String option, Argument validArgs, String defValue) {
		putValidArg(args, index, option, validArgs);
		String v = validArgs.get(option);
		if (v == null) {
			validArgs.put(option, defValue);
		}
	}

	/** 必須である引数 */
	private void putValidArg(String[] args, int index, String option, Map<String, String> validArgs) {
		String arg = args[index];
		if (arg.equals(option)) {
			try {
				String value = args[++index];
				if (value.startsWith("--")) {
					throw new IllegalArgumentException("引数 : " + option + " の値が不足しています。");
				}
				System.out.printf("%s : %s %n", option, value);
				validArgs.put(option, value.trim());
			} catch (ArrayIndexOutOfBoundsException e) {
				throw new IllegalArgumentException();
			}
		}
	}

	public HashSet<String> getTargetVers(String pref) {
		return spliter(TARGET_VER_OPTION, pref);
	}

	public boolean getReqUsrData() {
		return Boolean.valueOf(this.get(REQ_USR_DATA_OPTION));
	}

	public boolean getRebuildFlg() {
		return Boolean.valueOf(this.get(REBUILD_OPTION));
	}

	private HashSet<String> spliter(String option, String pref) {
		String optionValue = this.get(option);
		String[] splited = optionValue.split(",");
		HashSet<String> res = new HashSet<String>();
		for (String val : splited) {
			res.add(pref + val.trim());
		}
		return res;

	}
}
