require 'nokogiri'
require 'ffi-chm/com8ble'

module FFI::Chm::ChmFile::Aux
  include FFI::Chm

  # /#SYSTEM
  def system
    @system ||= Struct::System.new.read retrieve_object("/#SYSTEM")
  end

  # /#TOPICS
  def topics
    @topics ||= Struct::Topics.new.read retrieve_object("/#TOPICS")
    @topics.set_context self
    @topics
  end

  def encoding
    @encoding ||= self.system.encoding
  end

  def title
    @title ||= self.system.record(3).data.title.com8ble.force_encoding(encoding).encode("UTF-8")
  end

  def contents(cache=true)
    return @contents if @contents
    xml = retrieve_object("/#{self.system.record(6).data.compiled_file}.hhc").com8ble.force_encoding(encoding).encode("UTF-8")
    doc = Struct::HHXDocument.new(Struct::HHC::Entry)
    Nokogiri::HTML::SAX::Parser.new(doc).parse(xml)

    doc.root.first.tap do |v|
      @contents = v if cache
    end
  end

  def index(cache=true)
    return @index if @index
    xml = retrieve_object("/#{self.system.record(6).data.compiled_file}.hhk").com8ble.force_encoding(encoding).encode("UTF-8")
    doc = Struct::HHXDocument.new(Struct::HHK::Entry)
    Nokogiri::HTML::SAX::Parser.new(doc).parse(xml)
    doc.root.flatten.tap do |v|
      @index = v if cache
    end
  end

  # /$FIftiMain
  def fulltext_index
    @fulltext_index ||= Struct::FulltextIndex.new.read retrieve_object("/$FIftiMain")
  end

  # /#STRINGS
  def string(offset)
    @string ||= {}
    if @string.has_key? offset
      @string[offset]
    else
      io = StringIO.new raw_strings
      io.seek offset
      @string[offset] = BinData::Stringz.new.read(io).to_s.com8ble.force_encoding(encoding).encode("UTF-8")
    end
  end

  # /#URLTBL
  def url_table(offset)
    io = StringIO.new raw_urltbl
    io.seek offset
    Struct::URLTable::URLTableRecord.new.read(io)
  end

  # /#URLSTR
  def url_string(offset)
    io = StringIO.new raw_urlstr
    io.seek offset
    FFI::Chm::Struct::URLString.new.read io
  end

  private
  def raw_strings
    @strings ||= retrieve_object("/#STRINGS").freeze
  end

  def raw_urltbl
    @urltbl ||= retrieve_object("/#URLTBL").freeze
  end

  def raw_urlstr
    @urlstr ||= retrieve_object("/#URLSTR").freeze
  end
end
