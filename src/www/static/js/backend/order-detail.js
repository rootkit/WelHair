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

    $('#to_pay').click(function(){
        $('#paypopin').dialog(
            {"modal": true, 
             "width":800, 
             "height":640,
             "title":"付款",
              buttons: 
                    [
                        {
                            text: "付款",
                            class:"",
                            click: function()
                            {
                            }
                         },
                           {
                                text : "关闭",
                                class: "",
                                click: function() {
                                    $(this).dialog('close');
                                }
                        } 
                    ]

        });
    });
    $('#to_deliver').click(function(){
        $('#deliverpopin').dialog(
            {"modal": true, 
             "width":870, 
             "height":740,
             "title":"发货",
              buttons: 
                    [
                        {
                            text: "发货",
                            class:"",
                            click: function()
                            {
                            }
                         },
                           {
                                text : "关闭",
                                class: "",
                                click: function() {
                                    $(this).dialog('close');
                                }
                        } 
                    ]

        });
    });
   
   
});