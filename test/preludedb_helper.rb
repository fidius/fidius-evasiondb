module PreludeDBHelper
  def self.setup_prelude_db(config)
    File.delete(config["database"]) if File.exists?(config["database"])
    FIDIUS::PreludeDB::Connection.establish_connection config
    sql = File.read(File.join(TEST_DIR,"config","prelude.sql"))
    sql.split(';').each do |sql_statement|
      sql_statement = sql_statement.lstrip
      if sql_statement != ""
        FIDIUS::PreludeDB::Connection.connection.execute sql_statement
      end
    end
  end

  def self.insert_event(ident,text,analyzer)
      a = FIDIUS::PreludeDB::Alert.new
      a.messageid = "00042a60-1fd5-11df-ad31"
      a._ident=ident
      a.save
      c = FIDIUS::PreludeDB::Classification.new
      c.text = text
      c._message_ident = ident
      c.save

      a = FIDIUS::PreludeDB::Address.new
      a.category = "ipv4-addr"
      a._parent0_index = 1
      a._index = 1
      a._message_ident = ident
      a._parent_type = "T"
      a.address = "127.0.0.1"
      a.save      
      a = FIDIUS::PreludeDB::Address.new
      a.category = "ipv4-addr"
      a._parent0_index = 1
      a._index = 1
      a._message_ident = ident
      a._parent_type = "S"
      a.address = "127.0.0.1"
      a.save      

      i = FIDIUS::PreludeDB::Impact.new
      i._message_ident = ident
      i.severity = "high"
      i.save

      a = FIDIUS::PreludeDB::Analyzer.new
      a._message_ident = ident
      a.model = analyzer
      a.name = analyzer
      a.save

      t = FIDIUS::PreludeDB::DetectTime.new
      t.time = Time.now
      t._message_ident = ident
      t.save

      s = FIDIUS::PreludeDB::Service.new
      s._message_ident = ident
      s._parent_type = "S"
      s.port = 445
      s.save

      s = FIDIUS::PreludeDB::Service.new
      s._message_ident = ident
      s._parent_type = "T"
      s.port = 446
      s.save

  end
end
