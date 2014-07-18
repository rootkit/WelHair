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

use Alipay\AlipayNotify;
use Welfony\Controller\Base\AbstractFrontendController;

class Payment_AlipayController extends AbstractFrontendController
{

    private $alipayConfig;

    public function init()
    {
        parent::init();
    }

    public function notifyAction()
    {
        $this->_helper->viewRenderer->setNoRender(true);
        $this->_helper->layout->disableLayout();

        $this->prepareConfig();

        $alipayNotify = new AlipayNotify($this->alipayConfig);

        $verifyResult = $alipayNotify->verifyReturn();
        if ($verifyResult) {
            $depositNo = $this->_request->getParam('out_trade_no');
            $alipayTradeNo = $this->_request->getParam('trade_no');
            $alipayTradeStatus = $this->_request->getParam('trade_status');

            if ($alipayTradeStatus == 'TRADE_FINISHED' || $alipayTradeStatus == 'TRADE_SUCCESS') {
            } else {
                echo "trade_status=" . $alipayTradeStatus;
            }
        } else {
            echo '失败了';
        }
    }

    public function returnAction()
    {
        $this->_helper->viewRenderer->setNoRender(true);
        $this->_helper->layout->disableLayout();

        $this->prepareConfig();

        $alipayNotify = new AlipayNotify($this->alipayConfig);

        $verifyResult = $alipayNotify->verifyReturn();
        if ($verifyResult) {
            $depositNo = $this->_request->getParam('out_trade_no');
            $alipayTradeNo = $this->_request->getParam('trade_no');
            $alipayTradeStatus = $this->_request->getParam('trade_status');

            if ($alipayTradeStatus == 'TRADE_FINISHED' || $alipayTradeStatus == 'TRADE_SUCCESS') {
            } else {
                echo "trade_status=" . $alipayTradeStatus;
            }
        } else {
            echo '失败了';
        }
    }

    private function prepareConfig()
    {
        $this->alipayConfig = array();
        $this->alipayConfig['partner'] = $this->config->alipay->partner;
        $this->alipayConfig['key'] = $this->config->alipay->key;
        $this->alipayConfig['sign_type'] = strtoupper('MD5');
        $this->alipayConfig['input_charset']= strtolower('utf-8');
        $this->alipayConfig['cacert'] = $this->config->cert->path . '/alipay.pem';
        $this->alipayConfig['transport'] = 'http';
    }

}