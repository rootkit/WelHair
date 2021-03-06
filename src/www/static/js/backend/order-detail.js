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

    $( "#tabs" ).tabs({
        activate: function(event ,ui) {
            $(window).resize();
        }
    });

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

    $('#to_pay').click(function(){
        var theButton = $(this);
        $('#paypopin').dialog(
            {"modal": true,
             "width":800,
             "height":640,
             "title":"付款",
              buttons:
                    [
                        {
                            text: "付款",
                            class:"u-btn",
                            click: function()
                            {
                                var popin = $(this);
                                $.ajax({
                                            type: 'post',
                                            dataType: 'json',
                                            url:  globalSetting.baseUrl + '/order/index/payorder',
                                            data: {
                                                'order_id':$('#order_id').val(),
                                                'note':  $('#paynote').val(),
                                                'order_no':$('#order_no').val(),
                                                'orderamount':$('#to_pay_amount').val(),
                                                'payamount':$('#pay_amount').val(),
                                                'paymentid': $('#pay_payment_id').val(),
                                                'userid':$('#order_user').val()
                                             },
                                            success: function(data){
                                                if( data.success)
                                                {
                                                    popin.dialog('close');
                                                    theButton.addClass('u-btn-disabled');
                                                }
                                                else
                                                {
                                                    WF.showMessage('error', '错误', data.message);
                                                }
                                            },
                                            error:function()
                                            {

                                            }
                                });
                            }
                         },
                           {
                                text : "关闭",
                                class: "u-btn",
                                click: function() {
                                    $(this).dialog('close');
                                }
                        }
                    ]

        });
    });
    $('#to_deliver').click(function(){
        if( $('#order_pay_status').val() != '1' )
        {
             WF.showMessage('error', '错误', "您需要支付。");
            return;
        }
        var theButton = $(this);
        $('#deliverpopin').dialog(
            {"modal": true,
             "width":870,
             "height":740,
             "title":"发货",
              buttons:
                    [
                        {
                            text: "发货",
                            class:"u-btn",
                            click: function()
                            {
                                var popin = $(this);
                                $.ajax({
                                            type: 'post',
                                            dataType: 'json',
                                            url:  globalSetting.baseUrl + '/order/index/deliverorder',
                                            data: {
                                                'order_id':$('#order_id').val(),
                                                'note':  $('#delivery_note').val(),
                                                'order_no':$('#order_no').val(),
                                                'name':$('#delivery_accept_name').val(),
                                                'telphone':$('#delivery_telphone').val(),
                                                'mobile':$('#delivery_mobile').val(),
                                                'postcode': $('#delivery_postcode').val(),
                                                'province': $('#sel-province').val(),
                                                'city': $('#sel-city').val(),
                                                'area': $('#sel-district').val(),
                                                'address': $('#delivery_address').val(),
                                                'freight':$('#delivery_freight').val(),
                                                'deliverytype':$('#delivery_type').val(),
                                                'deliverycode':$('#delivery_code').val(),
                                                'userid':$('#order_user').val()
                                             },
                                            success: function(data){
                                                if( data.success)
                                                {
                                                    popin.dialog('close');
                                                    theButton.addClass('u-btn-disabled');
                                                }
                                                else
                                                {
                                                    WF.showMessage('error', '错误', data.message);
                                                }
                                            },
                                            error:function()
                                            {

                                            }
                                });
                            }
                         },
                           {
                                text : "关闭",
                                class: "u-btn",
                                click: function() {
                                    $(this).dialog('close');
                                }
                        }
                    ]

        });
    });


    $('#to_refundment').click(function(){
        var theButton = $(this);
        $('#refoundpopin').dialog(
            {"modal": true,
             "width":800,
             "height":640,
             "title":"退款",
              buttons:
                    [
                        {
                            text: "退款",
                            class:"u-btn",
                            click: function()
                            {
                                var popin = $(this);
                                $.ajax({
                                            type: 'post',
                                            dataType: 'json',
                                            url:  globalSetting.baseUrl + '/order/index/refundorder',
                                            data: {
                                                'order_id':$('#order_id').val(),
                                                'order_no':$('#order_no').val(),
                                                'orderamount':$('#to_pay_amount').val(),
                                                'refundamount':$('#refund_amount').val(),
                                                'userid':$('#order_user').val()
                                             },
                                            success: function(data){
                                                if( data.success)
                                                {
                                                    popin.dialog('close');
                                                    theButton.addClass('u-btn-disabled');
                                                    $('#ctrlButtonArea').find('button').addClass('u-btn-disabled');
                                                    $('#ctrlButtonArea').find('button').attr('disabled', 'disabled');
                                                }
                                                else
                                                {
                                                    WF.showMessage('error', '错误', data.message);
                                                }
                                            },
                                            error:function()
                                            {

                                            }
                                });
                            }
                         },
                           {
                                text : "关闭",
                                class: "u-btn",
                                click: function() {
                                    $(this).dialog('close');
                                }
                        }
                    ]

        });
    });

    $('#to_complete').click(function(){
        var theButton = $(this);

        if( $('#order_status').val() == 1)
        {

            $('<div><p>您需要支付，才能完成！</p></div>').dialog({'title':'提示','modal':true});
        }
        else
        {
            $.ajax({
                        type: 'post',
                        dataType: 'json',
                        url:  globalSetting.baseUrl + '/order/index/completeorder',
                        data: {
                            'order_id':$('#order_id').val(),
                            'order_no':$('#order_no').val(),
                            'userid':$('#order_user').val()
                         },
                        success: function(data){
                            $('#ctrlButtonArea').find('button').addClass('u-btn-disabled');
                            $('#ctrlButtonArea').find('button').attr('disabled', 'disabled');
                        },
                        error:function()
                        {

                        }
            });
        }

    });

    $('#to_discard').click(function(){
        var theButton = $(this);
        $.ajax({
                    type: 'post',
                    dataType: 'json',
                    url:  globalSetting.baseUrl + '/order/index/discardorder',
                    data: {
                        'order_id':$('#order_id').val(),
                        'order_no':$('#order_no').val(),
                        'userid':$('#order_user').val()
                     },
                    success: function(data){
                        $('#ctrlButtonArea').find('button').addClass('u-btn-disabled');
                        $('#ctrlButtonArea').find('button').attr('disabled', 'disabled');
                    },
                    error:function()
                    {

                    }
        });

    });

    $('#ui-id-6').click(function(){
        $.ajax({
                type: 'get',
                dataType: 'text',
                url:  globalSetting.baseUrl + '/order/index/logs',
                data: {
                    'order_id':$('#order_id').val()
                 },
                success: function(data){
                    $('#tab-logs').html(data);
                },
                error:function()
                {

                }
        });
    });

    $('#ui-id-2').click(function(){
        $.ajax({
                type: 'get',
                dataType: 'text',
                url:  globalSetting.baseUrl + '/order/index/paylogs',
                data: {
                    'order_id':$('#order_id').val()
                 },
                success: function(data){
                    $('#tab-2').html(data);
                },
                error:function()
                {

                }
        });
    });

    $('#ui-id-3').click(function(){
        $.ajax({
                type: 'get',
                dataType: 'text',
                url:  globalSetting.baseUrl + '/order/index/deliverylogs',
                data: {
                    'order_id':$('#order_id').val()
                 },
                success: function(data){
                    $('#tab-3').html(data);
                },
                error:function()
                {

                }
        });
    });



    WF.initAreaSelector();
});