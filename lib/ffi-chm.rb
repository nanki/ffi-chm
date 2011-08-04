module FFI
  module Chm
    VERSION = '0.2.0'
  end
end

require 'ffi-chm/const'
require 'ffi-chm/api'

module FFI::Chm
  autoload :Struct, 'ffi-chm/struct'
  autoload :ChmFile, 'ffi-chm/chm_file'
  autoload :UnitInfo, 'ffi-chm/unit_info'

  include API
  include Const

  class ChmError < StandardError;end
  class ResolveError < ChmError;end
  class RetrieveError < ChmError;end
end
