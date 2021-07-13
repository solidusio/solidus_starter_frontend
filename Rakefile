# frozen_string_literal: true

require 'solidus_dev_support/rake_tasks'

ENV['SOLIDUS_STARTER_FRONTEND_ALLOW_AS_ENGINE'] = 'true'
SolidusDevSupport::RakeTasks.install

task default: 'extension:specs'
