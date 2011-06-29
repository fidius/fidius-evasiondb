module FIDIUS
  module EvasionDB
    def self.rule_fetcher(name,&block)
      FIDIUS::EvasionDB::RuleFetcher.new(name,&block)
    end

    def self.install_rule_fetchers
      $logger.debug "installing rule fetchers"
      FIDIUS::EvasionDB::RuleFetcher.all.each do |fetcher|
        fetcher.run_install
      end
    end

    # A Fetcher is used to fetch rules from an ids
    class RuleFetcher
      @@fetchers = []
      attr_accessor :name

      def initialize(name,&block)
        self.instance_eval(&block)
        @name = name
        @@fetchers << self
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

      def config(conf)
        raise "overwrite this"
      end

      def fetch_rules(attack_module)
        raise "overwrite this"
      end

      def self.all
        @@fetchers
      end

      def self.by_name(name)
        self.all.each do |fetcher|
          return fetcher if fetcher.name == name
        end
        nil
      end
    end
  end
end

Dir[File.join(File.dirname(__FILE__), "*/rule_fetcher.rb")].each{|fetch_require|
  $logger.debug "load #{fetch_require}"
  require fetch_require
} 
