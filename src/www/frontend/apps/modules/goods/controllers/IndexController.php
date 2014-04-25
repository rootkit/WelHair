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

use Welfony\Controller\Base\AbstractFrontendController;
use Welfony\Service\GoodsService;

class Goods_IndexController extends AbstractFrontendController
{

    public function indexAction()
    {
    }

    public function contentAction()
    {
        $goodsId = intval($this->_request->getParam('goods_id'));
        if ($goodsId > 0) {
            $goods = GoodsService::getGoodsById($goodsId);
            $this->view->htmlContent = $goods['Content'];
        }
    }

}