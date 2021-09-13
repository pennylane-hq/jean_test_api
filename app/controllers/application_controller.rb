class ApplicationController < ActionController::API
  load_resource except: %i[schema]
  before_action :set_json_format
  before_action :load_session, prepend: true, except: %i[schema]

  class NoSessionError < Exception
  end

  def index
    render html: "Veuillez vous référer à l'énoncé pour ce qui concerne l'utilisation de l'API"
  end

  def schema
    render json: YAML.safe_load(
      File.read(
        Rails.root.join('schema.yml').to_s,
      ),
    ).as_json
  end

  rescue_from ActiveRecord::RecordNotDestroyed do |exception|
    message = exception.record.errors.details.values.flatten.map(&:values).flatten.first

    render(
      json: {
        message: message,
      },
      status: :unprocessable_entity,
    )
  end

  rescue_from ActiveRecord::RecordInvalid do |exception|
    render(
      json: {
        message: exception.message,
        details: exception.record.errors.details,
      },
      status: :unprocessable_entity,
    )
  end

  rescue_from NoSessionError do
    render plain: 'X-SESSION header is missing or invalid', status: :bad_request
  end

  private

  def pagination_params
    page = (params[:page].presence || 1).to_i
    per_page = (params[:per_page].presence || 25).to_i
    {
      page: page <= 0 ? 1 : page,
      per_page: per_page <= 0 ? 25 : per_page,
    }
  end

  def search_params
    JSON.parse(params[:filter], symbolize_names: true)
  rescue
    []
  end

  def set_json_format
    request.format = :json
  end

  def current_user; end

  def load_session
    @session = Session.find_by(token: request.headers['X-SESSION'])
    return if Rails.env.test?

    raise NoSessionError unless @session.present?
  end
end
