import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["submitButton", "billingAddressToggle"]
  static values = {
    step: String,
    submitting: String,
    termsRequired: String,
  }
  static outlets = ["address"]

  beforeSubmit(event) {
    if (this.stepValue === 'payment') {
      this.submitButtonTarget.setAttribute('disabled', true)
    } else if (this.stepValue === 'confirm') {
      if (this.termsCheckboxTarget.checked) {
        this.submitButtonTarget.setAttribute('disabled', true)
        submitButton.innerHTML = this.submittingValue
      } else {
        event.preventDefault()
        alert(this.termsRequiredValue)
        submitButton.removeAttribute('disabled')
        submitButton.classList.remove('disabled')
      }
    }
  }

  addressOutletConnected(outlet, element) {
    this.toggleAddress()
  }

  toggleAddress() {
    const useBillingAddressForShipping = this.billingAddressToggleTarget.checked

    if (useBillingAddressForShipping) {
      this.addressOutlet.disabledValue = true
    } else {
      this.addressOutlet.disabledValue = false
    }
  }
}
