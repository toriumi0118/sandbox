package wellmotion.presen;

import java.sql.*;
import java.util.Properties;

public class DB {
	private static final String DRIVER = "com.mysql.jdbc.Driver";
	private static final String URL_FORMAT = "jdbc:mysql://%s/%s";

	private static final String HISTORY_SQL = "INSERT INTO office_presentation_history (office_id, editor, action) VALUES (?,?,?)";

	public final Connection con;

	public DB(Properties globalSetting) throws Exception {
		this.con = setupConnection(globalSetting);
		this.con.setAutoCommit(false);
	}

	private Connection setupConnection(Properties globalSetting) throws Exception {
		Class.forName(DRIVER);
		String dbUrl = String.format(URL_FORMAT, globalSetting.getProperty(GlobalSetting.DBHOST_KEY),
				globalSetting.getProperty(GlobalSetting.DBNAME_KEY));
		return DriverManager.getConnection(dbUrl, globalSetting.getProperty(GlobalSetting.DBUSER_KEY),
				globalSetting.getProperty(GlobalSetting.DBPASS_KEY));
	}

	public void commit() {
		try {
			this.con.commit();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public void rollback() {
		try {
			this.con.rollback();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public void close() {
		try {
			this.con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public void insertHistory(int officeId) throws SQLException {
		PreparedStatement ps = con.prepareStatement(HISTORY_SQL);
		ps.setInt(1, officeId);
		ps.setString(2, "presentation maker");
		ps.setString(3, "UPDATE");
		ps.execute();
		ps.close();
	}

}
