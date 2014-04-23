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

use Welfony\Repository\DeliveryDocRepository;

class DeliveryDocService
{

    public static function getDeliveryDocById($id)
    {
        return  DeliveryDocRepository::getInstance()->findDeliveryDocById( $id);
    }

    public static function getDeliveryDocByOrder($oid)
    {
        return  DeliveryDocRepository::getInstance()->findDeliveryDocByOrder( $oid);

    }

    public static function listDeliveryDoc($pageNumber, $pageSize)
    {
        $result = array(
            'deliverydocs' => array(),
            'total' => 0
        );

        $totalCount = DeliveryDocRepository::getInstance()->getAllDeliveryDocCount();

        if ($totalCount > 0 && $pageNumber <= ceil($totalCount / $pageSize)) {

            $searchResult = DeliveryDocRepository::getInstance()->listDeliveryDoc( $pageNumber, $pageSize);

            $result['deliverydocs']= $searchResult;
        }

        $result['total'] = $totalCount;

        return $result;
    }

    public static function listAllDeliveryDoc()
    {
        return $searchResult = DeliveryRepositoryDoc::getInstance()->getAllDeliveryDoc();

    }

    public static function save($data)
    {
        $result = array('success' => false, 'message' => '');

        if ($data['DeliveryDocId'] == 0) {

            $newId = DeliveryRepositoryDoc::getInstance()->save($data);
            if ($newId) {
                $data['DeliveryDocId'] = $newId;

                $result['success'] = true;
                $result['delivery'] = $data;

                return $result;
            } else {
                $result['message'] = '添加配送单失败！';

                return $result;
            }
        } else {

            $r = DeliveryRepositoryDoc::getInstance()->update($data['DeliveryDocId'],$data);

            if ($r) {

                $result['success'] = true;
                $result['delivery'] = $data;

                return $result;
            } else {
                $result['message'] = '更新配送单失败！';

                return $result;
            }

            return true;
        }
    }

    public static function deleteDeliveryDoc($data)
    {
        $result = array('success' => false, 'message' => '');
        $r = DeliveryDocRepository::getInstance()->delete($data['DeliveryDocId']);
        if ($r) {

            $result['success'] = true;
            $result['message'] = '删除配送单成功！';

            return $result;
        } else {
            $result['message'] = '删除配送单失败！';

            return $result;
        }
    }

}
