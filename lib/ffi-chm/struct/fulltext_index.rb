class FFI::Chm::Struct::FulltextIndex < BinData::Record
  endian :little

  hide :unknown1, :unknown2, :unknown3, :unknown4, :unknown5, :unknown6, :unknown7, :unknown8, :unknown9, :unknown10, :rest
  hide :document_scale, :code_count_scale, :location_code_scale

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
  uint8 :code_count_scale
  uint8 :code_count_root
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

  def nodedata(offset, size=node_size)
    rest[offset - 1024, size]
  end

  def leaf(offset)
    FFI::Chm::Struct::FulltextIndex::Leaf.new.read(self.nodedata(offset))
  end

  def single_leaf?
    self.depth == 1
  end

  def root
    @root ||= (single_leaf? ? Leaf : Index).new.read(self.nodedata(self.offset_to_root))
  end

  def wlc_params
    {
      :document_root      => self.document_root,
      :code_count_root    => self.code_count_root,
      :location_code_root => self.location_code_root
    }
  end

  def wlcs(leaf)
    @wlcs ||= {}
    if @wlcs.has_key? leaf.offset_of_wlcs
      @wlcs[leaf.offset_of_wlcs]
    else
      data = BinData::IO.new self.nodedata(leaf.offset_of_wlcs, leaf.length_of_wlcs)
      @wlcs[leaf.offset_of_wlcs] = leaf.num_wlcs.times.map do
        FFI::Chm::Struct::WLC.new(self.wlc_params).read(data)
      end
    end
  end
end
