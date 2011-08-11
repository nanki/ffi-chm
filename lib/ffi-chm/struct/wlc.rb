class FFI::Chm::Struct::WLC < BinData::Record
  require 'ffi-chm/struct/sr'

  mandatory_parameter :document_root, :code_count_root, :location_code_root

  sr :document_index, :r => :document_root
  sr :code_count, :r => :code_count_root

  array :locations, :initial_length => :code_count do
    sr :location_code, :r => :location_code_root
  end

  resume_byte_alignment
end
