window.addEventListener('DOMContentLoaded', () => {
  const radios = document.querySelectorAll('#product-variants input[type="radio"]');
  const thumbnailsLinks = document.querySelectorAll('.js-product-thumbnail a');
  const productImage = document.querySelector('.js-product-main-image');
  const variantsThumbnails = document.querySelectorAll('.js-variant-thumbnail');

  if (radios.length > 0) {
    const selectedRadio = document
      .querySelector('#product-variants input[type="radio"][checked="checked"]');

    updateVariantPrice(selectedRadio);
    updateVariantImages(selectedRadio.value);
  }

  radios.forEach(radio => {
    radio.addEventListener('click', () => {
      updateVariantPrice(radio);
      updateVariantImages(radio.value);
    });
  });

  thumbnailsLinks.forEach(thumbnailLink => {
    thumbnailLink.addEventListener('click', (event) => {
      event.preventDefault();
      updateProductImage(thumbnailLink.href);
    });
  });

  function updateVariantPrice(variant) {
    const variantPrice = variant.dataset.price;
    if (variantPrice) {
      document.querySelector('.price.selling').innerHTML = variantPrice;
    }
  };

  function updateVariantImages(variantId) {
    selector = "[data-js-product-thumbnail-variant-id='" + variantId + "']";
    variantsThumbnailsToDisplay = document.querySelectorAll(selector);

    variantsThumbnails.forEach(thumbnail => {
      thumbnail.style.display = 'none';
    });

    variantsThumbnailsToDisplay.forEach(thumbnail => {
      thumbnail.style.display = 'list-item';
    });

    if(variantsThumbnailsToDisplay.length) {
      variantFirstImage = variantsThumbnailsToDisplay[0].querySelector('a').href
      updateProductImage(variantFirstImage);
    }
  };

  function updateProductImage(imageSrc) {
    productImage.src = imageSrc;
  }
});
