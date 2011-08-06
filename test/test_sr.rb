require "test/unit"
require "ffi-chm"

class TestSR < Test::Unit::TestCase
  def setup
    @testset = [
      [ 0, '0000----'],
      [ 1, '0001----'],
      [ 2, '0010----'],
      [ 7, '0111----'],
      [ 8, '10000---'],
      [ 9, '10001---'],
      [10, '10010---'],
      [15, '10111---'],
      [16, '1100000-'],
      [17, '1100001-'],
      [18, '1100010-'],
      [30, '1101110-'],
      [31, '1101111-'],
      [32, '111000000-------'],
      [33, '111000001-------'],
      [34, '111000010-------'],
      [62, '111011110-------'],
      [63, '111011111-------'],
      [64, '1111000000------']
    ].each{|set|set.last.gsub!('-', '0')}
  end

  def test_sr
    @testset.each do |expect, bits|
      sr = FFI::Chm::Struct::SR.new(:r => 3).read [bits].pack("B*")
      assert_equal expect, sr.get
    end
  end

  def test_sr_byte_aligned
    expects, bits = @testset.transpose
    bytes = [bits.join].pack("B*")
    values = BinData::Array.new(:type => [:sr, {:r => 3}], :read_until => :eof).read(bytes)
    assert_equal expects, values
  end
end
