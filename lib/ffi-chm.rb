module FFI
  module Chm
    VERSION = '0.1.0'
  end
end

require 'ffi-chm/const'
require 'ffi-chm/api'

module FFI::Chm
  autoload :Struct, 'ffi-chm/struct'

  include API
  include Const

  class ChmError < StandardError;end
  class ResolveError < ChmError;end
  class RetrieveError < ChmError;end

  class ChmFile
    def initialize(fn)
      @h = API.chm_open fn
      raise ChmError, "Not exists?" if @h.null?
      if block_given?
        begin
          yield self
        ensure
          self.close
        end
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
        buf.read_bytes buf.size
      else
        retrieve_object resolve_object(ui)
      end
    rescue ResolveError
      raise RetrieveError, ui
    end

    require 'enumerator'
    def enumerate(*what, &block)
      if block_given?
        API.chm_enumerate @h, to_flags(what), enum_func(&block), nil
        self
      else
        (Enumerable::Enumerator rescue Enumerator).new self, :enumerate, to_flags(what)
      end
    end

    def enumerate_dir(prefix, *what, &block)
      if block_given?
        API.chm_enumerate_dir @h, prefix, to_flags(what), enum_func(&block), nil
        self
      else
        (Enumerable::Enumerator rescue Enumerator).new self, :enumerate_dir, prefix, to_flags(what)
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

  class UnitInfo < FFI::Struct
    layout :start, :uint64,
           :length, :uint64,
           :space, :int,
           :flags, :int,
           :path, [:char, Const::MAX_PATHLEN + 1]

    def dir?
      flag? :dirs
    end

    def file?
      flag? :files
    end

    %w(normal special meta).each do |name|
      define_method("#{name}?") do
        flag? name.intern
      end
    end

    private
    def flag?(flag)
      !!(self[:flags] & Const::ENUMERATE_FLAGS[flag]).nonzero?
    end
  end
end
