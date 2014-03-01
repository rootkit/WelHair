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

use Welfony\Repository\BrandRepository;

class BrandService
{

    /*public static function get($id)
    {
        
        return  BrandCategoryRepository::getInstance()->findCategoryById( $id);           
      
    }
    */
    public static function listBrand( $pageNumber, $pageSize)
    {
        $result = array(
            'brands' => array(),
            'total' => 0
        );

        $totalCount = BrandRepository::getInstance()->getAllBrandCount();
        

        if ($totalCount > 0 && $pageNumber <= ceil($totalCount / $pageSize)) {
            
            $searchResult = BrandRepository::getInstance()->listBrand( $pageNumber, $pageSize);
           
            $result['brands']= $searchResult;
        }

        $result['total'] = $totalCount;
        return $result;
    }
    

    public static function save($data)
    {
        $result = array('success' => false, 'message' => '');


        if ($data['BrandId'] == 0) {

            $newId = BrandRepository::getInstance()->save($data);
            if ($newId) {
                $data['BrandId'] = $newId;

                $result['success'] = true;
                $result['brand'] = $data;

                return $result;
            } else {
                $result['message'] = '添加品牌失败！';
                return $result;
            }
        } else {

            $r = BrandRepository::getInstance()->update($data['BrandId'],$data);
            if ($r) {

                $result['success'] = true;
                $result['brand'] = $data;

                return $result;
            } else {
                $result['message'] = '更新品牌失败！';
                return $result;
            }
            return true;
        }
    }

}