var selectedCombination = [];
var selectedCombination = [];
var globalQuantity = 0;
var colors = [];
var original_url = window.location + '';
var first_url_check = true;
var firstTime = true;


//check if a function exists
function function_exists(function_name) {
  if (typeof function_name === 'string')
    function_name = this.window[function_name];
  return typeof function_name === 'function';
}

//execute oosHook js code
function oosHookJsCode() {
  for (var i = 0; i < oosHookJsCodeFunctions.length; i++) {
    if (function_exists(oosHookJsCodeFunctions[i]))
      setTimeout(oosHookJsCodeFunctions[i] + '()', 0);
  }
}

function changeBigPictureForProduct(e) {
    var productImageContainer = document.getElementById('productImage');
    if (productImageContainer == null)
        return;

    if (e.target == null || (!e.target.hasAttribute('data-image') && !e.target.hasAttribute('data-embed')))
        return;

    if (e.target.hasAttribute('data-image'))
    {
      // Show an image
      productImageContainer.setAttribute('src', e.target.getAttribute('data-image'));

      // Set link to full image
      var productImageLink = document.getElementById('fullImageLink');
      if (e.target.hasAttribute('data-fullImage') && productImageLink != null) {
        productImageLink.setAttribute('href', e.target.getAttribute('data-fullImage'));
      }

      $('#productImageContainer').show();
      $('#productVideoContainer').html('').hide();
    }
    else if (e.target.hasAttribute('data-embed'))
    {
      // Show a video
      $('#productVideoContainer').html(atob(e.target.getAttribute('data-embed')));

      $('#productImageContainer').hide();
      $('#productVideoContainer').show();
    }

    $('.thumbnail.shown').removeClass('shown');

    $(e.currentTarget).addClass('shown');

    return false;
}

function getCurrentCombinationAttributes() {
    var $attributes = $('#attributes');

    var radio_inputs = $attributes.find('.checked > input[type=radio]').length;
    if (radio_inputs) {
      radio_inputs = '.checked > input[type=radio]';
    } else {
      radio_inputs = 'input[type=radio]:checked';
    }

    var attributeIds = [];

    $attributes.find('select, input[type=hidden], ' + radio_inputs).each(function() {
      attributeIds.push(parseInt($(this).val(), 10));
    });

    return attributeIds;
  }

  function saveCustomization() {
    $('#quantityBackup').val($('#quantity_wanted').val());
    $('#customizationForm').submit();
  }


function checkMinimalQuantity(minimal_quantity) {
  var $qtyWanted = $('#quantity_wanted');
  var $minQtyWantedP = $('#minimal_quantity_wanted_p');

  if ($qtyWanted.val() < minimal_quantity) {
    $minQtyWantedP.css('color', 'red');
  } else {
    $minQtyWantedP.css('color', '#374853');
  }
}

function colorPickerClick(elt) {
  var id_attribute = $(elt).attr('id').replace('color_', '');
  $(elt).parent().parent().children().removeClass('selected');
  $(elt).fadeTo('fast', 1, function() {
    $(this).fadeTo('fast', 0, function() {
      $(this).fadeTo('fast', 1, function() {
        $(this).parent().addClass('selected');
      });
    });
  });
  $(elt).parent().parent().parent().children('.color_pick_hidden').val(id_attribute);
}


/**
 * Update display of the discounts table.
 * @param combination Combination ID.
 */
 function displayDiscounts(combination) {
  // Tables & rows selection
  var quantityDiscountTable = $('#quantityDiscount');
  var combinationsSpecificQuantityDiscount = $('.quantityDiscount_' + combination, quantityDiscountTable);
  var allQuantityDiscount = $('.quantityDiscount_0', quantityDiscountTable);

  // If there is some combinations specific quantity discount, show them, else, if there are some
  // products quantity discount: show them. In case of result, show the category.
  if (combinationsSpecificQuantityDiscount.length) {
    quantityDiscountTable.find('tbody tr').hide();
    combinationsSpecificQuantityDiscount.show();
    quantityDiscountTable.show();
  } else if (allQuantityDiscount.length) {
    allQuantityDiscount.show();
    $('tbody tr', quantityDiscountTable).not('.quantityDiscount_0').hide();
    quantityDiscountTable.show();
  } else {
    quantityDiscountTable.hide();
  }
}



