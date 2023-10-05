window.addEventListener("DOMContentLoaded", () => {
  "use strict"
  const controller = new ProductSelectionController(
    document.querySelector(".product-page"),
  )

  controller.optionValueTargets.forEach((optionType) => {
    optionType.addEventListener("click", (e) => controller.onSelection(e))
  })

  const firstVariant = document.querySelector("[data-option-index]")
  if (firstVariant) {
    setTimeout(() => {
      firstVariant.click()
    }, 1)
  }
})

class ProductSelectionController {
  constructor(element) {
    this.element = element
    this.optionValueTargets = Array.from(
      this.element.querySelectorAll(
        "[data-product-target]='option-value-input']",
      ),
    )
  }

  onSelection(event) {
    this.element.querySelector(`#selected-${event.target.name}`).innerText =
      event.target.dataset.presentation

    const optionIndex = event.target.attributes["data-option-index"].value
    const nextType = this.element.querySelector(
      `[data-option-index="${parseInt(optionIndex, 10) + 1}"]`,
    )
    if (nextType) {
      this.updateOptions(nextType.name, optionIndex)
    }
    this.selectVariant()
  }

  updateOptions(nextTypeName, optionIndex) {
    const nextOptionValues = this.nextOptionValues(optionIndex)

    let firstRadio = null
    const allNextOptions = [
      ...this.element.querySelectorAll(`[name="${nextTypeName}"]`),
    ]
    allNextOptions.forEach((radio) => {
      if (!nextOptionValues.includes(parseInt(radio.value, 10))) {
        radio.disabled = true
        radio.parentElement.classList.add("d-hide")
      } else {
        radio.disabled = false
        radio.parentElement.classList.remove("d-hide")
        if (!firstRadio) {
          firstRadio = radio
        }
      }
    })

    const nextSelectedRadio = this.element.querySelector(
      `[name="${nextTypeName}"]:checked`,
    )
    if (nextSelectedRadio.disabled) {
      firstRadio.click()
    } else {
      nextSelectedRadio.click()
    }
  }

  nextOptionValues(optionIndex) {
    const values = []
    const variantOptionsTargets = this.element.querySelectorAll(
      ".product-variants__list > li > input",
    )
    variantOptionsTargets.forEach((option) => {
      const optionValueIds = JSON.parse(
        option.attributes["data-option-value-ids"].value,
      )
      const selectedOptionIds = this.currentSelection()
      let matched = true
      for (let i = 0; i <= optionIndex; i += 1) {
        if (optionValueIds[i] !== selectedOptionIds[i]) {
          matched = false
          break
        }
      }
      if (matched) {
        values.push(optionValueIds[parseInt(optionIndex, 10) + 1])
      }
    })
    return values
  }

  selectVariant() {
    this.variant = this.element.querySelector(
      `[data-option-value-ids="${JSON.stringify(this.currentSelection())}"]`,
    )
    if (this.variant) {
      this.variant.click()
      this.element.querySelector("#product-price").innerHTML =
        this.variant.dataset.price
    } else {
      this.priceTarget.innerText =
        "Not found, please select all optionTypeSelector"
    }
  }

  currentSelection() {
    let i = 0
    const selectionArr = []
    while (this.element.querySelector(`[data-option-index="${i}"]`)) {
      selectionArr.push(
        parseInt(
          this.element.querySelector(`[data-option-index="${i}"]:checked`)
            .value,
          10,
        ),
      )
      i += 1
    }
    return selectionArr
  }
}
