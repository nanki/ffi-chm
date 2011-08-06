class FFI::Chm::Struct::FulltextIndex < BinData::Record
  endian :little

  hide :unknown1, :unknown2, :unknown3, :unknown4, :unknown5, :unknown6, :unknown7, :unknown8, :unknown9, :unknown10, :rest

  uint32 :unknown1
  uint32 :num_files
  uint32 :offset_to_root
  uint32 :unknown2, :check_value => 0
  uint32 :num_nodes
  uint32 :unknown3, :check_value => :offset_to_root
  uint16 :depth
  uint32 :unknown4
  uint8 :document_scale
  uint8 :document_root
  uint8 :encoding_scale
  uint8 :encoding_root
  uint8 :location_code_scale
  uint8 :location_code_root
  string :unknown5, :read_length => 10
  uint32 :node_size
  uint32 :unknown6
  uint32 :word_index_of_last_duplicate
  uint32 :char_index_of_last_duplicate
  uint32 :longest_word
  uint32 :num_words
  uint32 :num_unique_words
  uint32 :length_of_words1
  uint32 :length_of_words2
  uint32 :length_of_unique_words
  uint32 :length_of_null_bytes
  uint32 :unknown7
  uint32 :unknown8
  string :unknown9, :read_length => 24

  # http://en.wikipedia.org/wiki/Windows_code_page
  uint32 :codepage

  # http://msdn.microsoft.com/en-us/library/0h88fahh.aspx
  uint32 :lcid
  string :unknown10, :read_length => 894

  rest :rest

  require 'ffi-chm/struct/fulltext_index/leaf'
  require 'ffi-chm/struct/fulltext_index/index'

  def nodedata(offset)
    rest[offset - 1024, node_size]
  end

  def root
    @root ||= Index.new.read(self.nodedata(self.offset_to_root))
  end
end
