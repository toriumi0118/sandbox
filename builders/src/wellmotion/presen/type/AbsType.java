package wellmotion.presen.type;

import java.io.*;

import wellmotion.presen.*;

public abstract class AbsType extends AbsPresen {
	final public int hWidth = 660;
	final public int hHeight = 495;
	final public int vWidth = 660;
	final public int vHeight = 880;

	private final static String WIDTH = "$width";
	private final static String HEIGHT = "$height";
	private final static String PHOTO = "$photo";
	private final static String PHOTO_TITLE = "$ph_title";
	private final static String PHOTO_TXT = "$ph_txt";

	public AbsType(PresenProperties properties, File officeDir) throws IOException {
		super(properties, officeDir);
	}

	@Override
	protected String getContent(PresenImg[] photos, String photoBase) {
		StringBuilder sb = new StringBuilder();
		String photoPart = null;
		for (PresenImg photo : photos) {
			if (photo.isMain) {
				continue;
			}
			if (photo.isVertical()) {
				photoPart = photoBase.replace(WIDTH, String.valueOf(vWidth));
				photoPart = photoPart.replace(HEIGHT, String.valueOf(vHeight));
			} else {
				photoPart = photoBase.replace(WIDTH, String.valueOf(hWidth));
				photoPart = photoPart.replace(HEIGHT, String.valueOf(hHeight));
			}
			photoPart = photoPart.replace(PHOTO, photo.lowerFileName);
			photoPart = replaceByProperties(photoPart, PHOTO_TITLE, photo.getPropertiesName() + "_title");
			photoPart = replaceByProperties(photoPart, PHOTO_TXT, photo.getPropertiesName() + "_txt", "");
			photoPart = replaceType(photoPart, photo);
			sb.append(photoPart);
		}
		return sb.toString();
	}

	protected String replaceType(String photoPart, PresenImg photo) {
		return photoPart;
	}

	@Override
	protected boolean photoCheck(String photoname) {
		return false;
	}

}
