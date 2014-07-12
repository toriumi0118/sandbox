package wellmotion.presen;

import java.awt.image.BufferedImage;
import java.io.*;

import javax.imageio.ImageIO;

public class ImgUtil {
	public static class Size {
		public int width;
		public int height;

		public Size(int width, int height) {
			super();
			this.width = width;
			this.height = height;
		}

	}

	public static PresenImg getPresenImg(File img) throws IOException {
		final BufferedImage bi = ImageIO.read(img);
		return new PresenImg(bi.getWidth(), bi.getHeight(), img.getName());
	}
}
