class FFI::Chm::Struct::Topics::TopicsRecord < BinData::Record
  endian :little

  uint32 :offset_in_tocidx
  uint32 :offset_in_strings
  uint32 :offset_in_urltbl
  uint32 :unknown

  hide :unknown

  def title
    @chm.string offset_in_strings
  end

  def local
    table = @chm.url_table(offset_in_urltbl)
    @chm.url_string(table.offset_in_urlstr).local
  end

  def set_context(chm)
    @chm = chm
  end
end