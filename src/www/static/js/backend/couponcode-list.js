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
    
    $( ".btndelete" ).click(function( event ) {


          event.preventDefault();

          var form = $( this );

          var url = form.attr( "action" );

          var couponTypeValue = '';
          switch( $('#coupon-type').val())
		  {
			case '1':
			{
				couponTypeValue =$('#coupontype_total').val() + ',' + $('#coupontype_minus').val();
				break;
			}
			case '2':
			{
				couponTypeValue =$('#coupontype_amount').val();
				break;
			}
		  }

		  var couponpaymentvalue = '';
		  switch( $('#couponpaymenttype').val())
		  {
				case '1':
				{
					couponpaymentvalue = '';
					break;
				}
				case '2':
				{
					couponpaymentvalue = $('#couponpaymenttype_price').val();
					break;
				}
				case '3':
				{
					couponpaymentvalue = $('#couponpaymenttype_amount').val();
					break;
				}
		  }

          var posting = $.post( url, { 
                'couponid' : $('#couponid').val(),
	            'companyname' : $('#companyname').val(),
	            'imageurl' : $('#coupon_image_url').val(),
	            'companyid' : $('#companyid').val(),
	            'couponname' : $('#couponname').val(),
	            'coupontypeid' : $('#coupon-type').val(),
	            'coupontypevalue' : couponTypeValue,
	            'isliveactivity' : $('#isliveactivity').val(),
	            'liveactivityamount' :$('#liveactiveamount').val(),
	            'liveactivityaddress' :$('#liveactivityaddress').val(),
	            'hasexpire' : $('#hasexpire').val(),
	            'expiredate' :$('#expiredate').val(),
	            'couponamountlimittypeid' : $('#couponamountlimittype').val(),
	            'couponaccountlimittypeid' : $('#couponaccountlimittype').val(),
	            'couponpaymenttypeid' : $('#couponpaymenttype').val(),
	            'couponpaymentvalue' : couponpaymentvalue,
	            'usage' :  $('#couponusage').val(),
	            'comments': $('#couponcomments').val(),
	            'iscouponcodesecret' : $('span.u-btn-c3').attr('data-value')
            } );


          posting.done(function( data ) {

              window.location = globalSetting.baseUrl + '/coupon/index/search';
              return;

          });

      });

      $( ".btnDelete" ).click(function( event ) {


          event.preventDefault();

          var item = $( this );

          var url = globalSetting.baseUrl + '/coupon/code/delete';

          
          var posting = $.post( url, { 
                'couponcodeid' : item.attr('data-id')
            } );


          posting.done(function( data ) {

          	  if( data.success)
          	  {
              	window.location = globalSetting.baseUrl + '/coupon/code/search?coupon_id=' + item.attr('data-couponid') + '&coupon_name=' + item.attr('data-couponname');
              }
              return;

          });

    });
});