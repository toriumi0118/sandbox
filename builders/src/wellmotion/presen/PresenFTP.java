package wellmotion.presen;

import java.io.*;

import org.apache.commons.vfs2.*;
import org.apache.commons.vfs2.impl.StandardFileSystemManager;
import org.apache.commons.vfs2.provider.sftp.SftpFileSystemConfigBuilder;

public class PresenFTP {
	private final String postDir;
	private final StandardFileSystemManager manager;
	private final FileSystemOptions opt;
	private final String fileHost;
	private final String filePort;
	private final String fileUser;
	private final String filePass;

	public PresenFTP(GlobalSetting globalSetting) throws IOException {
		this.manager = new StandardFileSystemManager();
		manager.init();
		this.opt = createDefaultOptions();
		this.postDir = globalSetting.getProperty(GlobalSetting.FILEPOSTDIR_KEY);
		this.fileHost = globalSetting.getProperty(GlobalSetting.FILEHOST_KEY);
		this.filePort = globalSetting.getProperty(GlobalSetting.FILEPORT_KEY);
		this.fileUser = globalSetting.getProperty(GlobalSetting.FILEUSER_KEY);
		this.filePass = globalSetting.getProperty(GlobalSetting.FILEPASS_KEY);
	}

	public static FileSystemOptions createDefaultOptions() throws FileSystemException {
		FileSystemOptions opts = new FileSystemOptions();
		// SSH Key checking
		SftpFileSystemConfigBuilder.getInstance().setStrictHostKeyChecking(opts, "no");
		SftpFileSystemConfigBuilder.getInstance().setUserDirIsRoot(opts, false);
		return opts;
	}

	public static String createConnectionString(String host, String port, String user, String pass, String remotePath) {
		// result: "sftp://wellmotion:we11motion@192.168.1.1/home/....
		return "sftp://" + user + ":" + pass + "@" + host + ":" + port + remotePath;

	}

	public void transportAll(int officeId, File output) throws IOException {
		FileObject local = null;
		FileObject remote = null;
		try {
			for (File office : output.listFiles()) {
				local = manager.resolveFile(office.getAbsoluteFile() + File.separator + "presentation");
				remote = manager.resolveFile(
						createConnectionString(fileHost, filePort, fileUser, filePass,
								this.postDir + "/" + office.getName() + "/presentation"), opt);
				remote.delete(Selectors.SELECT_ALL);
				remote.copyFrom(local, Selectors.SELECT_ALL);
			}
		} finally {
			if (local != null) {
				local.close();
			}
			if (remote != null) {
				remote.close();
			}
		}

	}

	public void close() {
		this.manager.close();
	}
}
