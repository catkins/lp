module BatchProcessor
  DEFAULT_OUTPUT_PATH   = File.expand_path '../../dist', __FILE__
  LIBRARY_PATH          = File.expand_path '../batch_processor', __FILE__
  DEFAULT_TEMPLATE_PATH = File.join LIBRARY_PATH, 'views/destination.html.erb'
  STATIC_ASSETS_PATH    = File.join LIBRARY_PATH, 'static'
end

require 'batch_processor/helpers/xml_helpers'
require 'batch_processor/helpers/template_helpers'
require 'batch_processor/models/taxonomy'
require 'batch_processor/models/taxonomy_node'
require 'batch_processor/parsers/taxonomy_parser'
require 'batch_processor/models/destination'
require 'batch_processor/parsers/destination_parser'
require 'batch_processor/destination_renderer'
require 'batch_processor/content_builder'
require 'batch_processor/processor_cli'
