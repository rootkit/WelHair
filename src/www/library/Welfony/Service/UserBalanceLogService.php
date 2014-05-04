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

use Welfony\Repository\UserBalanceLogRepository;

class UserBalanceLogService
{

    public static function getUserBalanceLogById($id)
    {
        return  UserBalanceLogRepository::getInstance()->findUserBalanceLogById( $id);

    }
    public static function listUserBalanceLog($pageNumber, $pageSize)
    {
        $result = array(
            'userbalancelogs' => array(),
            'total' => 0
        );

        $totalCount = UserBalanceLogRepository::getInstance()->getAllUserBalanceLogCount();

        if ($totalCount > 0 && $pageNumber <= ceil($totalCount / $pageSize)) {

            $searchResult = UserBalanceLogRepository::getInstance()->listUserBalanceLog( $pageNumber, $pageSize);

            $result['userbalancelogs']= $searchResult;
        }

        $result['total'] = $totalCount;

        return $result;
    }

    public static function listAllUserBalanceLog()
    {
        return $searchResult = UserBalanceLogRepository::getInstance()->getAllUserBalanceLog();

    }

    public static function save($data)
    {
        $result = array('success' => false, 'message' => '');

        if ($data['UserBalanceLogId'] == 0) {

            $newId = UserBalanceLogRepository::getInstance()->save($data);
            if ($newId) {
                $data['UserBalanceLogId'] = $newId;

                $result['success'] = true;
                $result['userbalancelog'] = $data;

                return $result;
            } else {
                $result['message'] = '添加失败！';

                return $result;
            }
        } else {

            $r = UserBalanceLogRepository::getInstance()->update($data['UserBalanceLogId'],$data);

            if ($r) {

                $result['success'] = true;
                $result['userbalancelog'] = $data;

                return $result;
            } else {
                $result['message'] = '更新失败！';

                return $result;
            }

            return true;
        }
    }

    public static function deleteUserBalanceLog($data)
    {
        $result = array('success' => false, 'message' => '');
        $r = UserBalanceLogRepository::getInstance()->delete($data['UserBalanceLogId']);
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
