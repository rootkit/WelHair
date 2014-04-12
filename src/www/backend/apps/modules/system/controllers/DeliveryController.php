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
use Welfony\Service\DeliveryService;
use Welfony\Service\FreightService;

class System_DeliveryController extends AbstractAdminController
{

    public function searchAction()
    {
        static $pageSize = 10;

        $this->view->pageTitle = '配送方式';
		
        $page =  intval($this->_request->getParam('page'));

        $page =  $page<=0? 1 : $page;

        $result = DeliveryService::listDelivery($page, $pageSize);

        $this->view->rows = $result['deliveries'];

        $this->view->pagerHTML = $this->renderPager($this->view->baseUrl('/sytem/delivery/search'),
                                                    $page,
                                                    ceil($result['total'] / $pageSize));
    }

    public function infoAction()
    {
        $this->view->pageTitle = '添加配送方式';

        $this->view->freights = FreightService::listAllFreight();


		$deliveryId = $this->_request->getParam('delivery_id')?  intval($this->_request->getParam('delivery_id')) : 0;

        $delivery = array(
            'DeliveryId' => $deliveryId,
            'Name' => '',
            'Description' => '',
            'AreaGroupId' => '',
            'AreaFirstPrice'=>'',
            'AreaSecondPrice'=>'',
            'Type'=>0,
            'FirstWeight'=>1000,
            'SecondWeight'=>1000,
            'FirstPrice'=>0,
            'SecondPrice'=>0,
            'Status' =>1,
            'Sort'=>'99',
            'IsSavePrice'=>0,
            'SaveRate'=>0,
            'LowPrice'=>0,
            'PriceType'=>0,
            'OpenDefault'=>'1',
            'FreightId'=>'0',
            'IsDeleted' => 0
        );

        if ($this->_request->isPost()) {
            $this->_helper->viewRenderer->setNoRender(true);
            $this->_helper->layout->disableLayout();
            $delivery['Name']= htmlspecialchars($this->_request->getParam('name'));
            $delivery['FreightId']= $this->_request->getParam('freightid');            
            $delivery['Description']= htmlspecialchars($this->_request->getParam('description'));
            
            $delivery['AreaGroupId']= $this->_request->getParam('areagroupid');
            $delivery['AreaFirstPrice']= $this->_request->getParam('areafirstprice');
            $delivery['AreaSecondPrice']= $this->_request->getParam('areasecondprice');

            $delivery['Type']= $this->_request->getParam('type');
            $delivery['FirstWeight']= $this->_request->getParam('firstweight');
            $delivery['SecondWeight']= $this->_request->getParam('secondweight');

            $delivery['FirstPrice']= $this->_request->getParam('firstprice');
            $delivery['SecondPrice']= $this->_request->getParam('secondprice');


            $delivery['Status']= $this->_request->getParam('status');
            $delivery['Sort']= $this->_request->getParam('sort');
            $delivery['IsDeleted']= '0';

           

            $result = DeliveryService::save($delivery);
            if ($result['success']) {
                $result['message'] = '保存配送方式成功！';
            }
            $this->_helper->json->sendJson($result);
        } else {

            if ($deliveryId > 0) {
                $delivery = DeliveryService::getDeliveryById($deliveryId);
                if (!$delivery) {
                    // process not exist logic;
                }
            }
        }

        $this->view->deliveryInfo = $delivery;
    }


    public function deleteAction()
    {
        $this->_helper->viewRenderer->setNoRender(true);
        $this->_helper->layout->disableLayout();

        $deliveryId =  intval($this->_request->getParam('deliveryid')) ;

        $delivery = array('DeliveryId' => $deliveryId);

        if ($this->_request->isPost()) {

            $result = DeliveryService::deleteDelivery($deliveryId);
            $this->_helper->json->sendJson($result);
        }
    }

}
