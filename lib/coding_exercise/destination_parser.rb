class DestinationParser
  attr_reader :xml

  def initialize(file)
    @xml = file && Nokogiri.XML(file) { |config| config.strict.noblanks }
  end

  def valid?
    xml && xml.validate.nil?
  end

  def destinations
    xml.xpath('//destination').lazy.map { |node| Destination.new node }
  end
end