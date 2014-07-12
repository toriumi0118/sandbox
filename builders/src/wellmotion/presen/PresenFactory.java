package wellmotion.presen;

import java.io.*;

import wellmotion.presen.type.*;

public class PresenFactory {

	public static AbsPresen make(File officeDir) throws IOException {
		PresenProperties properties = new PresenProperties(officeDir);
		switch (properties.getTemplateType()) {
		case A:
			return new TypeA(properties, officeDir);
		case B:
			return new TypeB(properties, officeDir);
		case C:
			return new TypeC(properties, officeDir);
		case D:
			return new TypeD(properties, officeDir);
		case E:
			return new TypeE(properties, officeDir);
		case F:
			return new TypeF(properties, officeDir);
		case G:
			return new TypeG(properties, officeDir);
		case H:
			return new TypeH(properties, officeDir);
		case I:
			return new TypeI(properties, officeDir);
		case J:
			return new TypeJ(properties, officeDir);
		case K:
			return new TypeK(properties, officeDir);
		case NOTSET:
			return null;
		}
		return null;
	}
}
