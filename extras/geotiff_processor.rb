class GeotiffProcessor
  include Dragonfly::Configurable
  include Dragonfly::ImageMagick::Utils
  
  def layer(temp_object, layer=0, format=nil, args='')
    args << ' -limit area 512mb'
    tempfile = new_tempfile(format)
    run convert_command, %(#{quote(temp_object.path+"[#{layer}]") if temp_object} #{args} #{quote(tempfile.path)})
    tempfile
  end
end

module Dragonfly
  module ImageMagick
    class Processor
      def convert(temp_object, args='', format=nil)
	args << ' -limit area 512mb'
        format ? [super,{:format => format.to_sym}] : super
      end
    end
  end
end
