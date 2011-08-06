class FFI::Chm::Struct::FulltextIndex::Index::IndexRecord < BinData::Record
  endian :little

  uint8 :length_of_word
  uint8 :position
  string :word, :read_length => lambda {length_of_word - 1}
  uint32 :offset_of_leaf
  uint16 :unknown, :check_value => 0

  hide :length_of_word, :unknown
end
