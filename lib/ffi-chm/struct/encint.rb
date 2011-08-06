class FFI::Chm::Struct::Encint < BinData::Primitive
  array :rawdata, :type => :uint8, :read_until => lambda {(element & 0x80).zero?}

  def get
    shift = -7
    rawdata.inject(0) do |r, v|
      shift += 7
      r | (v & 0x7F) << shift
    end
  end
end
