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

use Welfony\Repository\CompanyRepository;
use Welfony\Repository\GoodsAttributeRepository;
use Welfony\Repository\GoodsRepository;
use Welfony\Repository\ProductsRepository;
use Welfony\Utility\Util;

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
            $g['PictureUrl'] = !json_decode($g['Img'], true) ? (!$g['Img'] ? array() : array($g['Img'])) : json_decode($g['Img'], true);
            unset($g['Img']);

            $goods[] = $g;
        }

        return array('total' => $total, 'goods' => $goods);
    }

    public static function getGoodsDetail($goodsId, $companyId, $currentUserId = 0, $location = null)
    {
        $goods = GoodsRepository::getInstance()->findGoodsDetailById($goodsId, $currentUserId);
        $goods['PictureUrl'] = !json_decode($goods['Img'], true) ? (!$goods['Img'] ? array() : array($goods['Img'])) : json_decode($goods['Img'], true);
        unset($goods['Img']);

        $hasCompany = false;
        $companySet = CompanyRepository::getInstance()->listAllCompaniesByGoods($goodsId);
        foreach ($companySet as $com) {
            if ($com['CompanyId'] == $companyId) {
                $hasCompany = true;
                break;
            }
        }
        if ($hasCompany) {
            $resultSet = CompanyRepository::getInstance()->findCompanyDetailById($companyId, $currentUserId, $location);
            if (count($resultSet) > 0) {
                $company = $resultSet[0];
                $goods['Company'] = array(
                    'CompanyId' => $company['CompanyId'],
                    'Name' => $company['CompanyName'],
                    'LogoUrl' => $company['CompanyLogoUrl'],
                    'Tel' => $company['Tel'],
                    'Mobile' => $company['Mobile'],
                    'Address' => $company['Address'],
                    'Latitude' => $company['Latitude'],
                    'Longitude' => $company['Longitude'],
                    'Distance' => $company['Distance']
                );
            }
        }

        $products = ProductsRepository::getInstance()->getAllProductsByGoods($goodsId);

        $attributeSet = GoodsAttributeRepository::getInstance()->listByGoods($goodsId);
        $goods['Attributes'] = array();
        $goods['Spec'] = array();
        foreach ($attributeSet as $attr) {
            if ($attr['AttributeId'] > 0 && !empty($attr['Title'])) {
                $goods['Attributes'][] = array (
                    'Title' => $attr['Title'],
                    'Value' => $attr['AttributeValue']
                );
            }
            if ($attr['SpecId'] > 0 && !empty($attr['Title'])) {
                $specIndex = Util::keyValueExistedInArray($goods['Spec'], 'SpecId', $attr['SpecId']);
                if ($specIndex === false) {
                    $spec = array(
                        'SpecId' => $attr['SpecId'],
                        'Title' => $attr['Title'],
                        'Values' => array()
                    );
                } else {
                    $spec = $goods['Spec'][$specIndex];
                }

                $specCanAdd = false;
                foreach ($products as $prod) {
                    $productSpecArr = json_decode($prod['SpecArray'], true);
                    foreach ($productSpecArr as $prodSpec) {
                        if ($prodSpec['Id'] == $attr['SpecId'] && $prodSpec['Value'] == $attr['SpecValue']) {
                            $specCanAdd = true;
                        }
                    }
                }

                if (!$specCanAdd) {
                    continue;
                }

                $spec['Values'][] = array('SpecId' => $attr['SpecId'], 'SpecValue' => $attr['SpecValue']);

                if ($specIndex === false) {
                    $goods['Spec'][] = $spec;
                } else {
                    $goods['Spec'][$specIndex] = $spec;
                }
            }
        }

        foreach ($products as $prod) {
            $p = array(
                'ProductId' => $prod['ProductsId'],
                'Spec' => array(),
                'Price' => $prod['SellPrice']
            );
            $p['Spec'] = json_decode($prod['SpecArray'], true);
            $goods['Products'][] = $p;
        }

        return $goods;
    }

    public static function listByCompany($companyId, $page, $pageSize)
    {
        $page = $page <= 0 ? 1 : $page;
        $pageSize = $pageSize <= 0 ? 20 : $pageSize;

        $total = GoodsRepository::getInstance()->listByCompanyCount($companyId);
        $goodsList = GoodsRepository::getInstance()->listByCompany($companyId, $page, $pageSize);

        $goods = array();
        foreach ($goodsList as $g) {
            $g['PictureUrl'] = !json_decode($g['Img'], true) ? (!$g['Img'] ? array() : array($g['Img'])) : json_decode($g['Img'], true);
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
            $g['PictureUrl'] = !json_decode($g['Img'], true) ? (!$g['Img'] ? array() : array($g['Img'])) : json_decode($g['Img'], true);
            unset($g['Img']);

            if (intval($g['CompanyId'] > 0)) {
                $g['Company'] = array(
                    'CompanyId' => $g['CompanyId'],
                    'Name' => $g['CompanyName'],
                    'LogoUrl' => $g['LogoUrl'],
                    'Tel' => $g['Tel'],
                    'Mobile' => $g['Mobile'],
                    'Address' => $g['Address'],
                    'Latitude' => $g['Latitude'],
                    'Longitude' => $g['Longitude'],
                    'Distance' => $g['Distance']
                );

                unset($g['CompanyId']);
                unset($g['CompanyName']);
                unset($g['LogoUrl']);
                unset($g['Tel']);
                unset($g['Mobile']);
                unset($g['Address']);
                unset($g['Latitude']);
                unset($g['Longitude']);
            }

            $goods[] = $g;
        }

        return array('total' => $total, 'goods' => $goods);
    }

    public static function getGoodsById($id)
    {
        return GoodsRepository::getInstance()->findGoodsById($id);
    }

    public static function listGoods($pageNumber, $pageSize)
    {
        $result = array(
            'goods' => array(),
            'total' => 0
        );

        $totalCount = GoodsRepository::getInstance()->getAllGoodsCount();

        if ($totalCount > 0 && $pageNumber <= ceil($totalCount / $pageSize)) {

            $goodsList = GoodsRepository::getInstance()->listGoods( $pageNumber, $pageSize);
            $goods = array();
            foreach ($goodsList as $g) {
            $g['PictureUrl'] = !json_decode($g['Img'], true) ? (!$g['Img'] ? array() : array($g['Img'])) : json_decode($g['Img'], true);
                $g['PictureUrl'] = json_decode($g['Img']);
                unset($g['Img']);
                $goods[] = $g;
            }

            $result['goods']= $goods;
        }

        $result['total'] = $totalCount;

        return $result;
    }

    public static function listGoodsAndProducts($pageNumber, $pageSize, $companyId = null)
    {
        $pageNumber = $pageNumber <= 0 ? 1 : $pageNumber;
        $pageSize = $pageSize <= 0 ? 20 : $pageSize;

        $result = array(
            'goods' => array(),
            'total' => 0
        );

        $totalCount = GoodsRepository::getInstance()->getAllGoodsAndProductsCount($companyId);

        if ($totalCount > 0 && $pageNumber <= ceil($totalCount / $pageSize)) {
            $goodsList = GoodsRepository::getInstance()->listGoodsAndProducts($pageNumber, $pageSize, $companyId);

            $goods = array();
            foreach ($goodsList as $g) {
            $g['PictureUrl'] = !json_decode($g['Img'], true) ? (!$g['Img'] ? array() : array($g['Img'])) : json_decode($g['Img'], true);
                $g['PictureUrl'] = json_decode($g['Img']);
                unset($g['Img']);
                $goods[] = $g;
            }

            $result['goods']= $goods;
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
