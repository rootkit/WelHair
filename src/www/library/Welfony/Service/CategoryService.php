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

class CategoryService
{

    public static function getCategoryById($id)
    {
        return  CategoryRepository::getInstance()->findCateogryById( $id);

    }
    
    public static function listCategory($pageNumber, $pageSize)
    {
        $result = array(
            'categories' => array(),
            'total' => 0
        );

        $totalCount = CategoryRepository::getInstance()->getAllCategoryCount();

        if ($totalCount > 0 && $pageNumber <= ceil($totalCount / $pageSize)) {

            $searchResult = CategoryRepository::getInstance()->listCategory( $pageNumber, $pageSize);

            $result['categories']= $searchResult;
        }

        $result['total'] = $totalCount;

        return $result;
    }

    public static function listAllCategory()
    {
     
        $searchResult = CategoryRepository::getInstance()->getAllCategory();
        return $searchResult;
    }

    public static function listCategoryByGoods()
    {
     
        $searchResult = CategoryRepository::getInstance()->getAllCategoryByGoods();
        return $searchResult;
    }

    public static function save($data)
    {
        $result = array('success' => false, 'message' => '');

        if ($data['CategoryId'] == 0) {

            $newId = CategoryRepository::getInstance()->save($data);
            if ($newId) {
                $data['CategoryId'] = $newId;

                $result['success'] = true;
                $result['category'] = $data;

                return $result;
            } else {
                $result['message'] = '添加商品分类失败！';

                return $result;
            }
        } else {

            $r = CategoryRepository::getInstance()->update($data['CategoryId'],$data);
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

    public static function deleteCategory($data)
    {
        $result = array('success' => false, 'message' => '');
        $r = CategoryRepository::getInstance()->delete($data['CategoryId']);
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
