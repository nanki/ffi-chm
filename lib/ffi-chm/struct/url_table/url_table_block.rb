class FFI::Chm::Struct::URLTable::URLTableBlock < BinData::Record
  endian :little

  array :records, :type => :url_table_record, :initial_length => 341
  uint32 :unknown, :check_value => 4096

  hide :unknown
end
