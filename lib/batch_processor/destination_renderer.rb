require 'erb'

module BatchProcessor
  class DestinationRenderer < Struct.new(:template)
    def render(destination, taxonomy)
      context = TemplateContext.new(destination, taxonomy)
      erb.result context.get_binding
    end

    def erb
      @erb = ERB.new template
    end

    class TemplateContext < Struct.new(:destination, :taxonomy)
      include TemplateHelpers

      def get_binding
        binding
      end
    end
  end
end
