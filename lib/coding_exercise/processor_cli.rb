require 'thor'
require 'ruby-progressbar'

class ProcessorCLI < Thor
  DEFAULT_OUTPUT_PATH   = File.expand_path '../../../dist', __FILE__
  LIBRARY_PATH          = File.dirname __FILE__
  DEFAULT_TEMPLATE_PATH = File.join LIBRARY_PATH, 'views/destination.html.erb'
  STATIC_ASSETS_PATH    = File.join LIBRARY_PATH, 'static'

  class_option :output, aliases: ['-o'], banner: 'OUTPUT_DIRECTORY', default: DEFAULT_OUTPUT_PATH

  desc 'build', 'Generates static site in output directory'
  option :taxonomy,     required: true, aliases: ['-t'], banner: 'PATH_TO_TAXONOMY_XML'
  option :destinations, required: true, aliases: ['-d'], banner: 'PATH_TO_DESTINATIONS_XML'

  def build
    taxonomy_parser    = build_taxonomy_parser
    destination_parser = build_destination_parser
    renderer           = build_renderer

    total = destination_parser.count
    progress = create_progress_bar(total)
    ensure_output_directory
    copy_static_assets

    BatchProcessor.new({
      destination_parser: destination_parser,
      taxonomy_parser:    taxonomy_parser,
      renderer:           renderer
    }).call do |html, destination|
      save_file html, destination
      progress.increment
    end
  end

  desc 'clean', 'Remove generated site'

  def clean
    if yes? "This will delete #{output_directory} and its contents. Type 'yes' to proceed"
      say "Deleting #{output_directory}"
      FileUtils.rm_rf output_directory
    end
  end

  default_task :build

  private

  def output_directory
    options[:output]
  end

  def ensure_output_directory
    unless File.directory? output_directory
      say "Output directory doesn't exist. Creating #{output_directory}"
      FileUtils.mkpath output_directory
    end
  end

  def copy_static_assets
    say 'Copying static assets'
    FileUtils.cp_r STATIC_ASSETS_PATH, output_directory
  end

  def build_renderer
    Renderer.new File.read DEFAULT_TEMPLATE_PATH
  end

  def build_taxonomy_parser
    taxonomy_file = load_file options[:taxonomy]
    TaxonomyParser.new taxonomy_file
  end

  def build_destination_parser
    destinations_file = load_file options[:destinations]
    DestinationParser.new destinations_file
  end

  def create_progress_bar(total)
    ProgressBar.create({
      title: 'Rendered',
      starting_at: 0,
      total: total,
      format: '%t - %a %b|%i %p%%'
    })
  end

  def load_file(path)
    if File.exists? path
      File.open path
    else
      puts "No such file #{path}. Aborting processing."
      exit(1)
    end
  end

  def save_file(html, destination)
    file_name = File.join options[:output], destination.file_name
    file = File.new file_name, 'w'
    file.write html
    file.close
  end
end
