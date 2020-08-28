window.addEventListener('DOMContentLoaded', () => {
  function updateVariantPrice(variant) {
    const variantPrice = variant.dataset.price
    const priceEl = document.querySelector('[data-module="product-price"]')

    if (variantPrice) {
      priceEl.innerHTML = variantPrice
    }
  }

  const radios = document.querySelectorAll('#product-variants input[type="radio"]')

  if (radios.length > 0) {
    const selectedRadio = document.querySelector('#product-variants input[type="radio"][checked="checked"]')

    updateVariantPrice(selectedRadio)
  }

  radios.forEach((radio) => {
    radio.addEventListener('click', () => updateVariantPrice(radio))
  })
})
