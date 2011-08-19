class FFI::Chm::Struct::Topics < BinData::Record
  require 'ffi-chm/struct/topics/topics_record'

  rest :rawdata

  def records
    Com8ble::Enumerator.new self, :each_record
  end

  def each_record
    (rawdata.size >> 4).times do |i|
      yield record(i)
    end
  end

  def record(index)
    io = StringIO.new rawdata
    io.seek index << 4
    r = TopicsRecord.new.read io
    r.set_context @chm
    r
  end

  def set_context(chm)# :nodoc:
    @chm = chm
  end
end