// Update display of the large image
function displayImage($thumbAnchor) {
  $thumbAnchor.click();
  /*
  // Traverse to parent first
  var $thumb = $.extend({}, true, $thumbAnchor);
  $thumb = $thumb.closest('a');
  var imgSrcThickBox;
  var imgSrcLarge;
  if (window.useWebp && Modernizr.webp) {
    //Reversing webp support
    //imgSrcThickBox = $thumb.attr('href').replace('.jpg', '.webp');
    //imgSrcLarge = imgSrcThickBox.replace('thickbox', 'large');
    imgSrcThickBox = $thumb.attr('href');
    imgSrcLarge = imgSrcThickBox.replace('thickbox', 'large');
  } else {
    imgSrcThickBox = $thumb.attr('href');
    imgSrcLarge = imgSrcThickBox.replace('thickbox', 'large');
  }
  var imgTitle = $thumb.attr('title');

  // Target image element
  var $img = $('#bigpic').find('> img');
  if ($img.attr('src') === imgSrcLarge) {
    return;
  }

  $img.attr({
    src: imgSrcLarge,
    srcset: imgSrcLarge,
    alt: imgTitle,
    title: imgTitle
  });

  if (window.useWebp && Modernizr.webp) {
    var $source = $('#bigpic').find('> source');
    if ($source.length) {
      $source.attr({
        src: imgSrcLarge,
        srcset: imgSrcLarge,
        alt: imgTitle,
        title: imgTitle
      });
    }
  }

  // There is no API to change zoom src, need to reinit
  $('#image-block').trigger('zoom.destroy');
  initZoom(imgSrcThickBox);

  $('#views_block').find('li a').removeClass('shown');
  $thumbAnchor.addClass('shown');
  */
}

var thumbSlider = false;
// Change the current product images regarding the combination selected
function refreshProductImages(id_product_attribute) {
  id_product_attribute = parseInt(id_product_attribute, 10) || 0;

  var combinationHash = getCurrentCombinationHash();

  if (typeof window.combinationsHashSet !== 'undefined') {
    var combination = window.combinationsHashSet[combinationHash];
    if (combination) {
      // Show the large image in relation to the selected combination
      if (combination['image'] && combination['image'] != -1) {
        var $thumbAnchor = $('#thumbnail_' + combination['image']);
        displayImage($thumbAnchor);

        if (thumbSlider !== false) {
          var $thumbLi = $thumbAnchor.parent();
          var slideNumber = parseInt($thumbLi.data('slide-num'), 10) || 0;
          thumbSlider.goToSlide(slideNumber);
        }
      }
    }
  }
}


function getCurrentCombinationHash() {
    var attributeIds = getCurrentCombinationAttributes();
    return attributeIds.sort().join('-');
  }

// search the combinations' case of attributes and update displaying of availability, prices, ecotax, and image
function findCombination() {
  var combinationHash = getCurrentCombinationHash();

  // Verify if this combination is the same that the user's choice
  if (typeof window.combinationsHashSet != 'undefined') {
    var combination = window.combinationsHashSet[combinationHash];

    if (combination) {
      if (combination['minimal_quantity'] > 1) {
        $minQtyLabel.html(combination['minimal_quantity']);
        $minQtyP.fadeIn();
        $qtyWanted.val(combination['minimal_quantity']).on('keyup', function() {
          checkMinimalQuantity(combination['minimal_quantity']);
        });
      }
      //combination of the user has been found in our specifications of combinations (created in back office)
      selectedCombination['unavailable'] = false;
      selectedCombination['reference'] = combination['reference'];
      $('#idCombination').val(combination['idCombination']);

      //get the data of product with these attributes
      window.quantityAvailable = combination['quantity'];
      selectedCombination['price'] = combination['price'];
      selectedCombination['unit_price'] = combination['unit_price'];
      selectedCombination['specific_price'] = combination['specific_price'];
      if (combination['ecotax']) {
        selectedCombination['ecotax'] = combination['ecotax'];
      } else {
        selectedCombination['ecotax'] = default_eco_tax;
      }

      //show discounts values according to the selected combination
      if (combination['idCombination'] && combination['idCombination'] > 0) {
        displayDiscounts(combination['idCombination']);
      }

      //get available_date for combination product
      selectedCombination['available_date'] = combination['available_date'];

      //update the display
      updateDisplay();

      if (firstTime) {
        refreshProductImages(0);
        firstTime = false;
      } else {
        refreshProductImages(combination['idCombination']);
      }

      //leave the function because combination has been found
      return;
    }
  }

  //this combination doesn't exist (not created in back office)
  selectedCombination['unavailable'] = true;
  if (typeof selectedCombination['available_date'] !== 'undefined') {
    delete selectedCombination['available_date'];
  }

  updateDisplay();
}


