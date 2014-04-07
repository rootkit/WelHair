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
// ===========================================================================

$(function() {
    function getSelectedIds() {
        var selectedIds = [];
        $('input[name="chk_ids[]"]:checked').each(function() {
            selectedIds.push($(this).val());
        });

        return selectedIds;
    }

    $('#staff-batch-remove').click(function() {
        var selectedIds = getSelectedIds();
        if (selectedIds.length <= 0) {
            WF.showMessage('error', '警告', '请至少选择一项！');
            return false;
        }

        var opts = {
            type: 'POST',
            url: WF.setting.baseUrl + '/ajax/staff/batch',
            dataType: 'json',
            data: {
               'ids': selectedIds.join(','),
               'act': 'remove'
            },
            success: function(data, textStatus, jqXHR) {
                if (data.success) {
                    WF.showMessage('success', '信息', '操作成功！');
                    window.location.reload();
                } else {
                    WF.showMessage('error', '错误', '操作失败！');
                }
            }
        };
        $.ajax(opts);

        return false;
    });

    $('#staff-batch-approve').click(function() {
        var selectedIds = getSelectedIds();
        if (selectedIds.length <= 0) {
            WF.showMessage('error', '警告', '请至少选择一项！');
            return false;
        }

        var opts = {
            type: 'POST',
            url: WF.setting.baseUrl + '/ajax/staff/batch',
            dataType: 'json',
            data: {
               'ids': selectedIds.join(','),
               'act': 'approve'
            },
            success: function(data, textStatus, jqXHR) {
                if (data.success) {
                    WF.showMessage('success', '信息', '操作成功！');
                    window.location.reload();
                } else {
                    WF.showMessage('error', '错误', '操作失败！');
                }
            }
        };
        $.ajax(opts);

        return false;
    });

    $('#staff-batch-unapprove').click(function() {
        var selectedIds = getSelectedIds();
        if (selectedIds.length <= 0) {
            WF.showMessage('error', '警告', '请至少选择一项！');
            return false;
        }

        var opts = {
            type: 'POST',
            url: WF.setting.baseUrl + '/ajax/staff/batch',
            dataType: 'json',
            data: {
               'ids': selectedIds.join(','),
               'act': 'unapprove'
            },
            success: function(data, textStatus, jqXHR) {
                if (data.success) {
                    WF.showMessage('success', '信息', '操作成功！');
                    window.location.reload();
                } else {
                    WF.showMessage('error', '错误', '操作失败！');
                }
            }
        };
        $.ajax(opts);

        return false;
    });
});