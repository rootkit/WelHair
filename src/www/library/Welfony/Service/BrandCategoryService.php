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

use Welfony\Repository\BrandCategoryRepository;

class BrandCategoryService
{

    /*public static function get($id)
    {
        
        return  BrandCategoryRepository::getInstance()->findCategoryById( $id);           
      
    }
   
    public static function list($pageNumber, $pageSize)
    {
        $result = array(
            'brandcategories' => array(),
            'total' => 0
        );

        $totalCount = BrandCategoryRepository::getInstance()->getAllBrandCategoryCount();
        

        if ($totalCount > 0 && $pageNumber <= ceil($totalCount / $pageSize)) {
            
            $searchResult = BrandCategoryRepository::getInstance()->listBrandCategory( $pageNumber, $pageSize);
           
            $result['brandcategories']= $searchResult;
        }

        $result['total'] = $totalCount;
        return $result;
    }
    */

    public static function save($data)
    {
        $result = array('success' => false, 'message' => '');


        if ($data['BrandCategoryId'] == 0) {

            $newId = BrandCategoryRepository::getInstance()->save($data);
            if ($newId) {
                $data['BrandCategoryId'] = $newId;

                $result['success'] = true;
                $result['brandcategory'] = $data;

                return $result;
            } else {
                $result['message'] = '添加品牌分类失败！';
                return $result;
            }
        } else {

            $r = BrandCategoryRepository::getInstance()->update($data['BrandCategoryId'],$data);
            if ($r) {

                $result['success'] = true;
                $result['brandcategory'] = $data;

                return $result;
            } else {
                $result['message'] = '更新品牌分类失败！';
                return $result;
            }
            return true;
        }
    }

}