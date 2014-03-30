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

use Welfony\Repository\SpecRepository;

class SpecService
{

    public static function getSpecById($id)
    {
        return  SpecRepository::getInstance()->findSpecById( $id);

    }

    public static function listSpecByModel($modelId, $pageNumber, $pageSize)
    {
        $result = array(
            'specs' => array(),
            'total' => 0
        );

        $totalCount = SpecRepository::getInstance()->getSpecCountByModel($modelId);

        if ($totalCount > 0 && $pageNumber <= ceil($totalCount / $pageSize)) {

            $searchResult = SpecRepository::getInstance()->listSpecByModel( $modelId, $pageNumber, $pageSize);

            $result['specs']= $searchResult;
        }

        $result['total'] = $totalCount;

        return $result;
    }

    public static function listSpec($pageNumber, $pageSize)
    {
        $result = array(
            'specs' => array(),
            'total' => 0
        );

        $totalCount = SpecRepository::getInstance()->getAllSpecCount();

        if ($totalCount > 0 && $pageNumber <= ceil($totalCount / $pageSize)) {

            $searchResult = SpecRepository::getInstance()->listSpec( $pageNumber, $pageSize);

            $result['specs']= $searchResult;
        }

        $result['total'] = $totalCount;

        return $result;
    }

    public static function save($data)
    {
        $result = array('success' => false, 'message' => '');

        if ($data['SpecId'] == 0) {

            $newId = SpecRepository::getInstance()->save($data);
            if ($newId) {
                $data['SpecId'] = $newId;

                $result['success'] = true;
                $result['message'] = '添加规格成功！';
                $result['spec'] = $data;

                return $result;
            } else {
                $result['message'] = '添加规格失败！';

                return $result;
            }
        } else {

            $r = SpecRepository::getInstance()->update($data['SpecId'],$data);
            if ($r) {

                $result['success'] = true;
                $result['message'] = '更新规格成功！';
                $result['spec'] = $data;

                return $result;
            } else {
                $result['message'] = '更新规格失败！';

                return $result;
            }

            return true;
        }
    }


    public static function deleteSpec($data)
    {
        $result = array('success' => false, 'message' => '');
        $r = SpecRepository::getInstance()->delete($data['SpecId']);
        if ($r) {

            $result['success'] = true;
            $result['message'] = '删除规格成功！';
            return $result;
        } else {
            $result['message'] = '删除规格失败！';

            return $result;
        }
    }

}
