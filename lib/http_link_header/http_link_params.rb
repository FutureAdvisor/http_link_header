require 'set'

class HttpLinkHeader::HttpLinkParams < ::Hash
  DELIMETER = ';'
  RELATION_TYPE_ATTRIBUTES = ::Set['rel', 'rev']

  class RelationTypes < ::Set

    def initialize(relation_types)
      if relation_types.is_a?(Enumerable)
        super(relation_types)
      elsif relation_types.is_a?(String)
        super()
        add(relation_types)
      else
        raise ArgumentError, "invalid relation-types: #{relation_types}"
      end
    end

    def add(relation_types)
      relation_types.strip.gsub!(/\A"|"\z/, '').split(' ').each do |relation_type|
        relation_type = relation_type.strip
        super(relation_type.downcase) unless relation_type.empty?
      end
    end

    def include?(relation_type)
      super(relation_type.downcase)
    end

    def to_s
      %Q{"#{to_a.join(' ')}"}
    end

  end

  def initialize(link_params)
    add(link_params)
  end

  def [](attribute)
    super(attribute.to_s)
  end

  def []=(attribute, value)
    if RELATION_TYPE_ATTRIBUTES.include?(attribute.to_s)
      if self[attribute]
        self[attribute].add(value)
      else
        super(attribute.to_s, RelationTypes.new(value))
      end
    else
      super(attribute.to_s, value)
    end
  end

  def add(link_params)
    link_params.split(DELIMETER).each do |link_param|
      link_param.strip!
      next if link_param.empty?

      if link_param_match = link_param.match(/\A([\w!#\$&\+\-\.\^`\|~]+\*?)\s*(=\s*(.*))?\z/)
        attribute, value = link_param_match.values_at(1, 3)
        self[attribute.strip] = value ? value.strip : nil
      else
        raise ArgumentError, "invalid link-param: #{link_param}"
      end
    end
  end

  def to_a
    map { |attribute, value| value ? "#{attribute}=#{value.to_s}" : attribute }
  end

  def to_s
    to_a.join("#{DELIMETER} ")
  end

end
