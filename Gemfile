source 'https://rubygems.org'

gem 'rails', '3.2.11'
gem 'activerecord-postgres-array' # TODO: getting rid after update to Rails 4

gem 'pg'
# gem "devise"
gem "haml-rails"
gem 'jquery-rails'
# gem "has_scope"
gem 'anjlab-bootstrap-rails', ">= 2.3", require: 'bootstrap-rails'

gem 'meta-tags', require: "meta_tags"
gem 'simple_form'

gem 'battle', '~> 0.0.3'

group :assets do
  gem 'sass-rails',   '~> 3.2.6'
  gem 'coffee-rails', '~> 3.2.2'
  gem 'uglifier',     '>= 1.3.0'
  gem "therubyracer"
end

group :development do
  gem "capistrano",         require: false
  gem 'capistrano-recipes', require: false
  gem 'capistrano_colors',  require: false
  gem "erb2haml"
  gem "rails_best_practices"
  gem "thin"
  gem 'bullet'
end

group :development, :test do
  gem 'rspec-rails',        '~> 2.12.2'
  gem 'factory_girl_rails', '~> 4.1.0'
  gem "pry-rails"
end

group :test do
  gem "ffaker", "~> 1.15.0"
  gem "launchy"
  gem 'capybara', '~> 2.1.0'
  gem "database_cleaner"
  gem "shoulda"
  gem "email_spec"
  gem 'vcr', '~> 2.4.0'
  gem 'webmock'
end
