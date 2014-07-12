package wellmotion.projectbuilder;

import java.io.*;
import java.util.*;

public class DbBuilder {
	private static final int RESULT_OK = 0;
	private static final int RESULT_NG = 1;

	private static final String EVEREST_PREFIX = "everest_";

	private static final String SQL_DIR = "sql";
	private static final String SQL_ANDROID_DIR = SQL_DIR + File.separator + "android";
	private static final String SQL_SERVER_DIR = SQL_DIR + File.separator + "server";
	private static final String SQL_SERVER_SHARE_DIR = SQL_DIR + File.separator + "server_share";

	private static final String DATA_DIR = "data";
	private static final String DATA_SERVER_DIR = DATA_DIR + File.separator + "server";
	private static final String DATA_USR_DATA = "usr_data";

	private static boolean showSQL = true;

	public static void main(String[] args) {
		if (new DbBuilder().buildDb(args)) {
			System.exit(RESULT_OK);
		}
		System.exit(RESULT_NG);
	}

	private boolean buildDb(String[] args) {
		BuilderConnection bc = null;
		Argument arg = new Argument(args);
		FlashBacker fb = new FlashBacker(arg);
		try {
			fb.saveCurrentStatus();
			bc = new BuilderConnection(arg, showSQL);
			this.pileVersions(bc, arg.get(Argument.VERSION_DIR_OPTION), arg.getTargetVers(EVEREST_PREFIX),
					arg.getReqUsrData(), arg.getRebuildFlg(), fb);
			bc.commit();
			return true;
		} catch (Exception e) {
			if (bc != null) {
				bc.rollback();
				System.out.println("rollbackしました。");
			}
			fb.restoreStatus();
			System.out.println("リストアを行い、dbを実行前の状態に戻しました。");
			e.printStackTrace();
			return false;
		} finally {
			if (bc != null) {
				bc.close();
			}
		}
	}

	private void pileVersions(BuilderConnection bc, String versionDir, HashSet<String> targetVers, boolean reqUsrData,
			boolean rebuild, FlashBacker fb) {
		File[] versionDirs = getVersionDirs(versionDir, targetVers);
		for (File version : versionDirs) {
			this.buildVersionDb(bc, version, reqUsrData, rebuild, fb);
		}
	}

	private void buildVersionDb(BuilderConnection bc, File version, boolean reqUsrData, boolean rebuild, FlashBacker fb) {
		if (version.getName().endsWith("0001")) {
			execute(bc, version, reqUsrData, rebuild);
		} else {
			//			fb.dumpTable();
			execute(bc, version, reqUsrData, rebuild);
			//			fb.restoreTable();
		}
	}

	private void execute(BuilderConnection bc, File version, boolean reqUsrData, boolean rebuild) {
		Dao.buildTables(bc, version.getPath() + File.separator + SQL_ANDROID_DIR, rebuild, true);
		Dao.buildTables(bc, version.getPath() + File.separator + SQL_SERVER_DIR, rebuild, false);
		Dao.buildTables(bc, version.getPath() + File.separator + SQL_SERVER_SHARE_DIR, rebuild, false);
		Dao.insertData(bc, version.getPath() + File.separator + DATA_DIR);
		Dao.insertData(bc, version.getPath() + File.separator + DATA_SERVER_DIR);
		if (reqUsrData) {
			Dao.insertDataAll(bc, version.getPath(), DATA_USR_DATA);
		}
	}

	private File[] getVersionDirs(String versionDir, final HashSet<String> targetVers) {
		File dir = new File(versionDir);
		if (dir.isFile()) {
			throw new IllegalStateException();
		}

		File[] versionDirs = dir.listFiles(new FileFilter() {
			@Override
			public boolean accept(File file) {
				if (file.isFile()) {
					return false;
				}
				if (targetVers.contains(file.getName())) {
					return true;
				}
				return false;
			}
		});
		Arrays.sort(versionDirs);
		return versionDirs;
	}

}