function getProductAttribute() {
    // get every attributes values
    request = '';

    var tab_attributes = getCurrentCombinationAttributes();

    // build new request
    for (var i in attributesCombinations) {
      if (attributesCombinations.hasOwnProperty(i)) {

        for (var j = 0; j < tab_attributes.length; j++) {
          if (attributesCombinations[i]['id_attribute'] == tab_attributes[j]) {
            request += '/' + attributesCombinations[i]['id_attribute'] + '-' + attributesCombinations[i]['group'] + attribute_anchor_separator + attributesCombinations[i]['attribute'];
          }
        }

      }
    }

    request = request.replace(request.substring(0, 1), '#/');
    var url = window.location + '';

    // redirection
    if (url.indexOf('#') != -1) {
      url = url.substring(0, url.indexOf('#'));
    }

    var $customizationForm = $('#customizationForm');
    if ($customizationForm.length) {
      // set ipa to the customization form
      var customAction = $customizationForm.attr('action');
      if (customAction.indexOf('#') != -1) {
        customAction = customAction.substring(0, customAction.indexOf('#'));
      }

      $customizationForm.attr('action', customAction + request);
    }

    window.location.replace(url + request);
}



//update display of the availability of the product AND the prices of the product
function updateDisplay() {
  var $oosHook = $('#oosHook');
  var $lastQuantities = $('#last_quantities');
  var $availabilityValue = $('#availability_value');
  var $availabilityDate = $('#availability_date');
  var $availabilityDateVal = $('#availability_date_value');

  updatePrice();

  if (!selectedCombination['unavailable'] && quantityAvailable > 0 && productAvailableForOrder == 1) {
    //show the choice of quantities
    $('#quantity_wanted_p:hidden').show();

    //show the "add to cart" button ONLY if it was hidden
    $('#add_to_cart:hidden').fadeIn();

    //hide the hook out of stock
    $oosHook.hide();
    $availabilityDate.hide();

    //availability value management
    if (stock_management && availableNowValue != '') {
      $availabilityValue.removeClass('label-warning').addClass('label-success').text(availableNowValue).show();
      $('#availability_statut:hidden').show();
    } else
      $('#availability_statut:visible').hide();

    //'last quantities' message management
    if (!allowBuyWhenOutOfStock) {
      $lastQuantities.toggle(quantityAvailable <= maxQuantityToAllowDisplayOfLastQuantityMessage);
    }

    if (quantitiesDisplayAllowed) {
      $('#pQuantityAvailable:hidden').show();
      $('#quantityAvailable').text(quantityAvailable);

      if (quantityAvailable < 2) // we have 1 or less product in stock and need to show "item" instead of "items"
      {
        $('#quantityAvailableTxt').show();
        $('#quantityAvailableTxtMultiple').hide();
      } else {
        $('#quantityAvailableTxt').hide();
        $('#quantityAvailableTxtMultiple').show();
      }
    }
  }
  else {
    // show the hook out of stock
    if (productAvailableForOrder == 1) {
      $oosHook.show();
      if ($oosHook.length && function_exists('oosHookJsCode')) {
        oosHookJsCode();
      }
    }

    // hide 'last quantities' message if it was previously visible
    $lastQuantities.hide();

    // hide the quantity of pieces if it was previously visible
    $('#pQuantityAvailable:visible').hide();

    // hide the choice of quantities
    if (!allowBuyWhenOutOfStock)
      $('#quantity_wanted_p:visible').hide();

    // display that the product is unavailable with theses attributes
    if (!selectedCombination['unavailable']) {
      $availabilityValue.text(doesntExistNoMore + (globalQuantity > 0 ? ' ' + doesntExistNoMoreBut : ''));
      if (!allowBuyWhenOutOfStock) {
        $availabilityValue.removeClass('label-success').addClass('label-warning');
      }
    } else {
      $availabilityValue.text(doesntExist).removeClass('label-success').addClass('label-warning');
      $oosHook.hide();
    }

    if ((stock_management == 1 && !allowBuyWhenOutOfStock) || (!stock_management && selectedCombination['unavailable']))
      $('#availability_statut:hidden').show();

    if (typeof(selectedCombination['available_date']) != 'undefined' && typeof(selectedCombination['available_date']['date_formatted']) != 'undefined' && selectedCombination['available_date']['date'].length != 0) {
      var available_date = selectedCombination['available_date']['date'];
      var tab_date = available_date.split('-');
      var time_available = new Date(tab_date[0], tab_date[1], tab_date[2]);
      time_available.setMonth(time_available.getMonth() - 1);
      var now = new Date();
      if (now.getTime() < time_available.getTime() && $availabilityDateVal.text() != selectedCombination['available_date']['date_formatted']) {
        $availabilityDate.fadeOut('fast', function() {
        $availabilityDateVal.text(selectedCombination['available_date']['date_formatted']);
          $(this).fadeIn();
        });
      } else if (now.getTime() < time_available.getTime()) {
        $availabilityDate.fadeIn();
      }
    } else {
      $availabilityDate.fadeOut();
    }

    //show the 'add to cart' button ONLY IF it's possible to buy when out of stock AND if it was previously invisible
    if (allowBuyWhenOutOfStock && !selectedCombination['unavailable'] && productAvailableForOrder) {
      $('#add_to_cart:hidden').fadeIn();

      if (stock_management && availableLaterValue != '') {
        $availabilityValue.addClass('label-warning').text(availableLaterValue).show();
        $('#availability_statut:hidden').show();
      } else
        $('#availability_statut:visible').hide();
    } else {
      $('#add_to_cart:visible').fadeOut();
      if (stock_management == 1 && productAvailableForOrder)
        $('#availability_statut:hidden').show();
    }

    if (productAvailableForOrder == 0)
      $('#availability_statut:visible').hide();
  }

  var $productReference = $('#product_reference');
  if (selectedCombination['reference'] || productReference) {

    if (selectedCombination['reference']) {
      $productReference.find('span').text(selectedCombination['reference']);
    } else if (productReference) {
      $productReference.find('span').text(productReference);
    }

    $productReference.show();
  } else {
    $productReference.hide();
  }
}



