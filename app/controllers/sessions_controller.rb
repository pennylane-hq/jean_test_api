# frozen_string_literal: true

class SessionsController < ApplicationController
  include ActionController::HttpAuthentication::Token::ControllerMethods

  skip_load_resource only: [:create]
  skip_before_action :load_session, only: [:create]
  before_action :verify_token!, only: [:create]

  def create
    name = params.require(:name)
    existing_session = Session.find_by(name: name)
    session = existing_session || Sessions::CreateService.call(name)

    render json: { id: session.id, token: session.token }, status: existing_session ? :ok : :created
  end

  private

  def verify_token!
    token = request.headers['Authorization']&.split&.last
    return if token == ConfigManager::Secret.api_tokens.jeancaisse

    raise InvalidTokenError
  end
end
