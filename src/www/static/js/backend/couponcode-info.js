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
    $('#frm-couponcode-info').Validform({
        tiptype: 3
    });


    $( "#frm-brand-info" ).submit(function( event ) {


          event.preventDefault();

          var form = $( this );

          var name = $('input[name=brandname]').val();
          var sort = $('input[name=sort]').val();
          var brandurl = $('#url').val();
          var logo = $('#brand-image').attr('src');
          var brandcategories  = $('input[name="category[]"]:checked').map(function(i,n) {
                return $(n).val();
            }).get();
         
          var description = $('textarea#description').val();


          url = form.attr( "action" );

          var posting = $.post( url, { 
                'name': name, 
                'sort': sort,
                'brandurl' : brandurl,
                'logo' : logo,
                'category' : brandcategories,
                'description' :description
            } );


          posting.done(function( data ) {

              window.location = globalSetting.baseUrl + '/goods/brand/search';
              return;

          });

      });
});