bundle update --bundler # ensure bundler version is high enough for Gemfile.lock
bundle config path vendor/bundle
bundle install --jobs 8 --retry 3
bundle --version
bundle exec pod --version
