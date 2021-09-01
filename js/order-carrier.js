$(document).ready(function() {
    var btn = $('#proceed-btn');
    var checkbox = $('#cgv');

    if (!checkbox)
    {
        btn.removeAttr('disabled');
    }
    else {
        if (checkbox.is(':checked'))
            btn.removeAttr('disabled');

        checkbox.on('change', function(){
            if ($(this).is(':checked'))
                btn.removeAttr('disabled');
            else
                btn.attr('disabled', 'true');
        });
    }


    $('#tac-open').on('click', function() {
        $('#tac-iframe').css('display: block');
    });
});