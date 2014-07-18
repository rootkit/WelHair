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

use Welfony\Repository\DepositRepository;
use Welfony\Repository\UserRepository;

class DepositService
{

    public static function getDepositById($id)
    {
        return DepositRepository::getInstance()->findDepositById($id);
    }

    public static function getDepositByDepositNo($depositNo)
    {
        return DepositRepository::getInstance()->findDepositByDepositNo($depositNo);
    }

    public static function listDeposit($pageNumber, $pageSize, $userId = null)
    {
        $pageNumber = $pageNumber <= 0 ? 1 : $pageNumber;
        $pageSize = $pageSize <= 0 ? 20 : $pageSize;

        $result = array(
            'deposits' => array(),
            'total' => 0
        );

        $totalCount = DepositRepository::getInstance()->getAllDepositCount($userId);

        if ($totalCount > 0 && $pageNumber <= ceil($totalCount / $pageSize)) {

            $searchResult = DepositRepository::getInstance()->listDeposit($pageNumber, $pageSize, $userId);

            $result['deposits']= $searchResult;
        }

        $result['total'] = $totalCount;

        return $result;
    }

    public static function listAllDeposit()
    {
        return $searchResult = DepositRepository::getInstance()->getAllDeposit();
    }

    public static function save($data)
    {
        $result = array('success' => false, 'message' => '');

        if ($data['DepositId'] == 0) {
            if (isset($data['Amount']) && floatval($data['Amount']) > 0) {
                if (isset($data['UserId']) && intval($data['UserId']) > 0) {

                } else {
                    $result = array('success' => false, 'message' => '请设置充值对象！');
                    return $result;
                }
            } else {
                $result = array('success' => false, 'message' => '请设置正确的金额！');
                return $result;
            }

            $data['CreateTime'] = date('Y-m-d H:i:s');
            $data['LastUpdateDate'] = date('Y-m-d H:i:s');
            $data['DepositNo'] = date('YmdHis').rand(100000, 999999);

            $newId = DepositRepository::getInstance()->save($data);
            if ($newId) {
                $data['DepositId'] = $newId;

                $result['success'] = true;
                $result['deposit'] = $data;

                return $result;
            } else {
                $result['message'] = '充值失败！';
                return $result;
            }
        } else {
            $data['LastUpdateDate'] = date('Y-m-d H:i:s');
            $r = DepositRepository::getInstance()->update($data['DepositId'], $data);

            if ($r) {
                $result['success'] = true;
                $result['deposit'] = $data;

                return $result;
            } else {
                $result['message'] = '充值更新失败！';
                return $result;
            }

            return true;
        }
    }

    public static function deleteDeposit($data)
    {
        $result = array('success' => false, 'message' => '');
        $r = DepositRepository::getInstance()->delete($data['DepositId']);
        if ($r) {

            $result['success'] = true;
            $result['message'] = '删除成功！';

            return $result;
        } else {
            $result['message'] = '删除失败！';

            return $result;
        }
    }

    public static function succeedDeposit($data)
    {
        $result = array('success' => false, 'message' => '');
        $r = DepositRepository::getInstance()->succeed($data['DepositId']);
        if ($r) {

            $result['success'] = true;
            $result['message'] = '批准成功！';

            return $result;
        } else {
            $result['message'] = '批准失败！';

            return $result;
        }
    }


}
