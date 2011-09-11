module FFI::Chm::Struct
  class HHXDocument < Nokogiri::XML::SAX::Document
    # ul - li - object - param
    attr_reader :root

    def initialize(entry_klass)
      @klass = entry_klass
    end

    def start_document
      @root = []
      @heads = []
      @heads << @root
    end

    def start_element(name, attributes = [])
      case name
      when "param"
        return unless @entry
        attr = {}
        attributes.each{|k, v| attr[k.intern] = v }
        @entry[attr[:name].intern] = attr[:value]
      when "li"
        @entry = @klass.new
      when "ul"
        head = []
        @heads.last << head
        @heads << head
      end
    end

    def end_element(name)
      case name
      when "object" # li results broken structure.
        @heads.last << @entry if @entry
      when "ul"
        @heads.pop
      end
    end
  end
end
