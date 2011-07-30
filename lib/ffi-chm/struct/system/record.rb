class FFI::Chm::Struct::System::Record < BinData::Record
  require 'ffi-chm/struct/system/code3'
  require 'ffi-chm/struct/system/code4'
  require 'ffi-chm/struct/system/code6'

  endian :little

  uint16 :code
  uint16 :len

  choice :data, :selection => :code do
    code3 3
    code4 4
    code6 6
    string :default, :read_length => :len
  end
end
