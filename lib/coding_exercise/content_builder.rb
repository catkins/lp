class ContentBuilder
  attr_reader :title, :xml, :sections

  class << self
    def build(title, xml, &block)
      builder = ContentBuilder.new(xml)
      builder.instance_eval &block
    end
  end

  def section(section_title, path = nil, &block)
    level = 1
    section = Section.new section_title, path, xml, level

    section.instance_eval(&block) if block_given?
    sections << section unless section.empty?
  end

  def initialize(xml)
    @xml = xml
    @sections = []
  end

  class Section
    attr_reader :title, :path, :sub_sections, :xml, :level

    def initialize(title, path, xml, level)
      @title = title
      @path = path
      @xml = xml
      @level = level
      @sub_sections = []
    end

    def empty?
      false
    end

    def paragraphs
      if path
        @paragraphs ||= xml.xpath(path).map(&:text) || []
      else
        []
      end
    end

    def section(title, path = nil, &block)
      sub_section = Section.new title, path, xml, (level + 1)

      sub_section.instance_eval(&block) if block_given?

      sub_sections << sub_section unless sub_section.empty?
    end
  end
end

