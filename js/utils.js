function toggleLoading(element, forceLoading) {
    if (element == null)
        return;


    forceLoading = forceLoading || false;
    if (forceLoading || !__hasClass(element, 'loading-overlay'))
        element.classList.add('loading-overlay');
    else
        element.classList.remove('loading-overlay');
}

function __hasClass(el, c) {
    try {
        return el.classList.indexOf(c) != -1;
    }
    catch (e) {
        return el.classList.contains(c);
    }
}


function NetworkRequest(method, url, data) {
    return new Promise((resolve, reject) => {
        var request = new XMLHttpRequest();
        request.open(method, url);

        request.onload = function() {
            if (this.status >= 200 && this.status < 300) {
                resolve(request.response);
            }
            else {
                reject({
                    status: this.status,
                    statusText: request.statusText
                });
            }
        };

        request.onerror = function() {
            reject({
                status: this.status,
                statusText: request.statusText
            });
        };

        request.send(data);
    });
}

function GET(url, data) {
    return NetworkRequest('GET', url, data);
}


function applyCSSToElements(elements, cssRules) {
    if (!Array.isArray(elements) && typeof(elements)=='string')
        elements = [elements];

    var allElements = [];
    for (var i = 0; i < elements.length; i++) {
        allElements = allElements.concat(Array.prototype.slice.call(document.querySelectorAll(elements[i])));
    }

    for (var i = 0; i < allElements.length; i++) {
        for (var rule in cssRules) {
            allElements[i].style[rule] = cssRules[rule];
        }
    }
}



/**
 * Managing States and Countries
 */
 var countriesNeedIDNumber = [];
 var countriesNeedZipCode = [];
 var states = [];

function setCountries() {
    if (typeof countries !== 'undefined' && countries) {
        var countriesPS = [];
        for (var i in countries) {
            var id_country = countries[i]['id_country'];
            if (typeof countries[i]['states'] !== 'undefined' && parseInt(countries[i]['contains_states'])) {
                countriesPS[id_country] = [];
                for (var j in countries[i]['states']) {
                    countriesPS[parseInt(id_country)].push({'id': parseInt(countries[i]['states'][j]['id_state']), 'name': countries[i]['states'][j]['name']});
                }
            }

            if (typeof countries[i]['need_identification_number'] !== 'undefined' && parseInt(countries[i]['need_identification_number']) > 0)
                countriesNeedIDNumber.push(parseInt(countries[i]['id_country']));
            if (typeof countries[i]['need_zip_code'] !== 'undefined' && parseInt(countries[i]['need_zip_code']) > 0)
                countriesNeedZipCode[parseInt(countries[i]['id_country'])] = countries[i]['zip_code_format'];
        }
    }
    states = countriesPS;
}

function updateState(suffix) {
    var selectId = '#id_state' + (typeof suffix !== 'undefined' ? '_' + suffix : '');
    var select = $(selectId);

    if (suffix === 'invoice') {
        var invoiceAddressShown = ($('#invoice_address:checked').length > 0);
        if (!invoiceAddressShown) {
            select.removeAttr('required');
            return;
        }
    }

    $(selectId + ' option:not(:first-child)').remove();
    if (typeof countries !== 'undefined')
        var state_list = states[parseInt($('#id_country' + (typeof suffix !== 'undefined' ? '_' + suffix : '')).val())];
    if (typeof state_list !== 'undefined') {
        select.attr('required', 'required');

        $(state_list).each(function(key, item) {
            select.append('<option value="' + parseInt(item.id) + '">' + item.name + '</option>');
        });
        $('.id_state' + (typeof suffix !== 'undefined' ? '_' + suffix : '') + ':hidden').fadeIn('slow');
    } else {
        select.removeAttr('required');
        $('.id_state' + (typeof suffix !== 'undefined' ? '_' + suffix : '')).fadeOut('fast');
    }
}

function updateNeedIDNumber(suffix) {
    var id_country = parseInt($('#id_country' + (typeof suffix !== 'undefined' ? '_' + suffix : '')).val());
    if (in_array(id_country, countriesNeedIDNumber)) {
        $('.dni' + (typeof suffix !== 'undefined' ? '_' + suffix : '') + ':hidden').fadeIn('slow');
    } else {
        $('.dni' + (typeof suffix !== 'undefined' ? '_' + suffix : '')).fadeOut('fast');
    }
}

function updateZipCode(suffix) {
    var id_country = parseInt($('#id_country' + (typeof suffix !== 'undefined' ? '_' + suffix : '')).val());
    if (typeof countriesNeedZipCode[id_country] !== 'undefined') {
        $('.postcode' + (typeof suffix !== 'undefined' ? '_' + suffix : '') + ':hidden').fadeIn('slow');
    } else {
        $('.postcode' + (typeof suffix !== 'undefined' ? '_' + suffix : '')).fadeOut('fast');
    }
}


function bindStateInputAndUpdate() {
    applyCSSToElements(['.id_state', '.dni', '.postcode'], {'display': 'none'});

    updateState();
    updateNeedIDNumber();
    updateZipCode();

    $(document).on('change', '#id_country', function(e) {
      updateState();
      updateNeedIDNumber();
      updateZipCode();
      if (typeof validate_field !== 'undefined')
        validate_field('#postcode');
    });

    if ($('#id_country_invoice').length !== 0) {
      $(document).on('change', '#id_country_invoice', function(e) {
        updateState('invoice');
        updateNeedIDNumber('invoice');
        updateZipCode('invoice');
        if (typeof validate_field !== 'undefined')
          validate_field('#postcode_invoice');
      });
      updateState('invoice');
      updateNeedIDNumber('invoice');
      updateZipCode('invoice');
    }

    if (typeof idSelectedState !== 'undefined' && idSelectedState)
        $('.id_state option[value=' + idSelectedState + ']').prop('selected', true);
    if (typeof idSelectedStateInvoice !== 'undefined' && idSelectedStateInvoice)
        $('.id_state_invoice option[value=' + idSelectedStateInvoice + ']').prop('selected', true);
}


function bindCheckbox() {
    if ($('#invoice_address:checked').length > 0) {
        $('#opc_invoice_address').slideDown('slow');
        if ($('#company_invoice').val() == '')
            $('#vat_number_block_invoice').hide();
    } else {
        $('#opc_invoice_address').slideUp('slow');
    }
    updateState('invoice');
}

function bindZipcode() {
    $(document).on('keyup', 'input[name^=postcode]', function(e) {
        var char = String.fromCharCode(e.keyCode);
        if (/[a-zA-Z]/.test(char))
            $.trim($(this).val($(this).val().toUpperCase()));
    });
  }
