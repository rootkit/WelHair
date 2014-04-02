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

use Welfony\Repository\AttributeRepository;

class AttributeService
{

    public static function getAttributeById($id)
    {
        return  AttributeRepository::getInstance()->findAttributeById( $id);

    }

    public static function listAttributeByModel($modelId, $pageNumber, $pageSize)
    {
        $result = array(
            'attributes' => array(),
            'total' => 0
        );

        $totalCount = AttributeRepository::getInstance()->getAttributeCountByModel($modelId);

        if ($totalCount > 0 && $pageNumber <= ceil($totalCount / $pageSize)) {

            $searchResult = AttributeRepository::getInstance()->listAttributeByModel( $modelId, $pageNumber, $pageSize);

            $result['attributes']= $searchResult;
        }

        $result['total'] = $totalCount;

        return $result;
    }

    public static function listAttribute($pageNumber, $pageSize)
    {
        $result = array(
            'attributes' => array(),
            'total' => 0
        );

        $totalCount = AttributeRepository::getInstance()->getAllAttributeCount();

        if ($totalCount > 0 && $pageNumber <= ceil($totalCount / $pageSize)) {

            $searchResult = AttributeRepository::getInstance()->listAttribute( $pageNumber, $pageSize);

            $result['attributes']= $searchResult;
        }

        $result['total'] = $totalCount;

        return $result;
    }

    public static function listAllAttribute()
    {
        return $searchResult = AttributeRepository::getInstance()->getAllAttribute();
    }

    public static function listAllAttributeByModel($modelId)
    {
        return $searchResult = AttributeRepository::getInstance()->listAllAttributeByModel($modelId);
    }

    public static function save($data)
    {
        $result = array('success' => false, 'message' => '');

        if ($data['AttributeId'] == 0) {

            $newId = AttributeRepository::getInstance()->save($data);
            if ($newId) {
                $data['AttributeId'] = $newId;

                $result['success'] = true;
                $result['message'] = '添加属性成功！';
                $result['attribute'] = $data;

                return $result;
            } else {
                $result['message'] = '添加属性失败！';

                return $result;
            }
        } else {

            $r = AttributeRepository::getInstance()->update($data['AttributeId'],$data);
            if ($r) {

                $result['success'] = true;
                $result['message'] = '更新属性成功！';
                $result['attribute'] = $data;

                return $result;
            } else {
                $result['message'] = '更新属性失败！';

                return $result;
            }

            return true;
        }
    }

    public static function deleteAttribute($data)
    {
        $result = array('success' => false, 'message' => '');
        $r = AttributeRepository::getInstance()->delete($data['AttributeId']);
        if ($r) {

            $result['success'] = true;
            $result['message'] = '删除属性成功！';

            return $result;
        } else {
            $result['message'] = '删除属性失败！';

            return $result;
        }
    }

}
