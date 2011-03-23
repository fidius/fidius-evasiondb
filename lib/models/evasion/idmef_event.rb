class IdmefEvent < EvasionDbConnection
  belongs_to :exploit

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

  def payload_size
    return self[:payload].size if self[:payload]
    return 0
  end
end
