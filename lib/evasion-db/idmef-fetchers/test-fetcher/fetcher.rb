FIDIUS::EvasionDB.fetcher "TestFetcher" do
  install do
    require (File.join File.dirname(__FILE__), 'lib', 'test_fetcher.rb')
    self.extend TestFetcher
  end
end
