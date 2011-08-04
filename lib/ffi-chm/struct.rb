require 'bindata'

module FFI::Chm::Struct
  autoload :System, 'ffi-chm/struct/system'
  autoload :HHK, 'ffi-chm/struct/hhk/entry'
  autoload :HHC, 'ffi-chm/struct/hhc/entry'
  autoload :HHXDocument, 'ffi-chm/struct/hhx_document'
end
