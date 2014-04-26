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

          var url = globalSetting.baseUrl + '/order/index/delete';


          var posting = $.post( url, {
                'orderid' : item.attr('data-id')
            } );


          posting.done(function( data ) {

          	  if( data.success)
          	  {
              	window.location = globalSetting.baseUrl + '/order/index/search';
              } else {
                WF.showMessage('error', '警告', data.message);
              }
              return;

          });

    });


});