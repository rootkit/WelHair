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

use Welfony\Repository\DeliveryRepository;

class DeliveryService
{

    public static function getDeliveryById($id)
    {
        return  DeliveryRepository::getInstance()->findDeliveryById( $id);

    }
    public static function listDelivery($pageNumber, $pageSize)
    {
        $result = array(
            'deliveries' => array(),
            'total' => 0
        );

        $totalCount = DeliveryRepository::getInstance()->getAllDeliveryCount();

        if ($totalCount > 0 && $pageNumber <= ceil($totalCount / $pageSize)) {

            $searchResult = DeliveryRepository::getInstance()->listDelivery( $pageNumber, $pageSize);

            $result['deliveries']= $searchResult;
        }

        $result['total'] = $totalCount;

        return $result;
    }

    public static function listAllDelivery()
    {
        return $searchResult = DeliveryRepository::getInstance()->getAllDelivery();

    }

    public static function save($data)
    {
        $result = array('success' => false, 'message' => '');

        if ($data['DeliveryId'] == 0) {

            $newId = DeliveryRepository::getInstance()->save($data);
            if ($newId) {
                $data['DeliveryId'] = $newId;

                $result['success'] = true;
                $result['delivery'] = $data;

                return $result;
            } else {
                $result['message'] = '添加配送方式失败！';

                return $result;
            }
        } else {

            $r = DeliveryRepository::getInstance()->update($data['DeliveryId'],$data);
            if ($r) {

                $result['success'] = true;
                $result['delivery'] = $data;

                return $result;
            } else {
                $result['message'] = '更新配送方式失败！';

                return $result;
            }

            return true;
        }
    }

    public static function deleteDelivery($data)
    {
        $result = array('success' => false, 'message' => '');
        $r = DeliveryRepository::getInstance()->delete($data['DeliveryId']);
        if ($r) {

            $result['success'] = true;
            $result['message'] = '删除配送方式成功！';

            return $result;
        } else {
            $result['message'] = '删除配送方式失败！';

            return $result;
        }
    }

}
