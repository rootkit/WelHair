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

    var validator = $('#frm-deposit-info').Validform({
        tiptype: 3
    });

    $('#btnSave').click(function(){
        if (!validator.check()) {
          return false;
        }

        $('#approvepopin').dialog(
                        {"modal": true,
                         "width":500,
                         "height":240,
                         "title":"批准",
                          buttons:
                                [
                                    {
                                        text: "保存",
                                        class:"u-btn",
                                        click: function()
                                        {
                                            var popin = $(this);
                                            $.ajax({
                                                        type: 'post',
                                                        dataType: 'json',
                                                        url:  globalSetting.baseUrl + '/user/index/depositinfo',
                                                        data: {
                                                            'user_id': $('#user_id').val(),
                                                            'deposit_id': $('#deposit_id').val(),
                                                            'description': $('#description').val(),
                                                            'comments': $('#comments').val(),
                                                            'accountno': $('#accountno').val(),
                                                            'accountname': $('#accountname').val(),
                                                            'amount': $('#amount').val(),
                                                            'status': $('.u-btn-c3:first').attr('data-value')
                                                         },
                                                        success: function(data){
                                                            if( data.success)
                                                            {
                                                                popin.dialog('close');
                                                                 window.location = globalSetting.baseUrl + '/user/index/depositsearch';
                                                            }
                                                            else
                                                            {
                                                                popin.dialog('close');
                                                                WF.showMessage('error', '错误', data.message);
                                                            }
                                                        },
                                                        error:function()
                                                        {
                                                            popin.dialog('close');
                                                             WF.showMessage('error', '错误', '请求错误！');
                                                        }
                                            });
                                        }
                                     },
                                     {
                                            text : "取消",
                                            class: "u-btn",
                                            click: function() {
                                                $(this).dialog('close');
                                                $('.u-btn:first').click();
                                            }
                                     }
                                ]

                    });
    });




});