module FFI::Chm::Struct::HHK
  class Entry < Struct.new(:Name, :Type, :Local, :URL, :FrameName, :WindowName, :Comment, :Merge, :'See Also')
    def SeeAlso
      self["See Also"]
    end
  end
end
