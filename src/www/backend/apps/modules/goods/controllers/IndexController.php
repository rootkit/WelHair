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
use Welfony\Service\GoodsService;
use Welfony\Service\CategoryService;
use Welfony\Service\BrandService;
use Welfony\Service\ModelService;

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

        $goodsId = $this->_request->getParam('goods_id')?  intval($this->_request->getParam('goods_id')) : 0;

        $goods = array(
            'GoodsId' => $goodsId,
            'Name' => '',
            'IsDeleted' => 0,
            'Keywords' => '',
        );

        if ($this->_request->isPost()) {
            $goods['Name']= htmlspecialchars($this->_request->getParam('name'));

            $result = GoodsService::save($goods);
            if ($result['success']) {

                $this->view->successMessage = '保存商品成功！';
            } else {
                $this->view->errorMessage = $result['message'];
            }
        } else {

            if ($goodsId > 0) {
                $goods = GoodsService::getGoodsById($goodsId);
                $this->view->goodscategories=CategoryService::listAllCategoryByGoods($goodsId);
                if (!$goods) {
                    // process not exist logic;
                }
            }
        }

        $this->view->goodsInfo = $goods;
    }

}
