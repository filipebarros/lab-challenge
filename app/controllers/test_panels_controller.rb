# frozen_string_literal: true

# testk
class TestPanelsController < ApplicationController
  def show
    id = params.fetch(:id)
    included = params[:include]

    json_api = TestPanel.to_jsonapi(id: id, included: included)
    render json: json_api
  end
end
