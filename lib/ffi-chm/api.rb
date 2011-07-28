require 'ffi'

module FFI::Chm::API
  extend FFI::Library

  ffi_lib('chm')

  # proc {|handle, unitinfo, userdata| ... }
  callback :enumerator, [:pointer, :pointer, :pointer], :int

  prototypes = [
    [:chm_open, [:string], :pointer],
    [:chm_close, [:pointer], :void],
    [:chm_set_param, [:pointer, :int, :int], :void],
    [:chm_resolve_object, [:pointer, :string, :buffer_out], :int],
    [:chm_retrieve_object, [:pointer, :pointer, :buffer_out, :uint64, :int64], :int64],
    [:chm_enumerate, [:pointer, :int, :enumerator, :pointer], :int],
    [:chm_enumerate_dir, [:pointer, :string, :int, :enumerator, :pointer], :int]
  ]

  prototypes.each {|func| attach_function(*func)}
end
