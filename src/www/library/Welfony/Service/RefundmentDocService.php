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

use Welfony\Repository\RefundmentDocRepository;

class RefundmentDocService
{

    public static function getRefundmentDocById($id)
    {
        return  RefundmentDocRepository::getInstance()->findRefundmentDocById( $id);
    }

    public static function listRefundmentDoc($pageNumber, $pageSize)
    {
        $result = array(
            'refundmentdocs' => array(),
            'total' => 0
        );

        $totalCount = DeliveryRepository::getInstance()->getAllRefundmentDocCount();

        if ($totalCount > 0 && $pageNumber <= ceil($totalCount / $pageSize)) {

            $searchResult = RefundmentDocRepository::getInstance()->listRefundmentDoc( $pageNumber, $pageSize);

            $result['refundmentdocs']= $searchResult;
        }

        $result['total'] = $totalCount;

        return $result;
    }

    public static function listAllRefundmentDoc()
    {
        return $searchResult = RefundmentDocRepository::getInstance()->getAllRefundmentDoc();

    }

    public static function save($data)
    {
        $result = array('success' => false, 'message' => '');

        if ($data['RefundmentDocId'] == 0) {

            $newId = RefundmentDocRepository::getInstance()->save($data);
            if ($newId) {
                $data['DeliveryId'] = $newId;

                $result['success'] = true;
                $result['refundmentdoc'] = $data;

                return $result;
            } else {
                $result['message'] = '添加退款单失败！';

                return $result;
            }
        } else {

            $r = RefundmentDocRepository::getInstance()->update($data['RefundmentDocId'],$data);

            if ($r) {

                $result['success'] = true;
                $result['refundmentdoc'] = $data;

                return $result;
            } else {
                $result['message'] = '更新退款单失败！';

                return $result;
            }

            return true;
        }
    }

    public static function deleteRefundmentDoc($data)
    {
        $result = array('success' => false, 'message' => '');
        $r = RefundmentDocRepository::getInstance()->delete($data['RefundmentDocId']);
        if ($r) {

            $result['success'] = true;
            $result['message'] = '删除退款单成功！';

            return $result;
        } else {
            $result['message'] = '删除退款单失败！';

            return $result;
        }
    }

    public static function getRefundmentDocByOrder($oid)
    {
        return  RefundmentDocRepository::getInstance()->findRefundmentDocByOrder( $oid);

    }

}
