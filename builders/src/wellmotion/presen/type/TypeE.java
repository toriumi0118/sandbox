package wellmotion.presen.type;

import java.io.*;

import wellmotion.presen.*;

public class TypeE extends AbsType {
	private static final String DIRECTION = "$direction";

	public TypeE(PresenProperties properties, File officeDir) throws IOException {
		super(properties, officeDir);
	}

	@Override
	protected String replaceType(String photoPart, PresenImg photo) {
		return replaceByProperties(photoPart, DIRECTION, photo.getPropertiesName() + "_direction");
	}

	@Override
	protected boolean photoCheck(String photoname) {
		return containCheck(photoname + "_direction");
	}
}
