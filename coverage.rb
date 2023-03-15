require 'coverage'
require 'simplecov'

if ENV['CODECOV_TOKEN']
  require 'codecov'

  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
    SimpleCov::Formatter::Codecov,
    SimpleCov.formatter,
  ])
else
  warn "Provide a CODECOV_TOKEN environment variable to enable Codecov uploads"
end

COVERAGE_ROOT = ENV['COVERAGE_ROOT'] || File.expand_path "#{__dir__}/.."

SimpleCov.start do
  root COVERAGE_ROOT
  enable_for_subprocesses true
  enable_coverage_for_eval
  add_filter %r{sandbox/(db|config|spec|tmp)/}
  track_files "#{SimpleCov.root}/{template.rb,sandbox/**/*.{erb,rb}}"
end
