package wellmotion.presen;

import java.io.*;
import java.util.*;
import java.util.regex.Pattern;

public class Env {
	public final File work;
	public final File template;
	public final File output;
	public final File finish;
	public final File log;
	public final File[] offices;
	public final GlobalSetting globalSetting;

	public Env(String workDir, String mode, String today) throws Exception {
		this.work = find(workDir);
		this.template = find(workDir + File.separator + "template");
		this.output = findCreate(workDir + File.separator + "output", today);
		this.finish = findCreate(workDir + File.separator + "finish", today);
		this.log = find(workDir + File.separator + "log");
		this.offices = findGrep(work, "office\\d+");

		Logger.setup(this.log, today);
		rotate(this.output.getParentFile());
		rotate(this.finish.getParentFile());
		rotate(this.log);

		this.globalSetting = new GlobalSetting(workDir, mode);
	}

	public void rotate(File f) {
		File[] fs = f.listFiles();
		Arrays.sort(fs, new Comparator<File>() {
			@Override
			public int compare(File o1, File o2) {
				// 降順
				return o2.getName().compareTo(o1.getName());
			}
		});
		for (int i = 0; i < fs.length; i++) {
			if (i > 5) {
				FileUtil.delete(fs[i]);
			}
		}
	}

	private File[] findGrep(File dir, String r) {
		final Pattern p = Pattern.compile(r);
		return dir.listFiles(new FilenameFilter() {
			@Override
			public boolean accept(File dir, String name) {
				if (dir.isFile()) {
					System.out.printf("'%s' はファイルであるためスキップします。%n", name);
					return false;
				}
				if (p.matcher(name).matches()) {
					return true;
				}
				return false;
			}
		});
	}

	private File find(String p) {
		File f = new File(p);
		if (!f.exists()) {
			throw new IllegalArgumentException("指定された'" + p + "'フォルダが見つかりません。");
		}
		if (f.isFile()) {
			throw new IllegalArgumentException("指定された'" + p + "'はファイルです。");
		}
		return f;
	}

	private File findCreate(String p, String newDir) {
		File f = find(p);
		File newD = new File(f.getPath() + File.separator + newDir);
		if (newD.exists()) {
			FileUtil.delete(newD);
		}
		newD.mkdir();
		return newD;
	}
}
