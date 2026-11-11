# frozen_string_literal: true

# Base para Form Objects.
class ApplicationForm
  include ActiveModel::Validations
  include ActiveModel::Conversion

  def initialize(attributes = {})
    @attributes = attributes
    attributes.each do |name, value|
      send("#{name}=", value) if respond_to?("#{name}=")
    end
  end

  def persist
    raise NotImplementedError, "#{self.class} must implement #persist"
  end

  def to_model
    self
  end

  def model_name
    ActiveModel::Name.new(self.class)
  end
end
