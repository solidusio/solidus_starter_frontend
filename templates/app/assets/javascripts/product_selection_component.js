document.addEventListener("DOMContentLoaded", function () {
  "use strict"

  const optionTypeSelector = document.querySelectorAll(".selection-items")
  for (var i = 0; i < optionTypeSelector.length; i++) {
    optionTypeSelector[i].addEventListener("click", onSelection)
  }
  const firstVariant = document.querySelector("[data-option-index]")
  if (firstVariant) {
    setTimeout(() => {
      firstVariant.click()
    }, 1)
  }
})

function onSelection(event) {
  document.getElementById(`selected-${event.target.name}`).innerText =
    event.target.dataset.presentation

  const optionIndex = event.target.attributes["data-option-index"].value
  const nextType = document.querySelector(
    `[data-option-index="${parseInt(optionIndex, 10) + 1}"]`,
  )
  if (nextType) {
    updateOptions(nextType.name, optionIndex)
  }
  selectVariant()
}

function updateOptions(nextTypeName, optionIndex) {
  const nextOptionValues = this.nextOptionValues(optionIndex)

  let firstRadio = null
  const allNextOptions = [
    ...document.querySelectorAll(`[name="${nextTypeName}"]`),
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

  const nextSelectedRadio = document.querySelector(
    `[name="${nextTypeName}"]:checked`,
  )
  if (nextSelectedRadio.disabled) {
    firstRadio.click()
  } else {
    nextSelectedRadio.click()
  }
}

function nextOptionValues(optionIndex) {
  const values = []
  const variantOptionsTargets = document.querySelectorAll(
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

function selectVariant() {
  this.variant = document.querySelector(
    `[data-option-value-ids="${JSON.stringify(this.currentSelection())}"]`,
  )
  if (this.variant) {
    this.variant.click()
    document.querySelector("#product-price").innerHTML =
      this.variant.dataset.price
  } else {
    this.priceTarget.innerText =
      "Not found, please select all optionTypeSelector"
  }
}

function currentSelection() {
  let i = 0
  const selectionArr = []
  while (document.querySelector(`[data-option-index="${i}"]`)) {
    selectionArr.push(
      parseInt(
        document.querySelector(`[data-option-index="${i}"]:checked`).value,
        10,
      ),
    )
    i += 1
  }
  return selectionArr
}
