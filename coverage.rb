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

SimpleCov.start do
  root ENV['COVERAGE_ROOT'] || File.expand_path('..', SimpleCov.root) # up one level
  enable_for_subprocesses true
  enable_coverage_for_eval
  add_filter %r{sandbox/(db|config|spec|tmp)/}
  track_files "#{SimpleCov.root}/{template.rb,sandbox/**/*.{erb,rb}}"

  at_fork do |pid|
    SimpleCov.start do
      command_name "#{command_name} (subprocess: #{pid})"

      # Be quiet, the parent process will be in charge of output and checking coverage totals.
      print_error_status = false
      formatter SimpleCov::Formatter::SimpleFormatter
      minimum_coverage 0
    end
  end
end