function updatePrice() {
    // Get combination prices
    var combID = $('#idCombination').val();
    var combination = combinationsFromController[combID];
    if (typeof combination === 'undefined') {
      return;
    }

    // Set product (not the combination) base price
    var basePriceWithoutTax = +productPriceTaxExcluded;
    var basePriceWithTax = +productPriceTaxIncluded;

    var priceWithGroupReductionWithoutTax = basePriceWithoutTax * (1 - groupReduction);

    // Apply combination price impact (only if there is no specific price)
    // 0 by default, +x if price is increased, -x if price is decreased
    basePriceWithoutTax = basePriceWithoutTax + +combination.price;
    basePriceWithTax = basePriceWithTax + +combination.price * (taxRate / 100 + 1);

    // If a specific price redefine the combination base price
    if (combination.specific_price && combination.specific_price.price > 0) {
      basePriceWithoutTax = +combination.specific_price.price;
      basePriceWithTax = +combination.specific_price.price * (taxRate / 100 + 1);
    }

    var priceWithDiscountsWithoutTax = basePriceWithoutTax;
    var priceWithDiscountsWithTax = basePriceWithTax;

    if (default_eco_tax) {
      // combination.ecotax doesn't modify the price but only the display
      priceWithDiscountsWithoutTax = priceWithDiscountsWithoutTax + default_eco_tax * (1 + ecotaxTax_rate / 100);
      priceWithDiscountsWithTax = priceWithDiscountsWithTax + default_eco_tax * (1 + ecotaxTax_rate / 100);
      basePriceWithTax = basePriceWithTax + default_eco_tax * (1 + ecotaxTax_rate / 100);
      basePriceWithoutTax = basePriceWithoutTax + default_eco_tax * (1 + ecotaxTax_rate / 100);
    }

    var reduction;

    // Apply specific price (discount)
    // We only apply percentage discount and discount amount given before tax
    // Specific price give after tax will be handled after taxes are added
    if (combination.specific_price && combination.specific_price.reduction > 0) {
      if (combination.specific_price.reduction_type == 'amount') {
        if (typeof(combination.specific_price.reduction_tax) != 'undefined' && combination.specific_price.reduction_tax === '0') {
          reduction = combination.specific_price.reduction;
          if (combination.specific_price.id_currency == 0) {
            reduction = reduction * currencyRate * (1 - groupReduction);
          }
          priceWithDiscountsWithoutTax -= reduction;
          priceWithDiscountsWithTax -= reduction * (taxRate / 100 + 1);
        }
      } else if (combination.specific_price.reduction_type == 'percentage') {
        priceWithDiscountsWithoutTax = priceWithDiscountsWithoutTax * (1 - +combination.specific_price.reduction);
        priceWithDiscountsWithTax = priceWithDiscountsWithTax * (1 - +combination.specific_price.reduction);
      }
    }

    // Apply Tax if necessary
    if (noTaxForThisProduct || customerGroupWithoutTax) {
      basePriceDisplay = basePriceWithoutTax;
      priceWithDiscountsDisplay = priceWithDiscountsWithoutTax;
    } else {
      basePriceDisplay = basePriceWithTax;
      priceWithDiscountsDisplay = priceWithDiscountsWithTax;
    }

    // If the specific price was given after tax, we apply it now
    if (combination.specific_price && combination.specific_price.reduction > 0) {
      if (combination.specific_price.reduction_type == 'amount') {
        if (typeof combination.specific_price.reduction_tax === 'undefined' ||
          (typeof combination.specific_price.reduction_tax !== 'undefined' && combination.specific_price.reduction_tax == '1')) {
          reduction = combination.specific_price.reduction;

          if (typeof specific_currency !== 'undefined' && specific_currency && parseInt(combination.specific_price.id_currency, 10) && combination.specific_price.id_currency != currency.id) {
            reduction = reduction / currencyRate;
          } else if (!specific_currency) {
            reduction = reduction * currencyRate;
          }

          if (typeof groupReduction !== 'undefined' && groupReduction > 0) {
            reduction *= 1 - parseFloat(groupReduction);
          }

          priceWithDiscountsDisplay -= reduction;
          // We recalculate the price without tax in order to keep the data consistency
          priceWithDiscountsWithoutTax = priceWithDiscountsDisplay - reduction * (1 / (1 + taxRate / 100));
        }
      }
    }

    if (priceWithDiscountsDisplay < 0) {
      priceWithDiscountsDisplay = 0;
    }

    // Compute discount value and percentage
    // Done just before display update so we have final prices
    if (basePriceDisplay != priceWithDiscountsDisplay) {
      var discountValue = basePriceDisplay - priceWithDiscountsDisplay;
      var discountPercentage = (1 - (priceWithDiscountsDisplay / basePriceDisplay)) * 100;
    }

    var unit_impact = +combination.unit_impact;
    if (productUnitPriceRatio > 0 || unit_impact) {
      if (unit_impact) {
        baseUnitPrice = productBasePriceTaxExcl / productUnitPriceRatio;
        unit_price = baseUnitPrice + unit_impact;

        if (!noTaxForThisProduct || !customerGroupWithoutTax)
          unit_price = unit_price * (taxRate / 100 + 1);
      } else
        unit_price = priceWithDiscountsDisplay / productUnitPriceRatio;
    }

    /*  Update the page content, no price calculation happens after */

    var $reductionPercent = $('#price-reduction');
    var $reductionAmount = $('#price-reduction');
    var $unitPrice = $('.unit-price');
    var $priceEcotax = $('.price-ecotax');

    var $oldPriceElements = $('#old_price, #old_price_display, #old_price_display_taxes');
    var $ourPriceDisplay = $('#our_price_display');
    var $oldPriceDisplay = $('#old_price_display');

    // Hide everything then show what needs to be shown
    $reductionPercent.hide();
    $reductionAmount.hide();
    $oldPriceElements.hide();
    $priceEcotax.hide();
    $unitPrice.hide();

    if (priceWithDiscountsDisplay > 0) {
      $ourPriceDisplay.text(formatCurrency(priceWithDiscountsDisplay, currencyFormat, currencySign, currencyBlank)).trigger('change');
      $oldPriceDisplay.text(formatCurrency(basePriceDisplay, currencyFormat, currencySign, currencyBlank)).trigger('change');
      if (findSpecificPrice()) {
        $('#our_price_display').text(findSpecificPrice()).trigger('change');
        $('#old_price_display').text(findSpecificPrice()).trigger('change');
      } else {
        $('#our_price_display').text(formatCurrency(priceWithDiscountsDisplay, currencyFormat, currencySign, currencyBlank)).trigger('change');
        $('#old_price_display').text(formatCurrency(basePriceDisplay, currencyFormat, currencySign, currencyBlank)).trigger('change');
      }
    } else {
      $ourPriceDisplay.text(formatCurrency(0, currencyFormat, currencySign, currencyBlank)).trigger('change');
      $oldPriceDisplay.text(formatCurrency(0, currencyFormat, currencySign, currencyBlank)).trigger('change');
    }

    // If the calculated price (after all discounts) is different than the base price
    // we show the old price striked through

    if (priceWithDiscountsDisplay.toFixed(2) != basePriceDisplay.toFixed(2)) {
      $ourPriceDisplay.find('span.price').text(formatCurrency(basePriceDisplay, currencyFormat, currencySign, currencyBlank));
      $oldPriceElements.removeClass('hidden').show();

      // Then if it's not only a group reduction we display the discount in red box
      if (priceWithDiscountsWithoutTax != priceWithGroupReductionWithoutTax) {
        if (combination.specific_price.reduction_type == 'amount') {
          $('#price-reduction').html(formatCurrency(discountValue, currencyFormat, currencySign, currencyBlank) + ' Off!');
          $reductionAmount.show();
        } else {
          var toFix = 2;
          if ((parseFloat(discountPercentage).toFixed(2) - parseFloat(discountPercentage).toFixed(0)) == 0) {
            toFix = 0;
          }
          $('#price-reduction').html(parseFloat(discountPercentage).toFixed(toFix) + '% Off!');
          $reductionPercent.show();
        }
      }
    }


    // Green Tax (Eco tax)
    // Update display of Green Tax
    if (default_eco_tax) {
      var ecotax = default_eco_tax;

      // If the default product ecotax is overridden by the combination
      if (combination.ecotax) {
        ecotax = +combination.ecotax;
      }

      if (!noTaxForThisProduct) {
        ecotax = ecotax * (1 + ecotaxTax_rate / 100);
      }

      $('#ecotax_price_display').text(formatCurrency(ecotax * currencyRate, currencyFormat, currencySign, currencyBlank));
      $priceEcotax.show();
    }

    // Unit price are the price per piece, per Kg, per m²
    // It doesn't modify the price, it's only for display
    if (productUnitPriceRatio > 0) {
      $('#unit_price_display').text(formatCurrency(unit_price * currencyRate, currencyFormat, currencySign, currencyBlank));
      $unitPrice.show();
    }

    if (noTaxForThisProduct || customerGroupWithoutTax) {
      updateDiscountTable(priceWithDiscountsWithoutTax);
    } else {
      updateDiscountTable(priceWithDiscountsWithTax);
    }
}


