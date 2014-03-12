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