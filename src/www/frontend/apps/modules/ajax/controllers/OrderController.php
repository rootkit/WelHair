
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

class Ajax_OrderController extends AbstractFrontendController
{

    public function formAction()
    {
        $goodsId = intval($this->_request->getParam('goods_id'));
        $companyId = intval($this->_request->getParam('company_id'));
        $this->view->goodsDetail = GoodsService::getGoodsDetail($goodsId, $companyId, $this->currentUser['UserId'], $this->userContext->location);

        $ajaxContext = $this->_helper->getHelper('AjaxContext');
        $ajaxContext->addActionContext('form', 'html')
            ->initContext();
    }

}
