class FFI::Chm::Struct::System < BinData::Record
  require 'ffi-chm/struct/system/record'

  endian :little

  uint32 :version
  array :records, :type => :record, :read_until => :eof


  def record(code)
    @memo ||= Hash[*records.map{|v|[v.code.to_i, v]}.flatten]
    @memo[code]
  end

  def encoding
    case self.record(4).data.lcid.to_i
    when 1041
      "CP932"
    else
      "UTF-8"
    end
  end
end
