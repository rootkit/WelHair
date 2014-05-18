<?php

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

namespace Welfony\Service;

use Welfony\Repository\WithdrawalLogRepository;

class WithdrawalLogService
{

    public static function getWithdrawalLogById($id)
    {
        return  WithdrawalLogRepository::getInstance()->findWithdrawalLogById( $id);

    }
    public static function listWithdrawalLog($pageNumber, $pageSize)
    {
        $result = array(
            'withdrawallogs' => array(),
            'total' => 0
        );

        $totalCount = WithdrawalLogRepository::getInstance()->getAllWithdrawalLogCount();

        if ($totalCount > 0 && $pageNumber <= ceil($totalCount / $pageSize)) {

            $searchResult = WithdrawalLogRepository::getInstance()->listWithdrawalLog( $pageNumber, $pageSize);

            $result['withdrawallogs']= $searchResult;
        }

        $result['total'] = $totalCount;

        return $result;
    }

    public static function listWithdrawalLogByWithdrawal($withdrawalId, $pageNumber, $pageSize)
    {
        $result = array(
            'withdrawallogs' => array(),
            'total' => 0
        );

        $totalCount = WithdrawalLogRepository::getInstance()->getAllWithdrawalLogCountByWithdrawal($withdrawalId);

        if ($totalCount > 0 && $pageNumber <= ceil($totalCount / $pageSize)) {

            $searchResult = WithdrawalLogRepository::getInstance()->listWithdrawalLogByWithdrawal($withdrawalId, $pageNumber, $pageSize);

            $result['withdrawallogs']= $searchResult;
        }

        $result['total'] = $totalCount;

        return $result;
    }

    public static function listAllWithdrawalLog()
    {
        return $searchResult = WithdrawalLogRepository::getInstance()->getAllWithdrawalLog();

    }

    public static function save($data)
    {
        $result = array('success' => false, 'message' => '');

        if ($data['WithdrawalLogId'] == 0) {

            $newId = WithdrawalLogRepository::getInstance()->save($data);
            if ($newId) {
                $data['WithdrawalLogId'] = $newId;

                $result['success'] = true;
                $result['withdrawallog'] = $data;

                return $result;
            } else {
                $result['message'] = '添加失败！';

                return $result;
            }
        } else {

            $r = WithdrawalLogRepository::getInstance()->update($data['WithdrawalLogId'],$data);

            if ($r) {

                $result['success'] = true;
                $result['withdrawallog'] = $data;

                return $result;
            } else {
                $result['message'] = '更新失败！';

                return $result;
            }

            return true;
        }
    }

    public static function deleteWithdrawalLog($data)
    {
        $result = array('success' => false, 'message' => '');
        $r = WithdrawalLogRepository::getInstance()->delete($data['WithdrawalLogId']);
        if ($r) {

            $result['success'] = true;
            $result['message'] = '删除成功！';

            return $result;
        } else {
            $result['message'] = '删除失败！';

            return $result;
        }
    }

}
