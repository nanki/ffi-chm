require 'bindata'

module FFI::Chm::Struct
  autoload :Topics, 'ffi-chm/struct/topics'
  autoload :System, 'ffi-chm/struct/system'
  autoload :HHK, 'ffi-chm/struct/hhk/entry'
  autoload :HHC, 'ffi-chm/struct/hhc/entry'
  autoload :HHXDocument, 'ffi-chm/struct/hhx_document'
  autoload :URLTable, 'ffi-chm/struct/url_table'
  autoload :URLString, 'ffi-chm/struct/url_string'
end
