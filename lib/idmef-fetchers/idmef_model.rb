module FIDIUS
  module EvasionDB
    module IdmefModel
      def payload
        raise "overwrite this"
      end

      def detect_time
        raise "overwrite this"
      end

      def dest_ip
        raise "overwrite this"
      end

      def dest_port
        raise "overwrite this"
      end

      def source_ip
        raise "overwrite this"
      end

      def source_port
        raise "overwrite this"
      end

      def text
        raise "overwrite this"
      end

      def severity
        raise "overwrite this"
      end

      def analyzer_model
        raise "overwrite this"
      end

      def ident
        raise "overwrite this"
      end
    end
  end
end
