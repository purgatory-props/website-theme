// Write a Review Button
$(document).on('click', '#new_comment_tab_btn', function(e) {
    e.preventDefault();

    $(this).hide();
    $('#new_comment_form').show();
});

// Cancel Button on Review Form
$(document).on('click', '#close_comment_form', function(e) {
    e.preventDefault();

    $('#new_comment_form').hide();
    $('#new_comment_tab_btn').show();
});


// Submit the Review Form
$(document).on('click', '#submitNewMessage', function(e) {
    e.preventDefault();

    var url_options = productcomments_url_rewrite ? '?' : '&';
    var $error = $('#new_comment_form_error');
    $error.hide();

    toggleLoading(document.body);

    $.ajax({
        url: productcomments_controller_url + url_options + 'action=add_comment&secure_key=' + secure_key + '&rand=' + new Date().getTime(),
        data: $('#id_new_comment_form').serialize(),
        type: 'POST',
        headers: { 'cache-control': 'no-cache' },
        dataType: 'json',
        success: function(data) {
            if (data.result) {
                toggleLoading(document.body);

                swal({
                    title: productcomment_added,
                    icon: 'success',
                    text: moderation_active ? productcomment_added_moderation : productcomment_added
                })
                .then(function() {
                    if (moderation_active) {
                        $('#new_comment_form').hide();
                    }
                    else {
                        window.location.reload();
                    }
                });
            }
            else {
                $error.find('ul').html('');
                $.each(data.errors, function(index, value) {
                    $error.find('ul').append('<li>' + value + '</li>');
                });
                $error.show();
            }
        }
    });
});

// Report Review
$(document).on('click', '#review-report', function(e) {
    e.preventDefault();

    var self = $(this);

    // Prompt to confirm
    swal({
        title: confirm_report_message,
        icon: 'info',
        buttons: {
          cancel: 'No',
          report: 'Yes'
        },
    })
    .then(function (buttonPressed) {
        if (buttonPressed == 'report') {
            toggleLoading(document.body);

            var idProductComment = self.data('id-product-comment');
            var parent = self.parent().parent().parent();

            $.ajax({
                url: productcomments_controller_url + '?rand=' + new Date().getTime(),
                data: {
                    id_product_comment: idProductComment,
                    action: 'report_abuse'
                },
                type: 'POST',
                headers: {'cache-control': 'no-cache'},
                success: function(result) {
                    toggleLoading(document.body);
                    parent.remove();
                }
            });
        }
    });


});


// Prep the input rating buttons
$(function() {
    $('input.star').rating();
    $('.auto-submit-star').rating();
});