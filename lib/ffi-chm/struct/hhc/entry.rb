module FFI::Chm::Struct::HHC
  class Entry < Struct.new(:Name, :Type, :Local, :URL, :FrameName, :WindowName, :Comment, :Merge, :ImageNumber, :New)
  end
end
