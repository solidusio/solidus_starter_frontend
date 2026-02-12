RSpec.configure do |config|
  config.use_transactional_fixtures = false
  config.before :suite do
    DatabaseCleaner.clean_with :truncation
  end

  # Set database cleaner strategy before test data is created
  config.before(:each) do |example|
    DatabaseCleaner.strategy = example.metadata[:js] ? :truncation : :transaction
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
