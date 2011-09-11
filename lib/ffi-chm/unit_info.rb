module FFI::Chm
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

    def path
      self[:path].to_s
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
