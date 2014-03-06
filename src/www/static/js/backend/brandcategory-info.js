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
     $('#frmBrandCategoryInfo').Validform({
                tiptype: 3
     });


    $( "#frmBrandCategoryInfo" ).submit(function( event ) {


          event.preventDefault();

          var form = $( this );

          var name = $('#brandcategoryname').val();
          var id = $('#brandcategoryid').val();

          url = form.attr( "action" );

          var posting = $.post( url, { 'name': name, 'brandcategoryid': id} );


          posting.done(function( data ) {

              window.location = globalSetting.baseUrl + '/goods/brand/categorysearch';
              return;

          });

      });

    $('#btnCancel').click(function(){
        window.location = globalSetting.baseUrl + '/goods/brand/categorysearch';
        return;
    });

});