import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    step: String,
  }

  // actions

  beforeSubmit(event) {
    if (this.stepValue === 'payment') {
      this.disableSubmitButtons()
    } else if (this.stepValue === 'confirm') {
      this.disableSubmitButtons()
    }
  }

  // private

  disableSubmitButtons() {
    const elements = this.element.querySelectorAll('[type="submit"], [type="image"]');
    elements.forEach((element) => element.setAttribute("disabled", true))
  }
}