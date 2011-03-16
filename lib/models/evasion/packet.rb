class Packet < EvasionDbConnection
  belongs_to :prelude_log

  def self.table_name
    "packets"
  end

  def payload
    return [] if self[:payload] == nil
    self[:payload]
  end

end
