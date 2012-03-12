require "http_link_header/version"
require "http_link_header/http_link_params"

class HttpLinkHeader < ::Hash
  DELIMETER = ','

  def initialize(link_header = [])
    link_header = link_header.split(DELIMETER) if link_header.is_a?(String)
    link_header.each { |link_value| add(link_value) }
  end

  def [](uri_reference)
    super(uri_reference.to_s)
  end

  def []=(uri_reference, link_params)
    link_params = nil if link_params && link_params.empty?
    if self[uri_reference]
      self[uri_reference].add(link_params) unless link_params.nil?
    else
      super(uri_reference.to_s, link_params.nil? ? nil : HttpLinkParams.new(link_params))
    end
  end

  def add(link_value)
    if link_value_match = link_value.strip.match(/\A<([^>]+)>\s*(;\s*(.*))?\z/)
      uri_reference, link_params = link_value_match.values_at(1, 3)
      self[uri_reference.strip] = link_params ? link_params.strip : nil
    else
      raise ArgumentError, "invalid link-value: #{link_value}"
    end
  end

  def to_a
    map do |uri_reference, link_params|
      link_value = "<#{uri_reference}>"
      link_value << "#{HttpLinkParams::DELIMETER} #{link_params.to_s}" if link_params && !link_params.empty?
      link_value
    end
  end

  def to_s
    to_a.join("#{DELIMETER} ")
  end

  # Define methods for each relation type attribute to find URIs that have
  # the respective attribute set to the specified relation type.
  #
  HttpLinkParams::RELATION_TYPE_ATTRIBUTES.each do |relation_type_attribute|
    class_eval(<<-RELATION_TYPE_METHOD, __FILE__, __LINE__ + 1)
      def #{relation_type_attribute}(relation_type)
        each do |uri_reference, link_params|
          if (relation_types = link_params[#{relation_type_attribute.inspect}]) && relation_types.include?(relation_type.to_s)
            return uri_reference
          end
        end
        nil
      end
    RELATION_TYPE_METHOD
  end

end
