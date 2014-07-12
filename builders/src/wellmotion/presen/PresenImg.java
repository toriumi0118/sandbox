package wellmotion.presen;

public class PresenImg {
	public int width;
	public int height;
	public boolean isMain = false;

	public String originalFileName;
	public String lowerFileName;

	public PresenImg(int width, int height, String fileName) {
		super();
		this.width = width;
		this.height = height;
		this.originalFileName = fileName;
		this.lowerFileName = fileName.toLowerCase();
	}

	public boolean isVertical() {
		return height > width;
	}

	public String getPropertiesName() {
		return lowerFileName.split("\\.")[0];
	}

	public void isMain() {
		isMain = true;
	}
}
