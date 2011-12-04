module FIDIUS::EvasionDB::Knowledge
  class EnabledRules < FIDIUS::EvasionDB::Knowledge::Connection
    belongs_to :attack_module

    @bitvector = nil

    def self.table_name
      "enabled_rules"
    end

    def bitvector
      return @bitvector if @bitvector
      res = BitField.new(self.bitstring.size)
      i = 0
      self.bitstring.each_char do |bit|
        res[i] = bit.to_i
        i += 1
      end
      @bitvector = res
      return @bitvector
    end

    # count rules
    # :active or :inactive or :all
    def count(h)
      if h == :all
        return bitvector.size
      elsif h == :active
        return bitvector.total_set
      elsif h == :inactive
        return (bitvector.size - bitvector.total_set)
      end
      raise "use count(:active) or count(:inactive)"
    end
  end
end
