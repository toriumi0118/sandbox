package wellmotion.presen.type;

import java.io.*;

import wellmotion.presen.*;

public class TypeC extends AbsType {
	private static final String DIRECTION = "$direction";
	private static final String BACKCOLOR = "$backcolor";
	private static final String BACKIMG = "$backimg";

	public TypeC(PresenProperties properties, File officeDir) throws IOException {
		super(properties, officeDir);
	}

	@Override
	protected String replaceType(String photoPart, PresenImg photo) {
		photoPart = replaceByProperties(photoPart, DIRECTION, photo.getPropertiesName() + "_direction");
		photoPart = replaceByProperties(photoPart, BACKCOLOR, photo.getPropertiesName() + "_backcolor");
		return replaceByProperties(photoPart, BACKIMG, photo.getPropertiesName() + "_backimg", null, "_img_%s");
	}

	@Override
	protected boolean photoCheck(String photoname) {
		boolean b = false;
		b = containCheck(photoname + "_direction") || b;
		b = containCheck(photoname + "_backcolor") || b;
		return b;
	}

}
