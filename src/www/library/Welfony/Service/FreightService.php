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

use Welfony\Repository\FreightRepository;

class FreightService
{

    public static function getFreightById($id)
    {
        return  FreightRepository::getInstance()->findFreightById( $id);

    }
    public static function listFreight($pageNumber, $pageSize)
    {
        $result = array(
            'freights' => array(),
            'total' => 0
        );

        $totalCount = FreightRepository::getInstance()->getAllFreightCount();

        if ($totalCount > 0 && $pageNumber <= ceil($totalCount / $pageSize)) {

            $searchResult = FreightRepository::getInstance()->listFreight( $pageNumber, $pageSize);

            $result['freights']= $searchResult;
        }

        $result['total'] = $totalCount;

        return $result;
    }

    public static function listAllFreight()
    {
        return $searchResult = FreightRepository::getInstance()->getAllFreight();

    }

    public static function save($data)
    {
        $result = array('success' => false, 'message' => '');

        if ($data['FreightId'] == 0) {

            $newId = FreightRepository::getInstance()->save($data);
            if ($newId) {
                $data['FreightId'] = $newId;

                $result['success'] = true;
                $result['freight'] = $data;

                return $result;
            } else {
                $result['message'] = '添加物流公司失败！';

                return $result;
            }
        } else {

            $r = FreightRepository::getInstance()->update($data['FreightId'],$data);
            if ($r) {

                $result['success'] = true;
                $result['freight'] = $data;

                return $result;
            } else {
                $result['message'] = '更新物流公司失败！';

                return $result;
            }

            return true;
        }
    }

    public static function deleteFreight($data)
    {
        $result = array('success' => false, 'message' => '');
        $r = FreightRepository::getInstance()->delete($data['FreightId']);
        if ($r) {

            $result['success'] = true;
            $result['message'] = '删除物流公司成功！';

            return $result;
        } else {
            $result['message'] = '删除物流公司失败！';

            return $result;
        }
    }

}
