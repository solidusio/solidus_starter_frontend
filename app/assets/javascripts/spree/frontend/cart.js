window.addEventListener('DOMContentLoaded', () => {
  const cartForm = document.getElementById('update-cart')

  if (cartForm) {
    const deleteButtons = cartForm.querySelectorAll('[data-module="cart-item-remove"]')

    deleteButtons.forEach((deleteButton) => {
      deleteButton.addEventListener('click', () => {
        const lineItem = deleteButton.parentNode.parentNode
        lineItem.querySelector('[data-module="cart-item-quantity"] input').setAttribute('value', 0)
      })
    })

    cartForm.addEventListener('submit', () => {
      document.getElementById('update-button').setAttribute('disabled', true)
    })
  }
})

Solidus.fetch_cart = (cartLinkUrl) => {
  fetch(cartLinkUrl || Solidus.pathFor('cart_link'))
    .then((response) => response.text())
    .then((html) => {
      document.getElementById('link-to-cart').innerHTML = html
    })
}
