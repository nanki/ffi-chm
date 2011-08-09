require "test/unit"
require "ffi-chm"

class TestSR < Test::Unit::TestCase
  def setup
    @testset = [
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
      [3,  64, '1111000000------'],
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

    _, expects, bits = @testset.select{|v|v.first == 3}.transpose
    bytes = [bits.join].pack("B*")
    values = BinData::Array.new(:type => [:sr, {:r => 3}], :read_until => :eof).read(bytes)
    assert_equal expects, values

    _, expects, bits = @testset.select{|v|v.first == 5}.transpose
    bytes = [bits.join].pack("B*")
    values = BinData::Array.new(:type => [:sr, {:r => 5}], :read_until => :eof).read(bytes)
    assert_equal expects, values
  end
end
