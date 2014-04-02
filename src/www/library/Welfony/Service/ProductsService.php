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

class ProductsService
{

    public static function getProductsById($id)
    {
        return  ProductsRepository::getInstance()->findSpecById( $id);
    }

    public static function listProducts($pageNumber, $pageSize)
    {
        $result = array(
            'products' => array(),
            'total' => 0
        );

        $totalCount = ProductsRepository::getInstance()->getAllSpecCount();

        if ($totalCount > 0 && $pageNumber <= ceil($totalCount / $pageSize)) {

            $searchResult = ProductsRepository::getInstance()->listProducts( $pageNumber, $pageSize);

            $result['products']= $searchResult;
        }

        $result['total'] = $totalCount;

        return $result;
    }

    public static function listAllProducts()
    {
        return $searchResult = ProductsRepository::getInstance()->getAllProducts();   
    }

    public static function save($data)
    {
        $result = array('success' => false, 'message' => '');

        if ($data['ProductsId'] == 0) {

            $newId = ProductsRepository::getInstance()->save($data);
            if ($newId) {
                $data['ProductsId'] = $newId;

                $result['success'] = true;
                $result['message'] = '添加产品成功！';
                $result['products'] = $data;

                return $result;
            } else {
                $result['message'] = '添加产品失败！';

                return $result;
            }
        } else {

            $r = ProductsRepository::getInstance()->update($data['ProductsId'],$data);
            if ($r) {

                $result['success'] = true;
                $result['message'] = '更新产品成功！';
                $result['products'] = $data;

                return $result;
            } else {
                $result['message'] = '更新产品失败！';

                return $result;
            }

            return true;
        }
    }


    public static function deleteProducts($data)
    {
        $result = array('success' => false, 'message' => '');
        $r = ProductsRepository::getInstance()->delete($data['ProductsId']);
        if ($r) {

            $result['success'] = true;
            $result['message'] = '删除产品成功！';
            return $result;
        } else {
            $result['message'] = '删除产品失败！';

            return $result;
        }
    }

}
