Spree.ready(function($) {
  Spree.onPayment = function() {
    if ($("#checkout_form_payment").is("*")) {
      if ($("#existing_cards").is("*")) {
        $("#payment-method-fields").hide();
        $(".payment-method-controls").hide();

        $("#use_existing_card_yes").click(function() {
          $("#payment-method-fields").hide();
          $(".payment-method-controls").hide();
          $(".existing-cc-radio").prop("disabled", false);
        });

        $("#use_existing_card_no").click(function() {
          $("#payment-method-fields").show();
          $(".payment-method-controls").show();
          $(".existing-cc-radio").prop("disabled", true);
        });
      }

      $("#card_number").payment("formatCardNumber");
      $("#card_expiry").payment("formatCardExpiry");
      $("#card_code").payment("formatCardCVC");

      $("#card_number").change(function() {
        $(this)
          .parent()
          .siblings(".ccType")
          .val($.payment.cardType(this.value));
      });

      $(
        'input[type="radio"][name="order[payments_attributes][][payment_method_id]"]'
      ).click(function() {
        $(".payment-method-controls li").hide();
        if (this.checked) {
          $("#payment_method_" + this.value).show();
        }
      });

      // Activate already checked payment method if form is re-rendered
      // i.e. if user enters invalid data
      $('input[type="radio"]:checked').click();
    }
  };
  Spree.onPayment();
});
