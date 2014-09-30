require 'thor'
require 'ruby-progressbar'

module BatchProcessor
  class ProcessorCLI < Thor

    class_option :output, aliases: ['-o'], banner: 'OUTPUT_DIRECTORY', default: DEFAULT_OUTPUT_PATH

    desc 'build', 'Generates static site in output directory'
    option :taxonomy,     required: true, aliases: ['-t'], banner: 'PATH_TO_TAXONOMY_XML'
    option :destinations, required: true, aliases: ['-d'], banner: 'PATH_TO_DESTINATIONS_XML'

    def build
      taxonomy_parser    = TaxonomyParser.new taxonomy_file
      destination_parser = DestinationParser.new destinations_file
      renderer           = DestinationRenderer.new File.read(DEFAULT_TEMPLATE_PATH)
      total              = destination_parser.count
      progress           = create_progress_bar(total)

      ensure_output_directory
      copy_static_assets

      taxonomy_parser.traverse do |node|
        destination = destination_parser.find_by_atlas_id(node.atlas_id)
        html        = renderer.render destination, node
        save_rendered_destination html, destination
        progress.increment
      end

    rescue Exception => e
      say 'A fatal error occurred, aborting.'
      fail e
    end

    desc 'clean', 'Remove generated site'

    def clean
      if yes? "This will delete #{output_directory} and its contents. Are you sure you want to proceed? [yes,no]"
        say "Deleting #{output_directory}"
        FileUtils.rm_rf output_directory
      else
        say "Aborting clean."
      end
    end

    default_task :build

    private

    def output_directory
      options[:output]
    end

    def taxonomy_file
      load_file options[:taxonomy]
    end

    def destinations_file
      load_file options[:destinations]
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
        fail SystemExit
      end
    end

    def save_rendered_destination(html, destination)
      file_name = File.join options[:output], destination.file_name
      File.open file_name, 'w' do |f|
        f.write html
      end
    end
  end
end
