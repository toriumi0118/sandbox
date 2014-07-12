package wellmotion.projectbuilder;

import java.io.*;

public class FlashBacker {
	private final Argument arg;
	private final String cmd;
	private final String cmdArg;

	public FlashBacker(Argument arg) {
		this.arg = arg;
		if (System.getProperty("os.name").startsWith("Windows")) {
			this.cmd = "cmd.exe";
			this.cmdArg = "/c";
		} else {
			this.cmd = "/bin/sh";
			this.cmdArg = "-c";
		}
	}

	private static final String DUMP_FILE_NAME = "all.dump";

	public void saveCurrentStatus() {
		try {
			ProcessBuilder pb = new ProcessBuilder("mysqldump", "-u", arg.get(Argument.DBUSER_OPTION), "-p"
					+ arg.get(Argument.DBPASS_OPTION), arg.get(Argument.DBNAME_OPTION));
			Process p = pb.start();
			InputStream is = p.getInputStream();
			outputToFile(is);
			p.waitFor();
		} catch (IOException e) {
			throw new RuntimeException(e);
		} catch (InterruptedException e) {
			throw new RuntimeException(e);
		}
	}

	private void outputToFile(InputStream is) throws IOException {
		BufferedReader br = new BufferedReader(new InputStreamReader(is));
		BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(new File(DUMP_FILE_NAME))));
		try {
			for (;;) {
				String line = br.readLine();
				if (line == null)
					break;
				bw.write(line);
				bw.newLine();
				System.out.println(line);
			}
		} finally {
			bw.close();
			br.close();
		}
	}

	private void printInputStream(InputStream is) throws IOException {
		BufferedReader br = new BufferedReader(new InputStreamReader(is));
		try {
			for (;;) {
				String line = br.readLine();
				if (line == null)
					break;
				System.out.println(line);
			}
		} finally {
			br.close();
		}
	}

	public void restoreStatus() {
		try {
			// ProcessBuilderは入出力をJava側で持ってしまい利用できないため、cmd経由で呼ぶ。
			ProcessBuilder pb = new ProcessBuilder(this.cmd, this.cmdArg, "mysql -u " + arg.get(Argument.DBUSER_OPTION)
					+ " -p" + arg.get(Argument.DBPASS_OPTION) + " " + arg.get(Argument.DBNAME_OPTION) + " < "
					+ DUMP_FILE_NAME);
			pb.redirectErrorStream(true);
			Process p = pb.start();
			InputStream is = p.getInputStream();
			printInputStream(is);
			p.waitFor();
		} catch (IOException e) {
			throw new RuntimeException(e);
		} catch (InterruptedException e) {
			throw new RuntimeException(e);
		}

	}

	public void cleanup() {
		File f = new File(DUMP_FILE_NAME);
		if (!f.exists()) {
			throw new IllegalStateException();
		}
		f.delete();
	}

	//	public void dumpTable() {
	//		HashSet<String> tables = arg.getFlashBackTables();
	//		for (String table : tables) {
	//			try {
	//				ProcessBuilder pb = new ProcessBuilder(this.cmd, this.cmdArg, "mysqldump", "-u",
	//						arg.get(Argument.DBUSER_OPTION), "-p" + arg.get(Argument.DBPASS_OPTION), "-t",
	//						arg.get(Argument.DBNAME_OPTION), table, ">", table + ".dump");
	//				pb.redirectErrorStream(true);
	//				Process p = pb.start();
	//				InputStream is = p.getInputStream();
	//				printInputStream(is);
	//				p.waitFor();
	//			} catch (IOException e) {
	//				throw new RuntimeException(e);
	//			} catch (InterruptedException e) {
	//				throw new RuntimeException(e);
	//			}
	//		}
	//	}
	//
	//	public void restoreTable() {
	//		HashSet<String> tables = arg.getFlashBackTables();
	//		for (String table : tables) {
	//			try {
	//				// ProcessBuilderは入出力をJava側で持ってしまい利用できないため、cmd経由で呼ぶ。
	//				ProcessBuilder pb = new ProcessBuilder(this.cmd, this.cmdArg, "mysql", "-u", arg.get(Argument.DBUSER_OPTION),
	//						"-p" + arg.get(Argument.DBPASS_OPTION), arg.get(Argument.DBNAME_OPTION), "<", table + ".dump");
	//				pb.redirectErrorStream(true);
	//				Process p = pb.start();
	//				TimerTask task = new ProcessDestroyer(p);
	//				Timer timer = new Timer("プロセス停止タイマー");
	//				timer.schedule(task, TimeUnit.SECONDS.toMillis(5)); //3秒後にProcessDestroyer#run()が呼ばれる
	//
	//				for (;;) {
	//					p.waitFor(); //プロセスの終了待ち
	//					break;
	//				}
	//				timer.cancel();
	//				if (p.exitValue() != 0) {
	//					throw new IllegalStateException("table : " + table + " のrestoreに失敗しました。");
	//				}
	//			} catch (IOException e) {
	//				throw new RuntimeException(e);
	//			} catch (InterruptedException e) {
	//				throw new RuntimeException(e);
	//			}
	//		}
	//	}
}
