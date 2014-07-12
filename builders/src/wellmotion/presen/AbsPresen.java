package wellmotion.presen;

import java.io.*;
import java.sql.SQLException;
import java.util.*;
import java.util.regex.Pattern;

import wellmotion.presen.PresenProperties.TEMPLATE_TYPE;

public abstract class AbsPresen {
	private static final String TEMPLATE_DIR = "template";
	private static final String PRESENTATION_DIR = "presentation";
	private static final String IMG_DIR = "img";
	private static final String CSS_DIR = "css";
	private static final String JS_DIR = "js";

	// key
	private static final String OFFICENAME = "$officename";
	private static final String MAINPHOTO = "$main_ph";
	private static final String MAINTXT = "$main_txt";
	private static final String CONTENT = "$content";

	private final int officeId;
	private final PresenImg[] photos;
	private final PresenProperties properties;

	private static final Pattern photoPattern = Pattern.compile("ph\\d{1,2}.png", Pattern.CASE_INSENSITIVE);
	private static final Pattern mainPattern = Pattern.compile("main.png", Pattern.CASE_INSENSITIVE);

	public AbsPresen(PresenProperties properties, File officeDir) throws IOException {
		this.officeId = Integer.parseInt(officeDir.getName().substring("office".length()));
		this.properties = properties;
		this.photos = loadPhotos(officeDir);
	}

	private PresenImg[] loadPhotos(File officeDir) throws IOException {
		ArrayList<PresenImg> imgs = new ArrayList<PresenImg>();
		File[] fs = officeDir.listFiles();
		Arrays.sort(fs, new Comparator<File>() {
			@Override
			public int compare(File o1, File o2) {
				return o1.getName().compareTo(o2.getName());
			}
		});
		for (File f : officeDir.listFiles()) {
			String name = f.getName();
			if (photoPattern.matcher(name).matches()) {
				imgs.add(ImgUtil.getPresenImg(f));
			}
			if (mainPattern.matcher(name).matches()) {
				imgs.add(ImgUtil.getPresenImg(f));
			}
		}
		return imgs.toArray(new PresenImg[0]);
	}

	public boolean validate() throws IOException {
		boolean hasError = false;
		hasError = containCheck("office_name") || hasError;
		hasError = containCheck("main_ph") || hasError;
		for (PresenImg p : photos) {
			if (p.lowerFileName.equals(properties.getProperty("main_ph"))) {
				p.isMain();
				continue;
			}
			String n = p.getPropertiesName();
			hasError = containCheck(n + "_title") || hasError;
			hasError = photoCheck(n) || hasError;
		}
		return !hasError;
	}

	protected abstract boolean photoCheck(String photoname);

	protected boolean containCheck(String s) {
		if (!properties.containsKey(s)) {
			Logger.writeOffice(this.officeId, String.format("'%s'の設定がsetting.txtに記載されていません。", s));
			return true;
		}
		return false;
	}

	public void apply(File template, File officeDir, File output) throws IOException {
		File temp = findTemplate(template);
		String localTemp = officeDir.getPath() + File.separator + TEMPLATE_DIR;
		FileUtil.copyDirectory(temp.getPath(), localTemp);

		String base = createFullHtm(localTemp);

		String dstPresen = output.getPath() + File.separator + officeDir.getName() + File.separator + PRESENTATION_DIR;
		copyRelatedFiles(officeDir, dstPresen, localTemp);

		FileUtil.pour(dstPresen + File.separator + "index.htm", base);

		FileUtil.delete(new File(localTemp));
	}

	private void copyRelatedFiles(File officeDir, String dstPresen, String localTemp) {
		FileUtil.copyDirectory(localTemp + File.separator + IMG_DIR, dstPresen + File.separator + IMG_DIR);
		FileUtil.copyDirectory(localTemp + File.separator + CSS_DIR, dstPresen + File.separator + CSS_DIR);
		if (new File(localTemp + File.separator + JS_DIR).exists()) {
			FileUtil.copyDirectory(localTemp + File.separator + JS_DIR, dstPresen + File.separator + JS_DIR);
		}
		for (PresenImg photo : photos) {
			FileUtil.copyFile(officeDir.getPath() + File.separator + photo.originalFileName, dstPresen + File.separator
					+ IMG_DIR + File.separator + photo.lowerFileName);
		}
	}

	private String createFullHtm(String localTemp) throws IOException {
		String base = FileUtil.pullout(localTemp, "index_base.htm");
		base = replaceByProperties(base, OFFICENAME, "office_name");
		base = replaceByProperties(base, MAINPHOTO, "main_ph");
		base = replaceByProperties(base, MAINTXT, "main_txt", "");

		String photoBase = FileUtil.pullout(localTemp, "photo.htm");
		base = base.replace(CONTENT, getContent(this.photos, photoBase));
		base = base.replace("\r\n", "\n");
		return base;
	}

	protected abstract String getContent(PresenImg[] photos, String photoBase);

	protected String replaceByProperties(String base, String from, String to, String def, String format) {
		String pro = properties.getProperty(to, def);
		if (pro == null) {
			return replaceByProperties(base, from, to, "");
		}
		return base.replace(from, String.format(format, pro));
	}

	protected String replaceByProperties(String base, String from, String to, String def) {
		return base.replace(from, properties.getProperty(to, def));
	}

	protected String replaceByProperties(String base, String from, String to) {
		return base.replace(from, properties.getProperty(to));
	}

	private File findTemplate(File template) {
		TEMPLATE_TYPE type = properties.getTemplateType();
		if (type == TEMPLATE_TYPE.NOTSET) {
			Logger.writeOffice(officeId, "setting.txtのtemplateを見直してください。");
			throw new IllegalStateException();
		}
		File temp = new File(template.getPath() + File.separator + "type" + type);
		if (!temp.exists()) {
			throw new IllegalStateException("テンプレート" + type + "が存在しません。");
		}
		return temp;
	}

	public void transport(File output, PresenFTP ftp, DB db) throws SQLException, IOException {
		ftp.transportAll(officeId, output);
		db.insertHistory(this.officeId);
	}

	public void clean(File finish, File office) {
		FileUtil.copyDirectory(office.getPath(), finish.getPath() + File.separator + office.getName());
		FileUtil.delete(office);
	}

	public void ok() {
		Logger.writeOffice(officeId, "SUCCEED.");
	}

	public void ng() {
		Logger.writeOffice(officeId, "FAILED.");
	}
}
