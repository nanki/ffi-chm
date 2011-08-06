class FFI::Chm::Struct::URLTable::URLTableRecord < BinData::Record
    endian :little

    uint32 :unknown
    uint32 :index_in_topics
    uint32 :offset_in_urlstr

    hide :unknown
end
