class IdmefEvent < EvasionDbConnection
  has_many :payload_logs

  def self.table_name
    "idmef_events"
  end

  def payload
    return [] if self[:payload] == nil
    self[:payload]
  end

  def get_payloads_logs
    payload_logs
  end
end
