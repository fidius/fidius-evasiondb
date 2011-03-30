FIDIUS::EvasionDB.recorder "Msf-Recorder" do
  install do
    require (File.join File.dirname(__FILE__), 'lib', 'msf-recorder.rb')
    self.extend FIDIUS::EvasionDB::MsfRecorder
  end
end
