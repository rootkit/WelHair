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

use Welfony\Repository\GoodsRepository;

class GoodsService
{

    public static function listLikedGoods($userId, $page, $pageSize)
    {
        $page = $page <= 0 ? 1 : $page;
        $pageSize = $pageSize <= 0 ? 20 : $pageSize;

        $total = GoodsRepository::getInstance()->listLikedGoodsCount($userId);
        $goodsList = GoodsRepository::getInstance()->listLikedGoods($userId, $page, $pageSize);

        $goods = array();
        foreach ($goodsList as $g) {
            $g['PictureUrl'] = array($g['Img']);
            unset($g['Img']);

            $goods[] = $g;
        }

        return array('total' => $total, 'goods' => $goods);
    }

    public static function listByCompany($companyId, $page, $pageSize)
    {
        $page = $page <= 0 ? 1 : $page;
        $pageSize = $pageSize <= 0 ? 20 : $pageSize;

        $total = GoodsRepository::getInstance()->listByCompanyCount($companyId);
        $goodsList = GoodsRepository::getInstance()->listByCompany($companyId, $page, $pageSize);

        $goods = array();
        foreach ($goodsList as $g) {
            $g['PictureUrl'] = array($g['Img']);
            unset($g['Img']);

            $goods[] = $g;
        }

        return array('total' => $total, 'goods' => $goods);
    }

    public static function search($currentUserId, $searchText, $city, $district, $sort, $location, $page, $pageSize)
    {
        $page = $page <= 0 ? 1 : $page;
        $pageSize = $pageSize <= 0 ? 20 : $pageSize;

        $total = GoodsRepository::getInstance()->searchCount($searchText, $city, $district);
        $goodsList = GoodsRepository::getInstance()->search($currentUserId, $searchText, $city, $district, $sort, $location, $page, $pageSize);

        $goods = array();
        foreach ($goodsList as $g) {
            $g['PictureUrl'] = array($g['Img']);
            unset($g['Img']);

            $goods[] = $g;
        }

        return array('total' => $total, 'goods' => $goods);
    }

    public static function getGoodsById($id)
    {
        return GoodsRepository::getInstance()->findGoodsById( $id);
    }

    public static function listGoods($pageNumber, $pageSize)
    {
        $result = array(
            'goods' => array(),
            'total' => 0
        );

        $totalCount = GoodsRepository::getInstance()->getAllGoodsCount();

        if ($totalCount > 0 && $pageNumber <= ceil($totalCount / $pageSize)) {

            $searchResult = GoodsRepository::getInstance()->listGoods( $pageNumber, $pageSize);

            $result['goods']= $searchResult;
        }

        $result['total'] = $totalCount;

        return $result;
    }

    public static function listGoodsAndProducts($pageNumber, $pageSize)
    {
        $result = array(
            'goods' => array(),
            'total' => 0
        );

        $totalCount = GoodsRepository::getInstance()->getAllGoodsAndProductsCount();

        if ($totalCount > 0 && $pageNumber <= ceil($totalCount / $pageSize)) {

            $searchResult = GoodsRepository::getInstance()->listGoodsAndProducts( $pageNumber, $pageSize);

            $result['goods']= $searchResult;
        }

        $result['total'] = $totalCount;

        return $result;
    }

    public static function listAllGoods()
    {
        return $searchResult = GoodsRepository::getInstance()->getAllGoods();
    }

    public static function listAllGoodsByCompany($companyId)
    {
        return $searchResult = GoodsRepository::getInstance()->getAllGoodsByCompany($companyId);
    }

    public static function save($data,$categories=null,$attributes=null, $products=null, $recommends=null, $companies=null)
    {
        $result = array('success' => false, 'message' => '');

        if ($data['GoodsId'] == 0) {
            $newId = GoodsRepository::getInstance()->save($data,$categories,$attributes, $products, $recommends, $companies);
            if ($newId) {
                $data['GoodsId'] = $newId;

                $result['success'] = true;
                $result['message'] = '添加商品成功！';
                $result['goods'] = $data;

                return $result;
            } else {
                $result['message'] = '添加商品失败！';

                return $result;
            }
        } else {

            $r = GoodsRepository::getInstance()->update($data['GoodsId'],$data,$categories,$attributes, $products, $recommends, $companies);
            if ($r) {

                $result['success'] = true;
                $result['message'] = '更新商品成功！';
                $result['goods'] = $data;

                return $result;
            } else {
                $result['message'] = '更新商品失败！';

                return $result;
            }

            return true;
        }
    }

    public static function deleteGoods($data)
    {
        $result = array('success' => false, 'message' => '');
        $r = GoodsRepository::getInstance()->delete($data['GoodsId']);
        if ($r) {

            $result['success'] = true;
            $result['message'] = '删除商品成功！';

            return $result;
        } else {
            $result['message'] = '删除商品失败！';

            return $result;
        }
    }

}
