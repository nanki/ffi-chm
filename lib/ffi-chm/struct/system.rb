class FFI::Chm::Struct::System < BinData::Record
  class NoRecordError < StandardError;end

  require 'ffi-chm/struct/system/system_record'

  endian :little

  uint32 :version
  array :records, :type => :system_record, :read_until => :eof


  def record(code)
    @memo ||= Hash[*records.map{|v|[v.code.to_i, v]}.flatten]
    raise NoRecordError, "/#SYSTEM has no record code:#{code}" unless @memo.has_key? code
    @memo[code]
  end

  LCID2ENCODING = {
    1041 => "CP932", # SJIS
    2052 => "CP936" # GB2313
  }

  def encoding
    LCID2ENCODING[self.record(4).data.lcid.to_i] || "CP1252" # ANSI
  end
end
