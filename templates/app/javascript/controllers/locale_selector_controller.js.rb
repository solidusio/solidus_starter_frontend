class LocaleSelector < Stimulus::Controller
  self.targets = [:selector]

  actions do
    def submit_form
      selector_target.form.submit
    end
  end
end
