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

use Welfony\Repository\CategoryRepository;

class CateogryService
{

    public static function getCateogryById($id)
    {
        return  CateogryRepository::getInstance()->findCateogryById( $id);

    }
    
    public static function listCateogry($pageNumber, $pageSize)
    {
        $result = array(
            'categories' => array(),
            'total' => 0
        );

        $totalCount = CateogryRepository::getInstance()->getAllCateogryCount();

        if ($totalCount > 0 && $pageNumber <= ceil($totalCount / $pageSize)) {

            $searchResult = CateogryRepository::getInstance()->listCateogry( $pageNumber, $pageSize);

            $result['coupons']= $searchResult;
        }

        $result['total'] = $totalCount;

        return $result;
    }

    public static function save($data)
    {
        $result = array('success' => false, 'message' => '');

        if ($data['CateogryId'] == 0) {

            $newId = CateogryRepository::getInstance()->save($data);
            if ($newId) {
                $data['CateogryId'] = $newId;

                $result['success'] = true;
                $result['cateogry'] = $data;

                return $result;
            } else {
                $result['message'] = '添加商品分类失败！';

                return $result;
            }
        } else {

            $r = CateogryRepository::getInstance()->update($data['CateogryId'],$data);
            if ($r) {

                $result['success'] = true;
                $result['category'] = $data;

                return $result;
            } else {
                $result['message'] = '更新商品分类失败！';

                return $result;
            }

            return true;
        }
    }

    public static function deleteCateogry($data)
    {
        $result = array('success' => false, 'message' => '');
        $r = CateogryRepository::getInstance()->delete($data['CateogryId']);
        if ($r) {

            $result['success'] = true;
            $result['message'] = '删除商品分类成功！';
            return $result;
        } else {
            $result['message'] = '删除商品分类失败！';

            return $result;
        }
    }

}
