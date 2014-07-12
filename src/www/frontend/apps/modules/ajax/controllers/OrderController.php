
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
use Welfony\Service\AddressService;
use Welfony\Service\GoodsService;
use Welfony\Service\OrderService;

class Ajax_OrderController extends AbstractFrontendController
{

    public function indexAction()
    {
        $this->_helper->viewRenderer->setNoRender(true);
        $this->_helper->layout->disableLayout();

        $reqData = array();
        $reqData['OrderId'] = 0;
        $reqData['UserId'] = $this->currentUser['UserId'];
        $reqData['PayType'] = 1;
        $reqData['Distribution'] = 1;
        $reqData['AddressId'] = intval($this->_request->getParam('address_id'));
        $reqData['Items'] = array(array(
            'GoodsId' => intval($this->_request->getParam('goods_id')),
            'CompanyId' => intval($this->_request->getParam('company_id')),
            'ProductId' => intval($this->_request->getParam('product_id')),
            'Num' => intval($this->_request->getParam('goods_count'))
        ));

        $this->_helper->json->sendJson(OrderService::create($reqData));
    }

    public function formAction()
    {
        $goodsId = intval($this->_request->getParam('goods_id'));
        $companyId = intval($this->_request->getParam('company_id'));
        $this->view->goodsDetail = GoodsService::getGoodsDetail($goodsId, $companyId, $this->currentUser['UserId'], $this->userContext->location);

        $rstAddressList = AddressService::listAllAddressesByUser($this->currentUser['UserId']);
        $this->view->addressList = $rstAddressList['addresses'];

        $ajaxContext = $this->_helper->getHelper('AjaxContext');
        $ajaxContext->addActionContext('form', 'html')
            ->initContext();
    }

}
