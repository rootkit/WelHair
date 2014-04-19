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

use Welfony\Repository\CollectionDocRepository;

class CollectionDocService
{

    public static function getCollectionDocById($id)
    {
        return  CollectionDocRepository::getInstance()->findCollectionDocById( $id);

    }
    public static function listCollectionDoc($pageNumber, $pageSize)
    {
        $result = array(
            'collectiondocs' => array(),
            'total' => 0
        );

        $totalCount = CollectionDocRepository::getInstance()->getAllCollectionDocCount();

        if ($totalCount > 0 && $pageNumber <= ceil($totalCount / $pageSize)) {

            $searchResult = CollectionDocRepository::getInstance()->listCollectionDoc( $pageNumber, $pageSize);

            $result['collectiondocs']= $searchResult;
        }

        $result['total'] = $totalCount;

        return $result;
    }

    public static function listAllCollectionDoc()
    {
        return $searchResult = CollectionDocRepository::getInstance()->getAllCollectionDoc();

    }

    public static function save($data)
    {
        $result = array('success' => false, 'message' => '');

        if ($data['CollectionDocId'] == 0) {

            $newId = CollectionDocRepository::getInstance()->save($data);
            if ($newId) {
                $data['CollectionDocId'] = $newId;

                $result['success'] = true;
                $result['collectiondoc'] = $data;

                return $result;
            } else {
                $result['message'] = '添加收款单失败！';

                return $result;
            }
        } else {

            $r = CollectionDocRepository::getInstance()->update($data['CollectionDocId'],$data);

            if ($r) {

                $result['success'] = true;
                $result['collectiondoc'] = $data;

                return $result;
            } else {
                $result['message'] = '更新收款单失败！';

                return $result;
            }

            return true;
        }
    }

    public static function deleteCollectionDoc($data)
    {
        $result = array('success' => false, 'message' => '');
        $r = CollectionDocRepository::getInstance()->delete($data['CollectionDocId']);
        if ($r) {

            $result['success'] = true;
            $result['message'] = '删除收款单成功！';

            return $result;
        } else {
            $result['message'] = '删除收款单失败！';

            return $result;
        }
    }

}
