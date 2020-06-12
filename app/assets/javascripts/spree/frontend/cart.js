Spree.ready(() => {
  const cartForm = document.getElementById('update-cart');

  if (cartForm) {
    const deleteButtons = cartForm.querySelectorAll('input.delete');

    deleteButtons.forEach(deleteButton => {
      deleteButton.addEventListener('click', () => {
        const lineItem = deleteButton.parentNode.parentNode;
        lineItem.querySelector('.cart-item__quantity input').setAttribute('value', 0);
      });
    });

    cartForm.addEventListener('submit', () => {
      document.getElementById('update-button').setAttribute('disabled', true);
    });
  }
});

Spree.fetch_cart = (cartLinkUrl) => {
  fetch(cartLinkUrl || Spree.pathFor('cart_link'))
    .then(response => response.text())
    .then(html => {
      document.getElementById('link-to-cart').innerHTML = html;
    });
};
