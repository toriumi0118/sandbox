package wellmotion.presen.type;

import java.io.*;

import wellmotion.presen.*;

public class TypeI extends AbsType {
	private static final String DIRECTION = "$direction";
	private static final String LENGTH = "$length";

	public TypeI(PresenProperties properties, File officeDir) throws IOException {
		super(properties, officeDir);
	}

	@Override
	protected String replaceType(String photoPart, PresenImg photo) {
		photoPart = replaceByProperties(photoPart, DIRECTION, photo.getPropertiesName() + "_direction");
		return replaceByProperties(photoPart, LENGTH, photo.getPropertiesName() + "_length");
	}

	@Override
	protected boolean photoCheck(String photoname) {
		boolean b = false;
		b = containCheck(photoname + "_direction") || b;
		b = containCheck(photoname + "_length") || b;
		return b;
	}
}
