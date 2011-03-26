FIDIUS::EvasionDB.fetcher "TestFetcher" do
  install do
    require (File.join File.dirname(__FILE__), 'lib', 'msf-recorder.rb')
    self.extend MsfRecorder
  end
end
