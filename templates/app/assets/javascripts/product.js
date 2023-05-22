class ProductController {
  constructor(element) {
    this.element = document.querySelector(".product-page")

    this.radioTargets = this.element.querySelectorAll("[data-js='variant-radio']")
    this.productImageTarget = this.element.querySelector(
      "[data-js='product-main-image']",
    )
    this.variantsThumbnailTargets = this.element.querySelectorAll(
      "[data-js='variant-thumbnail']",
    )
    this.priceTarget = this.element.querySelector("[data-js='price']")
  }

  connected() {
    this.radioSelected()
  }

  selectThumbnail(event) {
    console.log("selectThumbnail", event)
    event.preventDefault()
    this.productImageTarget.src = event.currentTarget.href
  }

  radioSelected() {
    console.log("radioSelected")
    if (this.radioTargets.length === 0) return

    const selectedRadio = Array.from(this.radioTargets).filter((e) => e.checked)[0]
    const variantPrice = selectedRadio.dataset.jsPrice
    const variantId = selectedRadio.value

    console.log("selectedRadio", selectedRadio)

    if (variantPrice) {
      this.priceTarget.innerHTML = variantPrice
    }

    const variantsThumbnailsToDisplay = Array.from(this.variantsThumbnailTargets).filter(
      (e) => e.dataset.jsId.toString() === variantId.toString(),
    )

    this.variantsThumbnailTargets.forEach((thumbnail) => {
      thumbnail.style.display = "none"
    })

    variantsThumbnailsToDisplay.forEach((thumbnail) => {
      thumbnail.style.display = "list-item"
    })

    if (variantsThumbnailsToDisplay.length) {
      const variantFirstImage =
        variantsThumbnailsToDisplay[0].querySelector("a").href
      this.productImageTarget.src = variantFirstImage
    }
  }
}

window.addEventListener("DOMContentLoaded", () => {
  const controller = new ProductController()
  console.log(controller)

  controller.radioTargets.forEach((radio) =>
    radio.addEventListener("click", () => controller.radioSelected()),
  )

  document
    .querySelectorAll(
      "[data-js='product-thumbnail'] a, [data-js='variant-thumbnail'] a",
    )
    .forEach((thumbnailLink) => {
      thumbnailLink.addEventListener("click", (e) =>
        controller.selectThumbnail(e),
      )
    })
})
