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

WF.Coupon = {
	updateCompanyList :function(page)
	{
		 var url =globalSetting.baseUrl + '/company/index/select?page=' + page + '&func= WF.Coupon.updateCompanyList';
		 $.get( url, function(data) {
			$('#companyList').empty();
			$('#companyList').html(data);

			$('#companyList input[type=radio]').click(function(){
				$('#companyname').val($(this).attr('data-name'));
				$('#companyid').val($(this).attr('data-id'));
				$('#companyList').dialog("close");
			});
		 });

	}
};
$(function() {
    $('#frm-coupon-info').Validform({
        tiptype: 3
    });


    $('#coupon-uploader').uploadify({
        fileObjName: 'uploadfile',
        width: 78,
        height: 32,
        multi: false,
        checkExisting: false,
        preventCaching: false,
        fileExt: '*.jpg;*.jpeg;*.png',
        fileDesc: 'Image file (.jpg, .jpeg, .png)',
        buttonText: '选择文件',
        swf: WF.setting.staticAssetBaseUrl + '/swf/uploadify.swf',
        uploader: WF.setting.apiBaseUrl + '/upload/image/original',
        onUploadError: function(file, errorCode, errorMsg, errorString) {
            console.log(errorString);
        },
        onUploadSuccess: function(file, data, response) {
            var result = $.parseJSON(data);
            if (result.success !== false) {
                $('#coupon-image').attr('src', result.OriginalUrl);
                $('#brand-image-url').val(result.OriginalUrl);
            } else {
                WF.showMessage('error', '错误', '上传失败，请重试！');
            }
        }
    });

    $('#btnSelectCompany').click(function(){
    	$('#companyList').dialog({"modal": true, "width":800, "height":640});
    	WF.Coupon.updateCompanyList(1);
    });

    switch( $('#coupon-type').val())
	{
		case '1':
		{
			$('#coupontype_div1').show();
			$('#coupontype_div2').hide();
			break;
		}
		case '2':
		{
			$('#coupontype_div1').hide();
			$('#coupontype_div2').show();
			break;
		}
	}

    $('#coupon-type').change(function(){
    	switch( $(this).val())
    	{
    		case '1':
    		{
    			$('#coupontype_div1').show();
    			$('#coupontype_div2').hide();
    			break;
    		}
    		case '2':
    		{
    			$('#coupontype_div1').hide();
    			$('#coupontype_div2').show();
    			break;
    		}
    	}

    });

    switch( $('#isliveactivity').val())
	{
		case '0':
		{
			$('#liveactivity_div').hide();
			break;
		}
		case '1':
		{
			$('#liveactivity_div').show();
			break;
		}
	}

    $('#isliveactivity').change(function(){
    	switch( $(this).val())
    	{
    		case '0':
			{
				$('#liveactivity_div').hide();
				break;
			}
			case '1':
			{
				$('#liveactivity_div').show();
				break;
			}
    	}

    });

    $('#expiredate').datepicker();


    switch( $('#hasexpire').val())
	{
		case '0':
		{
			$('#expiredate_div').hide();
			break;
		}
		case '1':
		{
			$('#expiredate_div').show();
			break;
		}
	}

    $('#hasexpire').change(function(){
    	switch( $(this).val())
    	{
    		case '0':
			{
				$('#expiredate_div').hide();
				break;
			}
			case '1':
			{
				$('#expiredate_div').show();
				break;
			}
    	}

    });


    switch( $('#couponpaymenttype').val())
	{
		case '1':
		{
			$('#couponpaymenttype_price_div').hide();
			$('#couponpaymenttype_amount_div').hide();
			break;
		}
		case '2':
		{
			$('#couponpaymenttype_price_div').show();
			$('#couponpaymenttype_amount_div').hide();
			break;
		}
		case '3':
		{
			$('#couponpaymenttype_price_div').hide();
			$('#couponpaymenttype_amount_div').show();
			break;
		}
	}

    $('#couponpaymenttype').change(function(){
    	switch( $(this).val())
    	{
    		case '1':
			{
				$('#couponpaymenttype_price_div').hide();
				$('#couponpaymenttype_amount_div').hide();
				break;
			}
			case '2':
			{
				$('#couponpaymenttype_price_div').show();
				$('#couponpaymenttype_amount_div').hide();
				break;
			}
			case '3':
			{
				$('#couponpaymenttype_price_div').hide();
				$('#couponpaymenttype_amount_div').show();
				break;
			}
    	}

    });



    $( "#frm-coupon-info" ).submit(function( event ) {


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
	            'commments': $('#couponcomments').val(),
	            'iscouponcodesecret' : $('span.u-btn-c3').attr('data-value')
            } );


          posting.done(function( data ) {

              window.location = globalSetting.baseUrl + '/coupon/index/search';
              return;

          });

      });
});