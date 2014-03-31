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

use Welfony\Repository\ModelRepository;

class ModelService
{

    public static function getModelById($id)
    {
        return  ModelRepository::getInstance()->findModelById( $id);

    }
    public static function listModel($pageNumber, $pageSize)
    {
        $result = array(
            'models' => array(),
            'total' => 0
        );

        $totalCount = ModelRepository::getInstance()->getAllModelCount();

        if ($totalCount > 0 && $pageNumber <= ceil($totalCount / $pageSize)) {

            $searchResult = ModelRepository::getInstance()->listModel( $pageNumber, $pageSize);

            $result['models']= $searchResult;
        }

        $result['total'] = $totalCount;

        return $result;
    }

    public static function listAllModel()
    {


        return $searchResult = ModelRepository::getInstance()->getAllModel();

      
    }

    public static function save($data)
    {
        $result = array('success' => false, 'message' => '');

        if ($data['ModelId'] == 0) {

            $newId = ModelRepository::getInstance()->save($data);
            if ($newId) {
                $data['ModelId'] = $newId;

                $result['success'] = true;
                $result['model'] = $data;

                return $result;
            } else {
                $result['message'] = '添加模型失败！';

                return $result;
            }
        } else {

            $r = ModelRepository::getInstance()->update($data['ModelId'],$data);
            if ($r) {

                $result['success'] = true;
                $result['model'] = $data;

                return $result;
            } else {
                $result['message'] = '更新模型失败！';

                return $result;
            }

            return true;
        }
    }

    public static function deleteModel($data)
    {
        $result = array('success' => false, 'message' => '');
        $r = ModelRepository::getInstance()->delete($data['ModelId']);
        if ($r) {

            $result['success'] = true;
            $result['message'] = '删除模型成功！';
            return $result;
        } else {
            $result['message'] = '删除模型失败！';

            return $result;
        }
    }

}
