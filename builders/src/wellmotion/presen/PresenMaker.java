package wellmotion.presen;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;

public class PresenMaker {
	private static final int NORMAL_END = 0;
	private static final int ERROR_END = -1;

	public static void main(String[] args) {
		// 0は作業フォルダ
		// 1はcentralserver/data/officeのpath
		System.exit(new PresenMaker().exec(args));
	}

	private int exec(String[] args) {
		SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd-HHmmss");
		String today = df.format(new Date());
		System.out.println(">> start!! @ " + today);
		if (args.length < 1) {
			System.out.println("作業フォルダ[0]を指定してください。");
			return ERROR_END;
		}
		DB db = null;
		PresenFTP ftp = null;
		try {
			Env env = new Env(args[0], args.length >= 2 ? args[1] : "", today);
			db = new DB(env.globalSetting);
			ftp = new PresenFTP(env.globalSetting);

			for (File officeDir : env.offices) {
				AbsPresen p = PresenFactory.make(officeDir);
				try {
					p = PresenFactory.make(officeDir);
					if (p == null) {
						Logger.write(officeDir.getPath() + "フォルダはテンプレートの確立ができなかったため飛ばします。");
						continue;
					}
					if (!p.validate()) {
						Logger.write(officeDir.getPath() + "フォルダの設定が正しくないため飛ばします。");
						continue;
					}
					p.apply(env.template, officeDir, env.output);
					if (env.globalSetting.sendToServer()) {
						p.transport(env.output, ftp, db);
						p.clean(env.finish, officeDir);
					}
					p.ok();
					db.commit();
				} catch (Exception e) {
					e.printStackTrace();
					db.rollback();
					p.ng();
				}
			}
			db.commit();
			return NORMAL_END;
		} catch (Exception e) {
			e.printStackTrace();
			if (db != null) {
				db.rollback();
			}
			return ERROR_END;
		} finally {
			if (ftp != null) {
				ftp.close();
			}
			if (db != null) {
				db.close();
			}
			Logger.output(System.out);
			Logger.close();
			System.out.println(">> finish!!");
		}
	}
}
