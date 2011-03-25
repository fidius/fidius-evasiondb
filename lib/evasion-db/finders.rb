module FIDIUS
  module EvasionDB
    FIND_MIN = 1
    FIND_MAX = 2
    
    def self.find_events_for_exploit(name,options=[],result = FIND_MIN)
      e = Exploit.find_all_by_name(name)
      if e.size > 0
        return e
      end
      nil
    end
    #sig: exploit(string), options, [MAX,MIN,ARRAY]
  end
end
