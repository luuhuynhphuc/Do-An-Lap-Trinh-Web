package com.japansport.dao;

import java.sql.Statement;

public abstract class DAO {
    protected Statement getStatement() {
        return DBConnect.getInstance().createStatement();
    }
}
