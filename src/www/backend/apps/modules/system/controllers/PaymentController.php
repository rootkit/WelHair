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
use Welfony\Service\PaymentService;

class System_PaymentController extends AbstractAdminController
{

    public function searchAction()
    {
        static $pageSize = 20;

        $this->view->pageTitle = '支付方式列表';
		
        $page =  intval($this->_request->getParam('page'));

        $page =  $page<=0? 1 : $page;

        $result = PaymentService::listPayment($page, $pageSize);

        $this->view->rows = $result['payments'];

        $this->view->pagerHTML = $this->renderPager($this->view->baseUrl('/sytem/payment/search'),
                                                    $page,
                                                    ceil($result['total'] / $pageSize));
												
    }

    public function infoAction()
    {
        $this->view->pageTitle = '支付方式详情';

		$paymentId = $this->_request->getParam('payment_id')?  intval($this->_request->getParam('payment_id')) : 0;
        if( ! $paymentId)
        {
            $this->_redirect('/system/payment/search');
            return;
        }

        $payment = PaymentService::getPaymentById($paymentId);

        if ($this->_request->isPost()) {
            $this->_helper->viewRenderer->setNoRender(true);
            $this->_helper->layout->disableLayout();
            $payment['Name']= htmlspecialchars($this->_request->getParam('name'));
            $payment['PoundageType']= $this->_request->getParam('poundagetype');     
            $payment['Poundage']= $this->_request->getParam('poundage');           
            $payment['Sort']= $this->_request->getParam('sort');
            $payment['Status']= $this->_request->getParam('status');
            $payment['Note']= htmlspecialchars($this->_request->getParam('note'));
            $payment['PartnerId']= $this->_request->getParam('partnerid');
            $payment['PartnerKey']= $this->_request->getParam('partnerkey');


           

            $result = PaymentService::save($payment);
            if ($result['success']) {
                $result['message'] = '保存支付方式成功！';
            }
            $this->_helper->json->sendJson($result);
        } 
        $this->view->paymentInfo = $payment;
    }

}
