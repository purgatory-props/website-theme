var selectedCombination = [];
var selectedCombination = [];
var globalQuantity = 0;
var colors = [];
var original_url = window.location + '';
var first_url_check = true;
var firstTime = true;


function changeBigPictureForProduct(e) {
    var productImageContainer = document.getElementById('productImage');
    if (productImageContainer == null)
        return;

    if (e.target == null || !e.target.hasAttribute('data-image'))
        return;

    productImageContainer.setAttribute('src', e.target.getAttribute('data-image'));

    // Set link to full image
    var productImageLink = document.getElementById('fullImageLink');
    if (e.target.hasAttribute('data-fullImage') && productImageLink != null) {
        productImageLink.setAttribute('href', e.target.getAttribute('data-fullImage'));
    }

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
          //checkMinimalQuantity(combination['minimal_quantity']);
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
        //displayDiscounts(combination['idCombination']);
      }

      //get available_date for combination product
      selectedCombination['available_date'] = combination['available_date'];

      //update the display
      updateDisplay();

      if (firstTime) {
        //refreshProductImages(0);
        firstTime = false;
      } else {
        //refreshProductImages(combination['idCombination']);
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
    updatePrice();
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

    var $reductionPercent = $('#reduction_percent');
    var $reductionAmount = $('#reduction_amount');
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
          $('#reduction_amount_display').html('-' + formatCurrency(discountValue, currencyFormat, currencySign, currencyBlank));
          $reductionAmount.show();
        } else {
          var toFix = 2;
          if ((parseFloat(discountPercentage).toFixed(2) - parseFloat(discountPercentage).toFixed(0)) == 0) {
            toFix = 0;
          }
          $('#reduction_percent_display').html('-' + parseFloat(discountPercentage).toFixed(toFix) + '%');
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


/* When some attribute select is changed */
$(document).on('change', '.attribute_select', function(e) {
    e.preventDefault();
    findCombination();
    getProductAttribute();
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