/**
 * Update display of the discounts table.
 * @param combination Combination ID.
 */
 function displayDiscounts(combination) {
  // Tables & rows selection
  var quantityDiscountTable = $('#quantityDiscount');
  var combinationsSpecificQuantityDiscount = $('.quantityDiscount_' + combination, quantityDiscountTable);
  var allQuantityDiscount = $('.quantityDiscount_0', quantityDiscountTable);

  // If there is some combinations specific quantity discount, show them, else, if there are some
  // products quantity discount: show them. In case of result, show the category.
  if (combinationsSpecificQuantityDiscount.length) {
    quantityDiscountTable.find('tbody tr').hide();
    combinationsSpecificQuantityDiscount.show();
    quantityDiscountTable.show();
  } else if (allQuantityDiscount.length) {
    allQuantityDiscount.show();
    $('tbody tr', quantityDiscountTable).not('.quantityDiscount_0').hide();
    quantityDiscountTable.show();
  } else {
    quantityDiscountTable.hide();
  }
}

function updateDiscountTable(newPrice) {
  $('#quantityDiscount').find('tbody tr').each(function() {
    var type = $(this).data('discount-type');
    var discount = $(this).data('discount');
    var quantity = $(this).data('discount-quantity');
    var discountedPrice;
    var discountUpTo;

    if (type === 'percentage') {
      discountedPrice = newPrice * (1 - discount / 100);
      discountUpTo = newPrice * (discount / 100) * quantity;
    } else if (type === 'amount') {
      discountedPrice = newPrice - discount;
      discountUpTo = discount * quantity;
    }

    if (displayDiscountPrice != 0 && discountedPrice != 0) {
      $(this).children('td').eq(1).text(formatCurrency(discountedPrice, currencyFormat, currencySign, currencyBlank));
    }
    $(this).attr('data-real-discount-value', formatCurrency(discountedPrice, currencyFormat, currencySign, currencyBlank));
    $(this).children('td').eq(2).text(upToTxt + ' ' + formatCurrency(discountUpTo, currencyFormat, currencySign, currencyBlank));
  });
}


