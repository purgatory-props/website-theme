$(document).ready(function() {
    setCountries();
    bindStateInputAndUpdate();
    bindZipcode();
    bindCheckbox();

    $(document).on('click', '#invoice_address', function(e) {
        bindCheckbox();
    });
});