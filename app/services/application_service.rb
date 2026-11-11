# frozen_string_literal: true

# Base para Service Objects.
# Retorna Success/Failure result objects.
class ApplicationService
  def call(*)
    raise NotImplementedError, "#{self.class} must implement #call"
  end

  class SuccessResult
    attr_reader :data

    def initialize(data)
      @data = data
    end

    def success?
      true
    end

    def failure?
      false
    end
  end

  class FailureResult
    attr_reader :errors

    def initialize(errors = [])
      @errors = errors
    end

    def success?
      false
    end

    def failure?
      true
    end
  end
end
