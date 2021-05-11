function setCreateFormErrors(error) {
    var errContainter = document.getElementById('createFormErrors');
    if (error.trim().length == 0) {
        errContainter.style['display'] = 'none';
        errContainter.innerHTML = '';
    }
    else {
        errContainter.innerHTML = error;
        errContainter.style['display'] = 'block';
    }
}

function clearInvalid(input){
    if (input != null)
        input.removeAttribute('data-invalid');
}

function makeInvalid(input) {
    if (input != null)
        input.setAttribute('data-invalid', 'true');
}




function onAccountCreateFormShown() {
  // Validate FULL account creation form
  var fullAccountCreateForm = document.getElementById('account-creation_form');
  if (fullAccountCreateForm != null) {
        fullAccountCreateForm.addEventListener('submit', function(e) {
            var isValid = true;
            var errors = "";


            // Verify passwords are the same
            var password = document.getElementById('passwd');
            var passwordConfirm = document.getElementById('passwd_confirm');

            clearInvalid(password);
            clearInvalid(passwordConfirm);

            if (password != null && passwordConfirm != null) {
                if (password.value != passwordConfirm.value) {
                    makeInvalid(password);
                    makeInvalid(passwordConfirm);

                    password.focus();
                    password.select();

                    isValid = false;

                    passwordConfirm.value = '';

                    errors += ((errors.length > 0) ? '<br/>' : '') + 'Passwords do not match.';
                }

                if (password.value.length < 5) {
                    makeInvalid(password);
                    password.focus();
                    password.select();

                    passwordConfirm.value = '';

                    isValid = false;

                    errors += ((errors.length > 0) ? '<br/>' : '') + 'Password must at least 5 characters long.';
                }
            }

            setCreateFormErrors(errors);
            if (!isValid)
                e.preventDefault();

            return isValid;
        });
  }
}


$(function(){
    onAccountCreateFormShown();

    $('#login_form').on('submit', function() {
        $(this).addClass('loading-overlay');
    });

    // Validate initial account creation form (just checking if email exists)
    $(document).on('submit', '#create-account_form', function(e) {
        e.preventDefault();
        $(this).addClass('loading-overlay');

        $('#create_account_error').html('').hide();
        $.ajax({
          type: 'POST',
          url: baseUri + '?rand=' + new Date().getTime(),
          async: true,
          cache: false,
          dataType: 'json',
          headers: {'cache-control': 'no-cache'},
          data:
          {
            controller: 'authentication',
            SubmitCreate: 1,
            ajax: true,
            email_create: $('#email_create').val(),
            back: $('input[name=back]').val(),
            token: token
          },
          success: function(jsonData) {
            if (jsonData.hasError) {
              var errors = '';
              for (error in jsonData.errors)
                //IE6 bug fix
                if (error != 'indexOf')
                  errors += '<li>' + jsonData.errors[error] + '</li>';
              $('#create_account_error').html('<ol>' + errors + '</ol>').show();
              $('#create-account_form').removeClass('loading-overlay');
            } else {
              // adding a div to display a transition
              $('#authContainer').html(jsonData.page);
              onAccountCreateFormShown();
            }
          },
          error: function(XMLHttpRequest, textStatus, errorThrown) {
            PrestaShop.showError(
              'TECHNICAL ERROR: unable to load form.\n\nDetails:\nError thrown: ' +
              XMLHttpRequest + '\n' + 'Text status: ' + textStatus
            );
          }
        });

    });


    $(document).on('click', '#createGuestBtn', function() {
      $('#login-col').hide();
      $('#signup-col').hide();
      $('#new_account_form').show();

      $(this).hide();
      $('#createAccountBtn').show();
    });

    $(document).on('click', '#createAccountBtn', function() {
      $('#new_account_form').hide();
      $('#login-col').show();
      $('#signup-col').show();

      $(this).hide();
      $('#createGuestBtn').show();
    });
});