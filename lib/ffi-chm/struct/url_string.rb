class FFI::Chm::Struct::URLString < BinData::Record
  endian :little

  uint32 :offset_url
  uint32 :offset_framename
  stringz :local
end
