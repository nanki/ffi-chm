class FFI::Chm::Struct::System::Code4 < BinData::Record
  endian :little

  uint32 :lcid
  uint32 :use_dbcs
  uint32 :fulltext_enabled
  uint32 :has_klinks
  uint32 :has_alinks
  uint64 :timestamp
  uint64 :unknown
end
