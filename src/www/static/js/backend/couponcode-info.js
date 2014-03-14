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

    $('a.t-action').click(function(){
        $('<tr><td><input name="couponcode" type="text" value="" datatype="s" class="u-ipt"/></td><td><input name="passcode" type="text" value=""  class="u-ipt"/></td></tr>').insertBefore($('.actiontr'));
        $('.content').height($('.content').height() + 50);
    });

    $( "#frm-couponcode-info" ).submit(function( event ) {


          event.preventDefault();

          var form = $( this );

          url = form.attr( "action" );

          var codesandpasscodes = [];

          $('table#tblcoupcode tbody tr').each(function(){

              if( !$(this).hasClass('actiontr') )
              {
                  var row = { 'CouponId': $('#coupon_id').val() ,
                              'Code': $(this).find('input[name="couponcode"]').val() , 
                              'PassCode':$(this).find('input[name="passcode"]').val(),
                              'CouponName': ''
                            };
                  codesandpasscodes.push(row);
              }

            });

          var posting = $.post( url,{ 'codes': codesandpasscodes }
            );


          posting.done(function( data ) {

              //window.location = globalSetting.baseUrl + '/coupon/code/search';
              return;

          });

      });
});