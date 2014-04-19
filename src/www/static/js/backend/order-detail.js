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
    $('#frm-order-detail').Validform({
        tiptype: 3
    });
    $( "#tabs" ).tabs();

    $('#btnSaveOrderNote').click(function(){
    	 $.ajax({
                    type: 'post',
                    dataType: 'json',
                    url:  globalSetting.baseUrl + '/order/index/savenote',
                    data: {
                        'order_id':$('#order_id').val(),
                        'note': $('#note').val()
                     },
                    success: function(data){
                     
                    },
                    error:function()
                    {

                    }
        });
    });
   
});