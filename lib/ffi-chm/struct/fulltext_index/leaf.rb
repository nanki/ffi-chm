class FFI::Chm::Struct::FulltextIndex::Leaf < BinData::Record
  endian :little

  uint32 :offset_to_next
  uint16 :unknown, :check_value => 0
  uint16 :freespace

  hide :rawdata
  count_bytes_remaining :bytes_remaining
  string :rawdata, :read_length => lambda {bytes_remaining - freespace}

  require 'ffi-chm/struct/fulltext_index/leaf/leaf_record'

  def records
    @records ||= BinData::Array.new(:type => :leaf_record, :read_until => :eof).read self.rawdata
  end
end
