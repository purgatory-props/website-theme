$(document).ready(function() {
  if (typeof addressesConfirm !== 'undefined' && addressesConfirm) {
    $('a[data-id="addresses_confirm"]').click(function(e) {
        e.preventDefault();
        swal({
          title: addressesConfirm,
          text: "Removing this address cannot be undone.",
          icon: "warning",
          buttons: true,
          dangerMode: true
        })
          .then(function (performDelete){
            if (performDelete)
              window.location.href = e.currentTarget.getAttribute('href');
          });
    });
  }
});