Spree.ready(function($) {
  Spree.updateVariantPrice = function(variant) {
    var variantPrice = variant.data("price");
    if (variantPrice) {
      $(".price.selling").text(variantPrice);
    }
  };

  var radios = $('#product-variants input[type="radio"]');
  if (radios.length > 0) {
    var selectedRadio = $(
      '#product-variants input[type="radio"][checked="checked"]'
    );
    Spree.updateVariantPrice(selectedRadio);
  }

  radios.click(function(event) {
    Spree.updateVariantPrice($(this));
  });
});