//find a specific price rule, based on pre calculated dom display array
function findSpecificPrice() {
  var domData = $('#quantityDiscount').find('table tbody tr').not(':hidden');
  var nbProduct = $('#quantity_wanted').val();
  var newPrice = false;

  //construct current specific price for current combination
  domData.each(function(i) {
    var dataDiscountQuantity = parseInt($(this).attr('data-discount-quantity'), 10);
    var dataDiscountNextQuantity = -1;

    var nextQtDiscount = $(domData[i + 1]);
    if (nextQtDiscount.length) {
      dataDiscountNextQuantity = parseInt(nextQtDiscount.attr('data-discount-quantity'), 10);
    }
    if (
      (dataDiscountNextQuantity !== -1 && nbProduct >= dataDiscountQuantity && nbProduct < dataDiscountNextQuantity) ||
      (dataDiscountNextQuantity === -1 && nbProduct >= dataDiscountQuantity)
    ) {
      newPrice = $(this).attr('data-real-discount-value');
      return false;
    }
  });

  return newPrice;
}

/* When some attribute select is changed */
$(document).on('change', '.attribute_select', function(e) {
    e.preventDefault();
    findCombination();
    getProductAttribute();
});

$(document).on('click', '.color_pick', function(e) {
  e.preventDefault();
  colorPickerClick($(this));
  findCombination();
  getProductAttribute();
});

