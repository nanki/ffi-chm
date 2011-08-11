class FFI::Chm::Struct::FulltextIndex::Leaf::LeafRecord < BinData::Record
  require 'ffi-chm/struct/encint'

  endian :little

  uint8 :length_of_word
  uint8 :position
  string :word, :read_length => lambda {length_of_word - 1}
  uint8 :context # 0: body, 1: title
  encint :num_wlcs
  uint32 :offset_of_wlcs
  uint16 :unknown, :check_value => 0
  encint :length_of_wlcs

  hide :length_of_word, :unknown
end
