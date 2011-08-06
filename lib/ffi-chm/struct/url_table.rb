class FFI::Chm::Struct::URLTable < BinData::Record
  require 'ffi-chm/struct/url_table/url_table_record'
  require 'ffi-chm/struct/url_table/url_table_block'
  
  array :blocks, :type => :url_table_block, :read_until => :eof
end
