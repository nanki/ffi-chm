class FFI::Chm::Struct::SR < BinData::Primitive
  # s = 2
  mandatory_parameter :r

  array :prefix, :type => :bit1, :read_until => lambda { element.zero? }
  array :bits, :type => :bit1, :initial_length => :num_bits

  resume_byte_alignment

  def num_bits
    get_parameter(:r) + [0, prefix.size - 2].max
  end

  def get
    size = prefix.size
    ret = bits.inject(0){|r, v| r << 1 | v}
    ret += 2 ** (size + 1) if size > 1
    ret
  end
end
