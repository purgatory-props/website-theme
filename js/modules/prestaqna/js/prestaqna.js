
    function toggleQuestionForm() {
        $('#qna_ask').toggleClass('hidden');
        $('#ask-question-btn').toggleClass('hidden');
    }

$(document).ready(function() {


    $('#qna_ask').validate({
        submitHandler: function(form) {
            var $serialized = $(form).serialize();
            ajaxCall($('#qna_ask'),$serialized);
        },
        errorClass: "invalid",
        rules: {
            qna_q: "required",
            qna_email: {
                required: true,
                email: true
            }
        },
        messages: {
            qna_q: '',
            qna_email: {
                required: '',
                email: qna_bademail
            }
        }

    });

    $('#qna_ask').on('submit', function(){
        $('#qna-form-alerts').html('');
        toggleQuestionForm();
    });

    $(document).on('click', '.question-title', function() {
        var parent = $(this).parent()[0];
        $(parent).toggleClass('expanded');
    });



    /* Ajax add request*/
    function ajaxCall(caller,data) {
        $('#submitQNA').fadeOut();
        caller.append($('<div class="ajaxloader"><img src="'+baseDir+'modules/prestaqna/ajax-loader.gif"/></div>'));
        $('.qna_confirm, .qna_error').fadeOut('normal', function(){$(this).remove});
        $.ajax({
        type: 'POST',
        data: data,
        url: baseDir+'modules/prestaqna/ajax.php',
        success: function(data){
            if(data !=1)
                $('#submitQNA').fadeIn();

            if(data == 'err')
                $('<div class="alert alert-danger qna_error">'+qna_error+'</div>').hide().appendTo($('#qna-form-alerts')).fadeIn();
            else if(data == 'mex')
                $('<div class="alert alert-danger qna_error">'+qna_badcontent+'</div>').hide().appendTo($('#qna-form-alerts')).fadeIn();
            else if(data == 'name')
                $('<div class="alert alert-danger qna_error">'+qna_badname+'</div>').hide().appendTo($('#qna-form-alerts')).fadeIn();
            else if(data == 'mail')
                $('<div class="alert alert-danger qna_error">'+qna_bademail+'</div>').hide().appendTo($('#qna-form-alerts')).fadeIn();
            else if (data == 1) // Okay
            {
                $('<div class="alert alert-success qna_confirm confirmation">'+qna_confirm+'</div>').hide().appendTo($('#qna-form-alerts')).fadeIn();
            }

            else alert(data);
            $('.ajaxloader').fadeOut('normal', function(){$(this).remove()}); //remove spinner
        }
        })
    }

    if(window.location.hash == '#qnaTab'){
        $('.qnaTabPointer').click();
        $('body').animate({ scrollTop: $("#qna_pointer").offset().top }, 500);
    }

});