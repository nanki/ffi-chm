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
    path = enumerate(:normal, :files).detect{|v| v.path.end_with? '.hhc' }.path
    xml = retrieve_object(path).com8ble.force_encoding(encoding).encode("UTF-8")
    doc = Struct::HHXDocument.new(Struct::HHC::Entry)
    Nokogiri::HTML::SAX::Parser.new(doc).parse(xml)

    doc.root.first.tap do |v|
      @contents = v if cache
    end
  end

  def index(cache=true)
    return @index if @index
    path = enumerate(:normal, :files).detect{|v| v.path.end_with? '.hhk' }.path
    xml = retrieve_object(path).com8ble.force_encoding(encoding).encode("UTF-8")
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

  def fulltext_search(pattern, options={}, &block)
    pattern = pattern.com8ble.force_encoding('UTF-8').encode(self.encoding).force_encoding("ASCII-8BIT")
    context =
      case options[:context]
      when :title
        0
      when :body
        1
      end

    case fulltext_index.depth.to_i
    when 1
      search_inner_prefix fulltext_index.root.to_a, pattern, context, &block
    when 2
      search_inner_prefix fulltext_index.root.records, pattern, context, &block
    else
      raise "Index tree is too deep(#{fulltext_index.depth})."
    end
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

  def search_inner_prefix(records, pattern, context, &block)
    word = ""
    records.each do |r|
      word = word[0, r.position] + r.word
      len = pattern.length
      #len = [pattern.length, word.length].min
      comp = word[0, len] <=> pattern[0, len]

      case r
      when Struct::FulltextIndex::Leaf::LeafRecord
        case comp
        when -1
          next
        when 1
          break
        else
          next if context && context == r.context
          #block.call fulltext_index.wlcs(r) if context == r.context
          block.call r
        end
      when Struct::FulltextIndex::Index::IndexRecord
        next if comp == -1
        search_inner_prefix(fulltext_index.leaf(r.offset_of_leaf).records, pattern, context, &block)
        break if comp == 1
      end
    end
  end
end
