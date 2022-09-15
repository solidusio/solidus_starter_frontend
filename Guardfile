guard :shell do
  watch %r{^templates/(.*)$} do
    # We don't run rsync with --delete because this would delete files in the
    # sandbox that are not in the templates. These would be files installed by
    # `rails new` and by `solidus:install` prior to installing the frontend
    # files from the templates.
    rspec_command = %Q{
      rsync \
        --archive \
        --exclude='config/routes.rb' \
        --verbose \
        templates/ \
        sandbox
    }

    system(rspec_command)
  end
end
