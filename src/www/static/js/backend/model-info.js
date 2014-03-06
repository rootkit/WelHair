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
    $('#frm-model-info').Validform({
        tiptype: 3
    });   


    $( "#frm-model-info" ).submit(function( event ) {


          event.preventDefault();

          var form = $( this );

          var name = $('#modelname').val();

          //var brandcategories  = $('input[name="category[]"]:checked').map(function(i,n) {
          //      return $(n).val();
          //}).get();
         
          

          url = form.attr( "action" );

          var posting = $.post( url, { 
                'name': name
            } );


          posting.done(function( data ) {

              window.location = globalSetting.baseUrl + '/goods/model/search';
              return;

          });

      });

    $('#btnCancel').click(function(){
        window.location = globalSetting.baseUrl + '/goods/model/search';
        return;
    });
});