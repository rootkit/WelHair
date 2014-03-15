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
    
    $( ".btnDelete" ).click(function( event ) {


          event.preventDefault();

          var item = $( this );

          var url = globalSetting.baseUrl + '/coupon/index/delete';

          
          var posting = $.post( url, { 
                'couponid' : item.attr('data-id')
            } );


          posting.done(function( data ) {

          	  if( data.success)
          	  {
              	window.location = globalSetting.baseUrl + '/coupon/index/search';
              }
              return;

          });

    });

    $( ".btnActive" ).click(function( event ) {


          event.preventDefault();

          var item = $( this );

          var url = globalSetting.baseUrl + '/coupon/index/updatestatus';

          var status = item.attr( 'data-status') ==  1 ? 0 : 1;

          
          var posting = $.post( url, { 
                'couponid' : item.attr('data-id'),
                'isactive' : status
            } );


          posting.done(function( data ) {

          	  if( data.success)
          	  {
              	item.find('img[data-status="' + status + '"]').show();
              	item.find('img[data-status="' +  item.attr( 'data-status')  + '"]').hide();
              }
              return;

          });

    });
});