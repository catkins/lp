class BatchProcessor

  attr_reader :destination_parser, :taxonomy_parser, :renderer

  def initialize(options = {})
    @destination_parser = options.fetch :destination_parser
    @taxonomy_parser    = options.fetch :taxonomy_parser
    @renderer           = options.fetch :renderer
  end

  def call(&block)
    taxonomy_parser.traverse do |node|
      destination = find_destination_info node
      html        = renderer.render destination, node
      yield html, destination
    end
  end

  def find_destination_info(taxonomy_node)
    destination_parser.find_by_atlas_id taxonomy_node.atlas_id
  end
end
