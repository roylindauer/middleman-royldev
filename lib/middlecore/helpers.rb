# frozen_string_literal: true

module Middlecore
  module Helpers
    def button(url, additional_classes: "", &block)
      link_to url, class: "button #{additional_classes}", &block
    end

    # Add other common helpers here
  end
end
