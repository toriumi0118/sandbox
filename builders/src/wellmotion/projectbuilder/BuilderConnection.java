package wellmotion.projectbuilder;

import java.sql.*;
import java.util.*;
import java.util.regex.Pattern;

public class BuilderConnection {
	private static final String DRIVER = "com.mysql.jdbc.Driver";
	private static final String URL_FORMAT = "jdbc:mysql://%s/%s";

	private static final String BINARY_JUDGE_REGEX = "^b'[0-9]'$|^[0-9]b$";
	private static final Pattern P;

	static {
		// 大文字小文字を区別しないため、第二引数にCASE_INSENSITIVEを付与。
		P = Pattern.compile(BINARY_JUDGE_REGEX);
	}

	private final Connection con;
	private final boolean showSQL;

	public BuilderConnection(Map<String, String> validArgs, boolean showSQL) {
		super();
		String dbUrl = String.format(URL_FORMAT, validArgs.get(Argument.DBHOST_OPTION),
				validArgs.get(Argument.DBNAME_OPTION));
		this.showSQL = showSQL;
		try {
			Class.forName(DRIVER);
			this.con = DriverManager.getConnection(dbUrl, validArgs.get(Argument.DBUSER_OPTION),
					validArgs.get(Argument.DBPASS_OPTION));
			this.con.setAutoCommit(false);
		} catch (ClassNotFoundException e) {
			throw new RuntimeException(e);
		} catch (SQLException e) {
			throw new IllegalStateException(e);
		}
	}

	private void showSQL(String sql) {
		if (this.showSQL) {
			System.out.println("実行するSQL : " + sql);
		}
	}

	public void rollback() {
		if (con != null) {
			try {
				con.rollback();
			} catch (SQLException e) {
				throw new IllegalStateException(e);
			}
		}
	}

	public void commit() {
		if (con != null) {
			try {
				con.commit();
			} catch (SQLException e) {
				throw new IllegalStateException(e);
			}
		}
	}

	public void close() {
		if (con != null) {
			try {
				con.close();
			} catch (SQLException e) {
				throw new IllegalStateException(e);
			}
		}
	}

	void insert(String table, Map<String, String> values) {
		PreparedStatement ps = null;
		try {
			ArrayList<String> bindArgs = new ArrayList<String>();
			StringBuilder sql = new StringBuilder();
			prepareSql(sql, bindArgs, table, values);
			showSQL(sql.toString());
			ps = con.prepareStatement(sql.toString());
			insertExecute(ps, bindArgs);
		} catch (SQLException e) {
			throw new IllegalStateException(e);
		} finally {
			if (ps != null) {
				try {
					ps.close();
				} catch (SQLException e) {
					throw new IllegalStateException(e);
				}
			}
		}
	}

	private void insertExecute(PreparedStatement ps, ArrayList<String> bindArgs) throws SQLException {
		for (int i = 0; i < bindArgs.size(); i++) {
			String bindArg = bindArgs.get(i);
			if (P.matcher(bindArg).find()) {
				ps.setBoolean(i + 1, bindArg.contains("1") ? true : false);
				continue;
			}
			ps.setString(i + 1, bindArg);
		}
		ps.execute();
	}

	private void prepareSql(StringBuilder sql, ArrayList<String> bindArgs, String table, Map<String, String> values) {
		sql.append("INSERT");
		sql.append(" INTO ");
		sql.append(table);
		sql.append('(');

		int size = (values != null && values.size() > 0) ? values.size() : 0;
		int i = 0;
		for (String colName : values.keySet()) {
			sql.append((i > 0) ? "," : "");
			sql.append(colName);
			bindArgs.add(i++, values.get(colName));
		}
		sql.append(')');
		sql.append(" VALUES (");
		for (i = 0; i < size; i++) {
			sql.append((i > 0) ? ",?" : "?");
		}
		sql.append(')');
		return;
	}

	void execSQL(String sql) {
		Statement st = null;
		try {
			showSQL(sql);
			st = con.createStatement();
			st.execute(sql);
		} catch (SQLException e) {
			throw new IllegalStateException(e);
		} finally {
			if (st != null) {
				try {
					st.close();
				} catch (SQLException e) {
					throw new IllegalStateException(e);
				}
			}
		}
	}
}
