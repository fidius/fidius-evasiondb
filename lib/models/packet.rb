class Packet < EvasionDbConnection
  belongs_to :exploit
  belongs_to :exploit_payload

  def self.table_name
    "packets"
  end

  def payload
    return [] if self[:payload] == nil
    self[:payload]
  end

end
