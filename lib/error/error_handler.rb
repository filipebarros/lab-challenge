# frozen_string_literal: true

module Error
  module ErrorHandler
    def self.included(clazz)
      clazz.class_eval do
        rescue_from TestPanel::RecordNotFound do |e|
          respond(:test_panel_not_found, 404, e.to_s)
        end
      end
    end

    private

    def respond(error, status, message)
      json = Helpers::Render.json(error, status, message)
      render json: json, status: status
    end
  end
end
