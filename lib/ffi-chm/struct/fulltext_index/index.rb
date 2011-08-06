class FFI::Chm::Struct::FulltextIndex::Index < BinData::Record
  endian :little

  uint16 :freespace

  count_bytes_remaining :bytes_remaining
  string :rawdata, :read_length => lambda {bytes_remaining - freespace}

  hide :rawdata

  require 'ffi-chm/struct/fulltext_index/index/index_record'

  def records
    @records ||= BinData::Array.new(:type => :index_record, :read_until => :eof).read self.rawdata
  end
end