$(document).on('change', '#quantity_wanted', function(e) {
  e.preventDefault();
  if (isNaN($(this).val()) || $(this).val() === '') {
    (minimalQuantity > 1) ? $(this).val(minimalQuantity) : $(this).val('1');
  }
  var specificPrice = findSpecificPrice();
  var $ourPriceDisplay = $('#our_price_display');

  if (false !== specificPrice) {
    $ourPriceDisplay.text(specificPrice);
  } else if (typeof productHasAttributes !== 'undefined' && productHasAttributes) {
    updateDisplay();
  } else {
    $ourPriceDisplay.text(formatCurrency(parseFloat($ourPriceDisplay.siblings('meta[itemprop="price"]').attr('content')), currencyFormat, currencySign, currencyBlank));
  }
});




if (typeof combinations !== 'undefined' && combinations) {
    var combinationsJS = [];
    window.combinationsHashSet = {};
    k = 0;
    for (i in combinations) {
      if (combinations.hasOwnProperty(i)) {
        globalQuantity += combinations[i]['quantity'];
        combinationsJS[k] = [];
        combinationsJS[k]['idCombination'] = parseInt(i, 10);
        combinationsJS[k]['idsAttributes'] = combinations[i]['attributes'];
        combinationsJS[k]['quantity'] = combinations[i]['quantity'];
        combinationsJS[k]['price'] = combinations[i]['price'];
        combinationsJS[k]['ecotax'] = combinations[i]['ecotax'];
        combinationsJS[k]['image'] = parseInt(combinations[i]['id_image'], 10);
        combinationsJS[k]['reference'] = combinations[i]['reference'];
        combinationsJS[k]['unit_price'] = combinations[i]['unit_impact'];
        combinationsJS[k]['minimal_quantity'] = parseInt(combinations[i]['minimal_quantity'], 10);

        combinationsJS[k]['available_date'] = [];
        combinationsJS[k]['available_date']['date'] = combinations[i]['available_date'];
        combinationsJS[k]['available_date']['date_formatted'] = combinations[i]['date_formatted'];

        combinationsJS[k]['specific_price'] = [];
        combinationsJS[k]['specific_price']['reduction_percent'] = (combinations[i]['specific_price'] && combinations[i]['specific_price']['reduction'] && combinations[i]['specific_price']['reduction_type'] == 'percentage') ? combinations[i]['specific_price']['reduction'] * 100 : 0;
        combinationsJS[k]['specific_price']['reduction_price'] = (combinations[i]['specific_price'] && combinations[i]['specific_price']['reduction'] && combinations[i]['specific_price']['reduction_type'] == 'amount') ? combinations[i]['specific_price']['reduction'] : 0;
        combinationsJS[k]['price'] = (combinations[i]['specific_price'] && combinations[i]['specific_price']['price'] && parseInt(combinations[i]['specific_price']['price'], 10) !== -1) ? combinations[i]['specific_price']['price'] :  combinations[i]['price'];

        combinationsJS[k]['reduction_type'] = (combinations[i]['specific_price'] && combinations[i]['specific_price']['reduction_type']) ? combinations[i]['specific_price']['reduction_type'] : '';
        combinationsJS[k]['id_product_attribute'] = (combinations[i]['specific_price'] && combinations[i]['specific_price']['id_product_attribute']) ? combinations[i]['specific_price']['id_product_attribute'] : 0;

        key = combinationsJS[k]['idsAttributes'].sort().join('-');
        window.combinationsHashSet[key] = combinationsJS[k];

        k++;
      }
    }
    window.combinations = combinationsJS;

}



