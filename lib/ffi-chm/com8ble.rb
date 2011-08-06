module Com8ble
  module String
    require 'iconv'

    def force_encoding(encoding)
      @encoding = _encoding(encoding)
      self
    end

    def encoding
      @encoding
    end

    def encode(encoding)
      r = Iconv.conv(_encoding(encoding).name, @encoding.name, self)
      r.extend String
      r.force_encoding encoding
      r
    end

    private
    def _encoding(encoding)
      if ::String === encoding
        Struct.new(:name).new(encoding)
      else
        encoding
      end
    end
  end

  require 'enumerator'
  Enumerator = ::Enumerator rescue ::Enumerable::Enumerator
end

class String
  def com8ble
    self.extend Com8ble::String unless self.respond_to? :force_encoding
    self
  end
end
