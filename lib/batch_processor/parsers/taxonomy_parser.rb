require 'nokogiri'
module BatchProcessor
  class TaxonomyParser
    attr_reader :xml

    def initialize(file)
      @xml = file && Nokogiri.XML(file) { |config| config.strict.noblanks }
    end

    def valid?
      xml && xml.validate.nil?
    end

    def taxonomies
      xml.xpath('//taxonomy').lazy.map { |node| Taxonomy.new node }
    end

    def traverse(&block)
      taxonomies.each { |taxonomy| taxonomy.traverse &block }
    end

  end
end
