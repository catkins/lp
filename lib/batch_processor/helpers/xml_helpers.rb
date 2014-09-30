module XmlHelpers
  module ClassMethods

    def xml_attributes(*attributes)
      attributes.each do |attribute|
        define_method(attribute) do
          xml.attr(attribute.to_s).to_s
        end
      end
    end

  end

  def self.included(receiver)
    receiver.extend ClassMethods
  end
end
