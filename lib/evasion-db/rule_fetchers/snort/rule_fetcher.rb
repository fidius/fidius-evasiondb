FIDIUS::EvasionDB.rule_fetcher "Snortrule-Fetcher" do
  install do
    require (File.join File.dirname(__FILE__), 'lib', 'snort.rb')
    self.extend FIDIUS::EvasionDB::SnortRuleFetcher
  end
end
