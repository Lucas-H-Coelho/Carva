# frozen_string_literal: true

# Base para Value Objects — imutáveis, comparáveis por valor.
class ApplicationValueObject
  attr_reader :attributes

  def initialize(attributes)
    @attributes = attributes.freeze
  end

  def ==(other)
    other.is_a?(self.class) && attributes == other.attributes
  end

  def hash
    attributes.hash
  end

  def as_json(*)
    attributes
  end
end
