require 'plugins/prelude/connection.rb'
require 'plugins/prelude/additional_data.rb'
require 'plugins/prelude/address.rb'
require 'plugins/prelude/alert.rb'
require 'plugins/prelude/analyzer.rb'
require 'plugins/prelude/classification.rb'
require 'plugins/prelude/detect_time.rb'
require 'plugins/prelude/impact.rb'
require 'plugins/prelude/service.rb'
class PreludeEvent < ActiveRecord::Base

  has_many :annotated_events
  def self.columns() @columns ||= []; end
  def self.column(name, sql_type=nil, default=nil,null=true)
    columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s,default,sql_type.to_s,null)
  end

  @prelude_alert = nil

  def initialize(prelude_alert)
    @prelude_alert = prelude_alert
  end

  def self.find_by_sql(query)

  end
  
  def self.total_entries(options = nil)
    return Alert.total_entries
  end

  def self.find(*args)
    if args[0].is_a? Numeric
      a = Alert.find(:all, :conditions => [ "_ident = ?", args[0] ])
      return PreludeEvent.new a.first
    else
      case args[0]  
        when :all
          if(args[1][:conditions] == nil)
            args[1] = args[1].merge({:joins => [:detect_time,]})
            args[1] = args[1].merge({:order => 'time DESC'})
          end

          a = Alert.find(*args)
          result = Array.new
          a.each do |pa|
            result.push PreludeEvent.new pa
          end
          return result
        when :first
          a = Alert.first
          return PreludeEvent.new a
        when :last
          a = Alert.last
          return PreludeEvent.new a
        else  

      end
    end
  end

  def source_ip
    return @prelude_alert.source_ip unless @prelude_alert.nil?
    return "No Ref"
  end

  def dest_ip
    return @prelude_alert.dest_ip unless @prelude_alert.nil?
    return "No Ref"
  end

  def source_port
    return @prelude_alert.source_port.port unless @prelude_alert.nil?
    return "No Ref"
  end

  def dest_port
    return @prelude_alert.dest_port.port unless @prelude_alert.nil?
    return "No Ref"
  end

  def payload
    return @prelude_alert.payload_data unless @prelude_alert.nil?
  end

  def detect_time
   res = @prelude_alert.detect_time.time
   return res unless @prelude_alert.nil?
   return "No Ref"
  end
  def text
    return @prelude_alert.classification.text  unless @prelude_alert.nil?
    return "No Ref"
  end
  def severity
    return @prelude_alert.severity  unless @prelude_alert.nil?
    return "No Ref"
  end
  def analyzer_model
    return @prelude_alert.analyzer.name.to_s  unless @prelude_alert.nil?
    return "No Ref"
  end

  def id
    return @prelude_alert._ident  unless @prelude_alert.nil?
    return "No Ref"
  end

  def self.find_for_autoanno(source,dest,from=nil,to=nil)
    find_and_paginate_with_custom_options(1,nil,1000,source,dest,from,to)
  end

  def self.find_and_paginate_with_custom_options(page,severity = nil,perpage=nil,filter_source=nil,filter_dest=nil,from=nil,to=nil)
    
    perpage = 15 if perpage == nil || perpage.to_i < 1
    # TODO FIXME
    perpage = perpage * 4 
    
    severity = 'low' if severity==0
    severity = 'medium' if severity==1
    severity = 'high' if severity==2

    cond = Array.new
    cond.push "severity = '"+severity+"'" if severity != nil

    if !filter_dest.nil? || !filter_source.nil?
      filter_dest = filter_dest.to_s
      filter_source = filter_source.to_s
      # TODO: make this more secure
      cond.push "(((#{PRELUDE_DB}.Prelude_Address.address LIKE '%"+filter_source+"%' AND #{PRELUDE_DB}.Prelude_Address._parent_type = 'S')) 
        OR ((#{PRELUDE_DB}.Prelude_Address.address LIKE '%"+filter_dest+"%' AND #{PRELUDE_DB}.Prelude_Address._parent_type = 'T')))"
    end

    if !from.nil?
      from_time = Time.at(from-Time.new.utc_offset)

      y = from_time.year.to_s
      m = from_time.month.to_s
      d = from_time.day.to_s
      h = from_time.hour.to_s
      min = from_time.min.to_s
      sec = from_time.sec.to_s
      m = "0"+m if m.to_i/10 == 0
      d = "0"+d if d.to_i/10 == 0
      h = "0"+h if h.to_i/10 == 0
      min = "0"+min if min.to_i/10 == 0
      sec = "0"+sec if sec.to_i/10 == 0

      from_time = y+m+d+h+min+sec
      cond.push "(Prelude_DetectTime.TIME >= "+from_time.to_s+")" 
    end

    if !to.nil?
      to_time = Time.at(to-Time.new.utc_offset)

      y = to_time.year.to_s
      m = to_time.month.to_s
      d = to_time.day.to_s
      h = to_time.hour.to_s
      min = to_time.min.to_s
      sec = to_time.sec.to_s
      m = "0"+m if m.to_i/10 == 0
      d = "0"+d if d.to_i/10 == 0
      h = "0"+h if h.to_i/10 == 0
      min = "0"+min if min.to_i/10 == 0
      sec = "0"+sec if sec.to_i/10 == 0

      to_time = y+m+d+h+min+sec
      cond.push "(Prelude_DetectTime.TIME <= "+to_time.to_s+")" 
    end
    cluster_idmef_ids = Array.new
    Cluster.all.each do |c|
      cluster_idmef_ids.push c.idmef_id
    end
    cond.push "(messageid='"+cluster_idmef_ids.join("' OR messageid='")+"')"


    cond = cond.join(" AND ")
    # FIXME: nich mehr schön, 2 mal alles abfragen...
    # total entries muss sinnvolle conditions nehmen und
    # eigl nur direkt nen count query schicken... performanter ...
    total_entries = PreludeEvent.find(:all,:joins => [:detect_time,:impact,:source_address],
      :order => 'time DESC',
      :conditions => cond).size
    # ---------------------------


    pe = PreludeEvent.paginate(
      :page => page , 
      :per_page => perpage, 
      :total_entries => total_entries, #PreludeEvent.total_entries,

      :joins => [:detect_time,:impact,:source_address],
      :order => 'time DESC',
      :conditions => cond
    )
    pe2 = pe.uniq
    pe2.each do |ppp|
      puts ppp.messageid.to_s
      if !cluster_idmef_ids.member?(ppp.messageid)
        pe.delete ppp
      end
    end
    pe = pe.uniq
    return pe
  end

  def cluster_nr
    c = Cluster.find_by_idmef_id(messageid)
    if c != nil
      return c.cluster_nr
    end
    return -1
  end

  def inspect
    begin
    return "PreludeEvent id: "+id.to_s+", source_ip: "+source_ip+" dest_ip: "+dest_ip+" severity: "+severity+" text: "+text+" analyzer_model: "+analyzer_model+" detect_time: "+detect_time.to_s+""
    rescue

    end
  end

  def to_s
    "#{text}: #{source_ip}:#{source_port} -> #{dest_ip}:#{dest_port}"
  end

  def messageid
    return @prelude_alert.messageid
  end
end
