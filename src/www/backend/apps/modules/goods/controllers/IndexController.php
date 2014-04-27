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

use Welfony\Controller\Base\AbstractAdminController;
use Welfony\Core\Enum\CompanyStatus;
use Welfony\Service\GoodsService;
use Welfony\Service\CategoryService;
use Welfony\Service\BrandService;
use Welfony\Service\ModelService;
use Welfony\Service\CompanyService;
use Welfony\Service\ProductsService;
use Welfony\Service\RecommendGoodsService;
use Welfony\Service\GoodsAttributeService;
use Welfony\Utility\Util;

class Goods_IndexController extends AbstractAdminController
{

    const GOODS_PREFIX = 'SD';
    public function searchAction()
    {
        $this->view->pageTitle = '商品列表';
         $pageSize = 10;
        $page =  intval($this->_request->getParam('page'));

        $page =  $page<=0? 1 : $page;

        $result = GoodsService::listGoods($page, $pageSize);

        $this->view->rows = $result['goods'];

        $this->view->pagerHTML =  $this->renderPager($this->view->baseUrl('/goods/index/search?'),
                                                     $page,
                                                     ceil($result['total'] / $pageSize));
    }

    public function infoAction()
    {
        $this->view->pageTitle = '添加商品';

        $this->view->defaultgoodsno= self::GOODS_PREFIX.time().rand(10,99);
        $this->view->categories=CategoryService::listAllCategory();
        $this->view->models=ModelService::listAllModel();
        $this->view->brands=BrandService::listAllBrand();
        $companyList = CompanyService::listAllCompanies(array(
            CompanyStatus::Valid
        ), 1, 100);
        $this->view->companies = $companyList['companies'];

        $goodsId = $this->_request->getParam('goods_id')?  intval($this->_request->getParam('goods_id')) : 0;

        $goods = array(
            'GoodsId' => $goodsId,
            'Name' => '',
            'GoodsNo'=>'',
            'BrandId'=>0,
            'ModelId'=>0,
            'Point' =>0,
            'Sort' => 0,
            'StoreNums'=>0,
            'Unit'=>'',
            'Experience'=>0,
            'SellPrice'=>0,
            'MarketPrice'=>0,
            'CostPrice'=>0,
            'Weight'=>0,
            'Img'=>Util::baseAssetUrl('img/photo-default.png'),
            'IsDeleted' => 0,
            'Keywords' => '',
            'Content' => ''
        );
        $this->view->goodscompanies=[];
        $this->view->goodscategories=[];
        $this->view->recommends = [];
        $this->view->products = [];
        $this->view->goodsattributes = [];

        if ($this->_request->isPost()) {
            $goods['Name']= htmlspecialchars($this->_request->getParam('name'));
            $goods['GoodsNo']= htmlspecialchars($this->_request->getParam('goodsno'));
            $goods['ModelId']= $this->_request->getParam('modelid');
            $goods['BrandId']= $this->_request->getParam('brandid');
            $goods['Sort']= $this->_request->getParam('sort');
            $goods['Unit']= $this->_request->getParam('unit');
            $goods['Experience']= $this->_request->getParam('experience');
            $goods['CostPrice']= $this->_request->getParam('costprice');
            $goods['SellPrice']= $this->_request->getParam('sellprice');
            $goods['MarketPrice']= $this->_request->getParam('marketprice');
            $goods['Keywords']= $this->_request->getParam('keywords');
            $goods['SpecArray']= $this->_request->getParam('specarray');
            $goods['StoreNums']= $this->_request->getParam('storenums');
            $goods['Weight']= $this->_request->getParam('weight');
            $goods['Img']= $this->_request->getParam('img');
            $goods['Content']= $this->_request->getParam('content');

            $goods['CreateTime'] = date('Y-m-d H:i:s');
            if( $goodsId )
            {
                if( $this->_request->getParam('isup'))
                {
                     $goods['UpTime'] = date('Y-m-d H:i:s');
                }
                else
                {
                    $goods['DownTime'] = date('Y-m-d H:i:s');
                }
            }

            $categories =  $this->_request->getParam('categories');
            $attributes = $this->_request->getParam('attributes');
            $attrArray = array();
            if( $attributes)
            {
                foreach( $attributes as &$attr)
                {
                    if( !$attr['SpecId'] )
                    {
                        $attr['SpecId'] = NULL;
                        $attr['SpecValue'] = NULL;
                    }
                    if( !$attr['AttributeId'] )
                    {
                        $attr['AttributeId'] = NULL;
                        $attr['AttributeValue'] = NULL;
                    }
                    if( $attr['SpecId'] || $attr['AttributeId'] )
                    {
                        $attrArray[] = $attr;
                    }

                }
            }
            $products = $this->_request->getParam('products');
            $recommends = $this->_request->getParam('recommendgoods');
            $companies = $this->_request->getParam('companies');

            $result = GoodsService::save($goods,$categories,$attrArray,$products,$recommends,$companies);
            /*
            if ($result['success']) {

                $this->view->successMessage = '保存商品成功！';
            } else {
                $this->view->errorMessage = $result['message'];
            }
            */
            if ($result['success']) {
                $result['message'] = '保存商品成功！';
            }
            $this->_helper->json->sendJson($result);
        } else {

            if ($goodsId > 0) {
                $goods = GoodsService::getGoodsById($goodsId);
                $catArray = CategoryService::listAllCategoryByGoods($goodsId);
                $goodsCats = array();
                foreach( $catArray as $cat )
                {
                    $goodsCats[] = $cat['CategoryId'];
                }
                $this->view->goodscategories=$goodsCats;

                $comArray = CompanyService::listAllByGoods($goodsId);
                $cArray = array();
                foreach( $comArray as $com)
                {
                    $cArray[] = $com['CompanyId'];
                }
                $this->view->goodscompanies=$cArray;

                $recomendArray = RecommendGoodsService::listAllByGoods($goodsId);
                $recommends = array();
                foreach($recomendArray as $recomend)
                {
                    $recommends[] = $recomend['RecommendId'];
                }

                $this->view->recommends=$recommends;

                $this->view->products=ProductsService::listAllProductsByGoods($goodsId);
                $this->view->goodsattributes = GoodsAttributeService::listExtendByGoods($goodsId);

                if (!$goods) {
                    // process not exist logic;
                }
            }
        }

        $this->view->goodsInfo = $goods;
    }

