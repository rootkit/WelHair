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
    $('#frm-category-info').Validform({
        tiptype: 3
    });


    

    $( "#frm-coupon-info" ).submit(function( event ) {


          event.preventDefault();
		  
		  window.location = globalSetting.baseUrl + '/goods/category/search';
		  return;

          var form = $( this );

          var url = form.attr( "action" );

       

          var posting = $.post( url, { 
                'categoryid' : $('#couponid').val(),
	            'cateogryname' : $('#companyname').val()
            } );


          posting.done(function( data ) {

              window.location = globalSetting.baseUrl + '/goods/category/search';
              return;

          });

      });
});