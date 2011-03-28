module FIDIUS
  module EvasionDB
    def self.recorder(name,&block)
      FIDIUS::EvasionDB::Recorder.new(name,&block)
    end

    def self.install_recorders
      $logger.debug "installing recoders"
      FIDIUS::EvasionDB::Recorder.all.each do |recorder|
        recorder.run_install
      end
    end

    # A Recorder us used to log packets for an executed attack
    class Recorder
      @@recorders = []
      attr_accessor :name

      def initialize(name,&block)
        self.instance_eval(&block)
        @name = name
        @@recorders << self
      end

      def install(&block)
        $logger.debug "setting installblock"
        @install = block
      end

      def run_install
        raise "no install block given" unless @install
        $logger.debug "run install of #{@name}"
        @install.call
      end

      def self.all
        @@recorders
      end

      def self.by_name(name)
        self.all.each do |recorder|
          return recorder if recorder.name == name
        end
        nil
      end

      def start
        raise "overwrite this"
      end

      def log_packet
        raise "overwrite this"
      end
    end
  end
end

Dir[File.join(File.dirname(__FILE__), "*/recorder.rb")].each{|fetch_require|
  $logger.debug "load #{fetch_require}"
  require fetch_require
} 
