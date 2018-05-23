# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Error::ErrorHandler

  def index; end
end
