module TemplateHelpers
  module ClassMethods

  end

  module InstanceMethods
    def render_section(section)
      buffer = ""
      return buffer if section.empty?

      buffer.tap do |b|
        b << render_heading_for_section(section)
        b << render_paragraphs(section.paragraphs)

        section.sub_sections.each do |sub|
          b << render_section(sub)
        end
      end
    end

    def render_heading_for_section(section)
      tag_name = "h#{section.level}"
      "<#{tag_name}>#{ html_escape section.title }</#{tag_name}>"
    end

    def render_paragraphs(paragraphs)
      paragraphs.map do |paragraph|
        "<p>#{ html_escape paragraph }</p>"
      end.join "\n"
    end
  end

  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, ERB::Util
    receiver.send :include, InstanceMethods
  end
end
