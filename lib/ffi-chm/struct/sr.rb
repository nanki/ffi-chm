class FFI::Chm::Struct::SR < BinData::Primitive
  # s = 2
  mandatory_parameter :r

  array :prefix, :type => :bit1, :read_until => lambda { element.zero? }
  array :bits, :type => :bit1, :initial_length => :num_bits

  def num_bits
    eval_parameter(:r) + [0, prefix.size - 2].max
  end

  def get
    size = prefix.size
    ret = bits.inject(0){|r, v| r << 1 | v}
    ret += 2 ** (eval_parameter(:r) + size - 2) if size > 1
    ret
  end
end
