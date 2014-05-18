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
        return  DepositRepository::getInstance()->findDepositById( $id);

    }
    public static function listDeposit($pageNumber, $pageSize)
    {
        $result = array(
            'deposits' => array(),
            'total' => 0
        );

        $totalCount = DepositRepository::getInstance()->getAllDepositCount();

        if ($totalCount > 0 && $pageNumber <= ceil($totalCount / $pageSize)) {

            $searchResult = DepositRepository::getInstance()->listDeposit( $pageNumber, $pageSize);

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


            if( isset($data['Amount']) && floatval($data['Amount']) > 0 )
            {
                if(isset($data['UserId']))
                {
                    
                } 
                else
                {
                    $result = array('success' => false, 'message' => '请设置充值对象！');
                    return $result;
                }
            }
            else
            {
                $result = array('success' => false, 'message' => '请设置正确的金额！');
                return $result;
            }

            if( !isset($data['LastUpdateDate']))
            {
                $data['LastUpdateDate'] = date('Y-m-d H:i:s');
            }

            if( !isset($data['CreateTime']))
            {
                $data['CreateTime'] = date('Y-m-d H:i:s');
            }

            $newId = DepositRepository::getInstance()->save($data);
            if ($newId) {
                $data['DepositId'] = $newId;

                $result['success'] = true;
                $result['deposit'] = $data;

                return $result;
            } else {
                $result['message'] = '添加失败！';

                return $result;
            }
        } else {
            if( !isset($data['LastUpdateDate']))
            {
                $data['LastUpdateDate'] = date('Y-m-d H:i:s');
            }
            $r = DepositRepository::getInstance()->update($data['DepositId'],$data);

            if ($r) {

                $result['success'] = true;
                $result['deposit'] = $data;

                return $result;
            } else {
                $result['message'] = '更新失败！';

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
        $r = DepositRepository::getInstance()->succeed($data['WithdrawalId']);
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
