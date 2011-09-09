module FFI::Chm
  class ChmFile
    require 'ffi-chm/chm_file/aux'
    include Aux

    attr_reader :path

    def initialize(path, &block)
      @path = path
      self.open &block if block_given?
    end

    def open(path=@path, &block)
      @path = path
      @h = API.chm_open @path
      raise ChmError, "Not exists?" if @h.null?
      if block_given?
        begin
          yield self
        ensure
          self.close
        end
      else
        self
      end
    end

    def close
      API.chm_close @h unless @h.null?
    end

    def set_param(param, value)
      API.chm_set_param @h, param, value
    end

    def resolve_object(name)
      ui = UnitInfo.new
      case API.chm_resolve_object @h, name, ui
      when Const::RESOLVE_SUCCESS
        ui
      when Const::RESOLVE_FAILURE
        raise ResolveError
      end
    end

    def retrieve_object(ui)
      if UnitInfo === ui
        buf = FFI::Buffer.new ui[:length]
        API.chm_retrieve_object @h, ui, buf, 0, ui[:length]
        # use read_string for JRuby
        buf.read_bytes buf.size
      else
        retrieve_object resolve_object(ui)
      end
    rescue ResolveError
      raise RetrieveError, ui
    end

    def enumerate(*what, &block)
      if block_given?
        API.chm_enumerate @h, to_flags(what), enum_func(&block), nil
        self
      else
        Com8ble::Enumerator.new self, :enumerate, to_flags(what)
      end
    end

    def enumerate_dir(prefix, *what, &block)
      if block_given?
        API.chm_enumerate_dir @h, prefix, to_flags(what), enum_func(&block), nil
        self
      else
        Com8ble::Enumerator.new self, :enumerate_dir, prefix, to_flags(what)
      end
    end

    private
    def enum_func(&block)
      lambda do |h, ui, _|
        begin
          if block.call(UnitInfo.new(ui).clone) == :break
            Const::ENUMERATOR_SUCCESS
          else
            Const::ENUMERATOR_CONTINUE
          end
        rescue
          Const::ENUMERATOR_FAILURE
        end
      end
    end

    def to_flags(what)
      if what.size == 1 && Integer === what.first
        what.first
      else
        what.inject(0) do |r, sym|
          r | (Const::ENUMERATE_FLAGS[sym] || 0)
        end
      end
    end
  end
end
