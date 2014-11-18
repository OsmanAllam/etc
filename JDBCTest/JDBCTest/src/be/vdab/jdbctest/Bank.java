package be.vdab.jdbctest;

import java.math.BigDecimal;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Types;


public class Bank {

	public Bank() {
		
	}
	
	public void connectToDB(String URL, String USER, String PASSWORD) {
		this.dbURL = "jdbc:" + URL;
		this.dbUSER = USER;
		this.dbPASSWORD = PASSWORD;
	}

	public int createAccount(long accountNumber) {
		Connection con = this.getConnection();
		int z = 0;
		try (CallableStatement s = con.prepareCall("{call bank.createAccount(?)}")) {
			s.setLong(1, accountNumber);
			z = s.executeUpdate();
		}
		catch (SQLException e) {
			System.out.println(e);
		}
		finally {
			this.closeConnection(con);
		}
		return z;
	}
	
	public BigDecimal getBalance(long accountNumber) {
		Connection con = this.getConnection();
		BigDecimal z = null;
		try (CallableStatement s = con.prepareCall("{? = call bank.createAccount(?)}")) {
			s.registerOutParameter(1, Types.DECIMAL);
			s.setLong(2, accountNumber);
			z = s.getBigDecimal(1);
		}
		catch (SQLException e) {
			System.out.println(e);
		}
		finally {
			this.closeConnection(con);
		}
		return z;
	}
	
	public int transfer(long accountNumberFrom, long accountNumberTo, BigDecimal amount) {
		Connection con = this.getConnection();
		int z = 0;
		try (CallableStatement s = con.prepareCall("{call bank.transfer(?, ?, ?)}")) {
			s.setLong(1, accountNumberFrom);
			s.setLong(2, accountNumberTo);
			s.setBigDecimal(3, amount);
			z = s.executeUpdate();
		}
		catch (SQLException e) {
			System.out.println(e);
		}
		finally {
			this.closeConnection(con);
		}
		return z;
	}
	
	private Connection getConnection() {
		try {
			return DriverManager.getConnection(dbURL, dbUSER, dbPASSWORD);
		} catch (SQLException e) {
			System.err.println("Unable to establish connection to " + dbURL);
			System.err.println("password = " + dbPASSWORD);
			e.printStackTrace();
			System.exit(1);
		}
		return null;
	}
	
	private void closeConnection(Connection con) {
		try {
			if ((con != null) && !con.isClosed()) {
				con.close();
			}
		}
		catch (SQLException e) {
			System.err.println("Bank::closeConnection: ");
			System.err.println(e);
		}
	}
	
	private String dbURL;
	private String dbUSER;
	private String dbPASSWORD;
}
