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
    $('#frm-freight-info').Validform({
        tiptype: 3
    });

    $('#freighttype').change(function(){

      $('#freightname').val($(this).find('option:selected').text());
    });

    $( "#frm-freight-info" ).submit(function( event ) {


          event.preventDefault();

          var form = $( this );

          var name = $('#freightname').val();

        



          url = form.attr( "action" );

          var posting = $.post( url, {
                'freightname': name,
                'freighttype':$('#freighttype').val(),
                'url': $('#url').val(),
                'sort': $('#sort').val(),
            } );


          posting.done(function( data ) {

              if( data.success)
              {

                window.location = globalSetting.baseUrl + '/system/freight/search';
                return;
              }

          });

      });

    $('#btnCancel').click(function(){
        window.location = globalSetting.baseUrl + '/system/freight/search';
        return;
    });
});