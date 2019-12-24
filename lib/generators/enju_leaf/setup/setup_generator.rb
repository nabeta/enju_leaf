class EnjuLeaf::SetupGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)
  desc "Create a setup file for Next-L Enju"

  def copy_setup_files
    directory("solr", "example/solr")
    copy_file("Procfile", "Procfile")
    copy_file("config/schedule.rb", "config/schedule.rb")
    append_to_file("config/initializers/assets.rb", "Rails.application.config.assets.precompile += %w( *.png )")
    inject_into_class 'config/application.rb', 'Application' do
      <<"EOS"
    config.i18n.available_locales = [:en, :ja]
    config.i18n.enforce_available_locales = true
    config.active_job.queue_adapter = :resque
    config.i18n.default_locale = :ja
    config.time_zone = 'Tokyo'
EOS
    end
    gsub_file 'config/schedule.rb', /\/path\/to\/enju_leaf/, Rails.root.to_s
    append_to_file("Rakefile", "require 'resque/tasks'\n")
    append_to_file("db/seeds.rb", File.open(File.expand_path('../templates', __FILE__) + '/db/seeds.rb').read)
    application(nil, env: "development") do
      "config.action_mailer.default_url_options = {host: 'localhost:3000'}\n"
    end
    application(nil, env: "test") do
      "config.action_mailer.default_url_options = {host: 'localhost:3000'}\n"
    end
    application(nil, env: "production") do
      "config.action_mailer.default_url_options = {host: 'localhost:3000'}\n"
    end
    inject_into_class "app/controllers/application_controller.rb", ApplicationController do
      <<"EOS"
  include EnjuLibrary::Controller
  include EnjuBiblio::Controller

  include Pundit
  before_action :set_paper_trail_whodunnit
  after_action :verify_authorized, unless: :devise_controller?
EOS
    end
    generate("devise:install")
    generate("devise", "User")
    gsub_file 'app/models/user.rb', /, :validatable$/, <<EOS
, # :validatable,
      :lockable, lock_strategy: :none, unlock_strategy: :none
  include EnjuSeed::EnjuUser
EOS
    generate("sunspot_rails:install")
    generate("kaminari:config")
    generate("simple_form:install")
    generate("geocoder:config")
    gsub_file "config/sunspot.yml",
      /path: \/solr\/production/,
      "path: /solr/default"
    gsub_file 'config/initializers/kaminari_config.rb',
      /# config.default_per_page = 25$/,
      "config.default_per_page = 10"
    gsub_file "app/assets/javascripts/application.js",
      /\/\/= require turbolinks$/,
      ""
    gsub_file 'app/controllers/application_controller.rb', /protect_from_forgery with: :exception$/, 'protect_from_forgery with: :exception, prepend: true'

    inject_into_file "app/helpers/application_helper.rb", after: /module ApplicationHelper$\n/ do
      <<"EOS"
  include EnjuLeaf::ApplicationHelper
  include EnjuBiblio::ApplicationHelper if defined?(EnjuBiblio)
  if defined?(EnjuManifestationViewer)
    include EnjuManifestationViewer::ApplicationHelper
    include EnjuManifestationViewer::BookJacketHelper
  end
EOS
    end

    inject_into_file "app/assets/javascripts/application.js", after: /\/\/= require rails-ujs$\n/ do
      <<"EOS"
//= require enju_leaf/application
//= require jquery/dist/jquery
EOS
    end
    inject_into_file "app/assets/stylesheets/application.css", after: / *= require_self$\n/ do
      " *= require enju_leaf\n"
    end
    inject_into_file "config.ru", after: /require ::File.expand_path\(\'..\/config\/environment\',  __FILE__\)$\n/ do
      <<"EOS"
require 'rack/protection'
use Rack::Protection, except: [:escaped_params, :json_csrf, :http_origin, :session_hijacking, :remote_token]
EOS
    end
    remove_file "public/index.html"
    remove_file "app/views/layouts/application.html.erb"
    gsub_file 'config/environments/production.rb',
      /config.serve_static_assets = false$/,
      "config.serve_static_assets = true"
    gsub_file 'config/environments/production.rb',
      /# config.cache_store = :mem_cache_store$/,
      "config.cache_store = :redis_cache_store, { url: ENV['REDIS_URL'], expires_in: 1.day }"
    gsub_file 'config/environments/production.rb',
      /# config.assets.precompile \+= %w\( search.js \)$/,
      "config.assets.precompile += %w( mobile.js mobile.css print.css )"
  end
end
