require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  ENV['CREDENTIALS_PRIVATE_KEY'] = <<~TXT
    -----BEGIN RSA PRIVATE KEY-----
    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
    -----END RSA PRIVATE KEY-----
  TXT

  # In the development environment your application's code is reloaded any time
  # it changes. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable server timing
  config.server_timing = true

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if Rails.root.join("tmp/caching-dev.txt").exist?
    config.cache_store = :memory_store
    config.public_file_server.headers = {
      "Cache-Control" => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Store uploaded files on the local file system (see config/storage.yml for options).
  config.active_storage.service = :local

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise exceptions for disallowed deprecations.
  config.active_support.disallowed_deprecation = :raise

  # Tell Active Support which deprecation messages to disallow.
  config.active_support.disallowed_deprecation_warnings = []

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true


  # Raises error for missing translations.
  # config.i18n.raise_on_missing_translations = true

  # Annotate rendered view with file names.
  # config.action_view.annotate_rendered_view_with_filenames = true

  # Uncomment if you wish to allow Action Cable access from any origin.
  # config.action_cable.disable_request_forgery_protection = true
end
