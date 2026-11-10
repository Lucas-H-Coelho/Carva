# frozen_string_literal: true

module Carva
  module Core
    class Engine < ::Rails::Engine
      isolate_namespace Carva::Core

      # Prevent ActiveRecord from being loaded before the main app

    end
  end
end
