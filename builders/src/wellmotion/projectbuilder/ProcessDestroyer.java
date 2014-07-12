package wellmotion.projectbuilder;

import java.util.TimerTask;

public class ProcessDestroyer extends TimerTask {

	private final Process p;

	public ProcessDestroyer(Process p) {
		this.p = p;
	}

	@Override
	public void run() {
		p.destroy(); //プロセスを強制終了
	}
}