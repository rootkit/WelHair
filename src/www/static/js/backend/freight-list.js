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

          var url = globalSetting.baseUrl + '/system/freight/delete';

          
          var posting = $.post( url, { 
                'freightid' : item.attr('data-id')
            } );


          posting.done(function( data ) {

          	  if( data.success)
          	  {
              	window.location = globalSetting.baseUrl + '/system/freight/search';
              }
              return;

          });

    });

    
});