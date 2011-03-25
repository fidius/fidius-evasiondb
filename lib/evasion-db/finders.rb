module FIDIUS
  module EvasionDB
    def find_events_for_exploit(name,options=[],result = MIN)
      e = Exploit.find_by_name(name)
      unless e
        return e.idmef_events
      end
    end
    #sig: exploit(string), options, [MAX,MIN,ARRAY]
  end
end
