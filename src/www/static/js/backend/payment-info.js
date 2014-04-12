// ==============================================================================
//
// This file is part of the WelStory.
//
// Create by Welfony Support <support@welfony.com>
// Copyright (c) 2012-2014 welfony.com
//
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code.
//
// ==============================================================================



$(function() {
    $('#frm-payment-info').Validform({
        tiptype: 3
    });


    $( "#frm-payment-info" ).submit(function( event ) {


          event.preventDefault();

          var form = $( this );

          var name = $('#paymentname').val();
          var poundagetype = $('input[name="poundage_type"]:checked').val();
          var poundage = $('#poundage').val();


          url = form.attr( "action" );

          var posting = $.post( url, {
                'name': name,
                'poundagetype': poundagetype,
                'poundage': poundage,
                'partnerid': $('#partnerid').val(),
                'partnerkey': $('#partnerkey').val(),
                'status':$('input[name="status"]:checked:first').val(),
                'note': $('#note').val(),
                'sort': $('#sort').val()

            } );


          posting.done(function( data ) {

              if( data.success)
              {

                window.location = globalSetting.baseUrl + '/system/payment/search';
                return;
              }

          });

      });

    $('#btnCancel').click(function(){
        window.location = globalSetting.baseUrl + '/system/payment/search';
        return;
    });
});