$(document).on('submit', '#buy_block', function(e) {
  e.preventDefault();

  var form = $(this);
  var url = form.attr('action');

  $('body').addClass('loading-overlay');

  $.ajax({
    type: "POST",
    url: url,
    data: form.serialize(), // serializes the form's elements.
    success: function(data)
    {
      var hasNewTotal = false;
      // Get new cart total from the page
      var result = new DOMParser().parseFromString(data, "text/html").documentElement;
      var span = result.lastChild.querySelector('span[id="CartTotal"]');
      if (span != null) {
        var el = document.getElementById('CartTotal');
        el.innerHTML = span.innerHTML;
        hasNewTotal = true;
      }

      $('body').removeClass('loading-overlay');

      addProductNotification('<div class="alert alert-success" style="padding: 10px; margin-top: 10px;">' + addedToCartTitle + ' <a href="' + goToCartURL + '" class="link">' + addedToCartGoToCart + '</a></div>', false);

      if (hasNewTotal) {
        $('#CartTotal + .ajax_cart_no_product').css('display', 'none');
        $('#CartTotal').css('display', 'inline-block');
      }
    },
    error: function() {
      $('body').removeClass('loading-overlay');

      addProductNotification('<div class="alert alert-danger" style="padding: 10px; margin-top: 10px;">' + addToCartErrorText + '</div>', true);
    }
  });

});


function GoToProductTab(tabId) {
  var el = document.getElementById(tabId);
  if (el == null)
    return;

  $(el).click();
}

$(document).on('click', 'input[name="product-tabs"]', function(){
  //window.location.hash = $(this).attr('id');
});


function addProductNotification(notification, isError) {
  addProductNotificationTo('#product-notifications-desktop', notification, isError);
  addProductNotificationTo('#product-notifications-mobile', notification, isError);
}


function addProductNotificationTo(div, notification, isError) {
  $(div).append(notification);
  if (!isError) {
    $(div).children(':last').delay(10000).fadeOut();
  }
}



function checkUrl() {
  if (original_url != window.location || first_url_check) {
    first_url_check = false;
    var url = window.location + '';
    // if we need to load a specific combination
    if (url.indexOf('#/') != -1) {
      // get the params to fill from a "normal" url
      params = url.substring(url.indexOf('#') + 1, url.length);
      tabParams = params.split('/');
      tabValues = [];
      if (tabParams[0] == '') {
        tabParams.shift();
      }

      var len = tabParams.length;
      for (var i = 0; i < len; i++) {
        tabParams[i] = tabParams[i].replace(attribute_anchor_separator, '-');
        tabValues.push(tabParams[i].split('-'));
      }

      // fill html with values
      $('.color_pick').removeClass('selected').parent().parent().children().removeClass('selected');

      var count = 0;
      for (var z in tabValues) {
        for (var a in attributesCombinations) {
          if (attributesCombinations.hasOwnProperty(a)) {
            if (attributesCombinations[a]['group'] === decodeURIComponent(tabValues[z][1]) &&
              attributesCombinations[a]['id_attribute'] === decodeURIComponent(tabValues[z][0])) {
              count++;

              // add class 'selected' to the selected color
              $('#color_' + attributesCombinations[a]['id_attribute']).addClass('selected').parent().addClass('selected');
              $('input:radio[value=' + attributesCombinations[a]['id_attribute'] + ']').prop('checked', true);
              $('input[type=hidden][name=group_' + attributesCombinations[a]['id_attribute_group'] + ']').val(attributesCombinations[a]['id_attribute']);
              $('select[name=group_' + attributesCombinations[a]['id_attribute_group'] + ']').val(attributesCombinations[a]['id_attribute']);
            }
          }
        }
      }

      // find combination and select corresponding thumbs
      if (count) {
        if (firstTime) {
          firstTime = false;
          findCombination();
        }
        original_url = url;
        return true;
      } else {
        // no combination found = removing attributes from url
        window.location.replace(url.substring(0, url.indexOf('#')));
      }
    }
  }
  return false;
}



$(function() {
  var url_found = checkUrl();

  // init the price in relation of the selected attributes
  if (!url_found) {
    if (typeof productHasAttributes !== 'undefined' && productHasAttributes) {
      findCombination();
    } else {
      refreshProductImages(0);
    }
  }

  var hash = window.location.hash;
  if (hash) {
    GoToProductTab(hash.replace('#', ''));
  }
});