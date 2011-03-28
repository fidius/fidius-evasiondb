require 'helper'
class TestPreludeDB < Test::Unit::TestCase
  def test_prelude_event


    
    #puts source
    #while (line = file.gets)
    #  sql << line
    #end
    #file.close

    #FIDIUS::PreludeDB::Connection.connection.execute("CREATE TABLE Prelude_Action (_message_ident bigint(20))")
    p = FIDIUS::PreludeDB::Alert.first
  end
end