    public function deleteAction()
    {
        $this->_helper->viewRenderer->setNoRender(true);
        $this->_helper->layout->disableLayout();

        $goodsId =  intval($this->_request->getParam('goodsid')) ;

        $goods = array('GoodsId' => $goodsId);

        if ($this->_request->isPost()) {

            $result = GoodsService::deleteGoods($goods);
            $this->_helper->json->sendJson($result);
        }
    }

    public function selectAction()
    {
        //$this->_helper->viewRenderer->setNoRender(true);
        $this->_helper->layout->disableLayout();

        static $pageSize = 10;

        $page = intval($this->_request->getParam('page'));
        $func = $this->_request->getParam('func');

        $searchResult = GoodsService::listGoodsAndProducts($page, $pageSize);
        $this->view->rows = $searchResult['goods'];
        $this->view->pagerHTML = $this->renderPager('',
                                                $page,
                                                ceil($searchResult['total'] / $pageSize), $func);
    }

    public function qrcodeAction()
    {
        $this->_helper->viewRenderer->setNoRender(true);
        $this->_helper->layout->disableLayout();

        $goodsId =  $this->_request->getParam('goodsid');
        $productId = $this->_request->getParam('productsid');
        $companyId = $this->_request->getParam('companyid');
        if(!$goodsId)
        {
            return;
        }
        $goods = GoodsService::getGoodsById($goodsId);
        $product = array();
        $products=ProductsService::listAllProductsByGoods($goodsId);
        if( $productId )
        {
            foreach( $products as $p)
            {
                if( $p['ProductsId'] == $productId )
                {
                    $product = $p;
                }
            }
        }
        $company = array();
        $companies = CompanyService::listAllByGoods($goodsId);
        if( $companyId)
        {
            foreach( $companies as $c)
            {
                if( $c['CompanyId'] == $companyId)
                {
                    $company = $c;
                }
            }
        }
        $value= "GoodsId:$goodsId\n";
        $value .= $goods['Name'];
        if($company)
        {
            $value .=" Company:".$company['Name'];
        }
        \PHPQRCode\QRcode::png($value);
    }

}
