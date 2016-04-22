#!/usr/bin/env python3
import jaydebeapi

class Database:
    DRIVER_CLASS="oracle.jdbc.OracleDriver"
    DRIVER_JAR="../ojdbc6.jar"
    DB_URL="jdbc:oracle:thin:@kc-sce-appdb01.kc.umkc.edu:1521:pdbsce1.world"
    DB_USER="cckx7"
    DB_PASS="IrQXBAfP"

    _conn = None

    def __init__(this):
        this._conn = this._get_connection()

    def _get_connection(this):
        if this._conn is None:
            this._conn = jaydebeapi.connect(this.DRIVER_CLASS,
                                    [this.DB_URL, this.DB_USER, this.DB_PASS],
                                    this.DRIVER_JAR)
        return this._conn

    def _get_cursor(this):
        return this._get_connection().cursor()

    def commit(this):
        this._get_connection().commit()

    def row_exists(this, table, column, value):
        cursor = this._get_cursor()
        statement = "select * from " + table + " where " + column + " = ?"
        cursor.execute(statement, [value])
        return cursor.fetchone() is not None

    def insert(this, table, params):
        cursor = this._get_cursor()
        columns = ""
        placeholders = ""
        values = []
        for col, val in params.items():
            columns += str(col) + ", "
            placeholders += "?, "
            values.append(val)
        columns = columns.rstrip(", ")
        placeholders = placeholders.rstrip(", ")

        statement = "insert into " + table + "(" + columns + ")" + " values (" + placeholders + ")"
        cursor.execute(statement, values)
