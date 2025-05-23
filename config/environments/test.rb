require "active_support/core_ext/integer/time"

# The test environment is used exclusively to run your application's
# test suite. You never need to work with it otherwise. Remember that
# your test database is "scratch space" for the test suite and is wiped
# and recreated between test runs. Don't rely on the data there!

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  ENV['CREDENTIALS_PRIVATE_KEY'] = <<~TXT
    -----BEGIN RSA PRIVATE KEY-----
    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
    -----END RSA PRIVATE KEY-----
  TXT
  # Turn false under Spring and add config.action_view.cache_template_loading = true.
  config.cache_classes = true

  # Eager loading loads your whole application. When running a single test locally,
  # this probably isn't necessary. It's a good idea to do in a continuous integration
  # system, or in some way before deploying your code.
  config.eager_load = ENV["CI"].present?

  # Configure public file server for tests with Cache-Control for performance.
  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    "Cache-Control" => "public, max-age=#{1.hour.to_i}"
  }

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  config.cache_store = :null_store

  # Raise exceptions instead of rendering exception templates.
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment.
  config.action_controller.allow_forgery_protection = false

  # Store uploaded files on the local file system in a temporary directory.
  config.active_storage.service = :test

  config.action_mailer.perform_caching = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # Print deprecation notices to the stderr.
  config.active_support.deprecation = :stderr

  # Raise exceptions for disallowed deprecations.
  config.active_support.disallowed_deprecation = :raise

  # Tell Active Support which deprecation messages to disallow.
  config.active_support.disallowed_deprecation_warnings = []

  # Raises error for missing translations.
  # config.i18n.raise_on_missing_translations = true

  # Annotate rendered view with file names.
  # config.action_view.annotate_rendered_view_with_filenames = true
end
