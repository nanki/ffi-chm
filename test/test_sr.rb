require "test/unit"
require "ffi-chm"

class TestSR < Test::Unit::TestCase
  def setup
    @testset = [
      [2,   3, '011----'],
      [2,   4, '1000----'],
      [3,   0, '0000----'],
      [3,   1, '0001----'],
      [3,   2, '0010----'],
      [3,   7, '0111----'],
      [3,   8, '10000---'],
      [3,   9, '10001---'],
      [3,  10, '10010---'],
      [3,  15, '10111---'],
      [3,  16, '1100000-'],
      [3,  17, '1100001-'],
      [3,  18, '1100010-'],
      [3,  30, '1101110-'],
      [3,  31, '1101111-'],
      [3,  32, '111000000-------'],
      [3,  33, '111000001-------'],
      [3,  34, '111000010-------'],
      [3,  62, '111011110-------'],
      [3,  63, '111011111-------'],
      [3,  64, '11110000000-----'],
      [5,  31, '011111----------'],
      [5,  63, '1011111----------'],
      [5, 512, '111110000000000-']
    ]
  end

  def test_sr
    @testset.each{|set|set.last.gsub!('-', '0')}
    @testset.each do |r, expect, bits|
      sr = FFI::Chm::Struct::SR.new(:r => r).read [bits].pack("B*")
      assert_equal expect, sr.get
    end
  end

  def test_sr_byte_aligned
    @testset.each{|set|set.last.delete!('-')}

    rs, expects, bits = @testset.transpose
    bits = bits.join
    bits += "0" * bits.size % 8
    wcls = BinData::IO.new [bits].pack("B*")

    values = rs.map{|r| FFI::Chm::Struct::SR.new(:r => r).read(wcls)}

    assert_equal expects, values
  end
end
