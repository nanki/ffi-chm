class FFI::Chm::Struct::Topics < BinData::Record
  require 'ffi-chm/struct/topics/topics_record'

  array :raw_records, :type => :topics_record, :read_until => :eof

  def records
    Com8ble::Enumerator.new do |y|
      raw_records.each do |record|
        record.set_context(@chm)
        y << record
      end
    end
  end

  def set_context(chm)
    @chm = chm
  end
end
