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
    $('#frm-order-info').Validform({
        tiptype: 3
    });


    $( "#frm-order-info" ).submit(function( event ) {


          event.preventDefault();

          var form = $( this );

          var orderno = $('#orderno').val();

         
          

          url = form.attr( "action" );

          var posting = $.post( url, { 
                'orderno': orderno
            } );


          posting.done(function( data ) {

              if( data.success)
              {

                window.location = globalSetting.baseUrl + '/order/index/search';
                return;
              }

          });

      });

    $('#btnCancel').click(function(){
        window.location = globalSetting.baseUrl + '/order/index/search';
        return;
    });
});