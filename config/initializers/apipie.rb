Apipie.configure do |config|
  config.app_name                = "JeanTestApi"
  config.api_base_url            = ""
  config.doc_base_url            = "/apipie"
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/**/*.rb"
  config.reload_controllers = false
  config.show_all_examples = 1
  config.translate = false
  config.default_locale = nil
end

module ApipieRecorderPatch
  def record
    super.try(:merge, title: RSpec.current_example.full_description)
  end
end

class Apipie::Extractor::Recorder
  prepend ApipieRecorderPatch
end
