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
use Welfony\Service\FreightService;

class System_FreightController extends AbstractAdminController
{

    public function searchAction()
    {
        static $pageSize = 10;

        $this->view->pageTitle = '物流公司';
		
        $page =  intval($this->_request->getParam('page'));

        $page =  $page<=0? 1 : $page;

        $result = FreightService::listFreight($page, $pageSize);

        $this->view->rows = $result['freights'];

        $this->view->pagerHTML = $this->renderPager($this->view->baseUrl('/sytem/freight/search'),
                                                    $page,
                                                    ceil($result['total'] / $pageSize));
    }

    public function infoAction()
    {
        $this->view->pageTitle = '添加物流公司';
		
		$freightId = $this->_request->getParam('freight_id')?  intval($this->_request->getParam('freight_id')) : 0;

        $freight = array(
            'FreightId' => $freightId,
            'FreightType' => '',
            'FreightName' => '',
            'Url' => '',
            'Sort'=>'',
            'IsDeleted' => 0
        );

        if ($this->_request->isPost()) {
            $this->_helper->viewRenderer->setNoRender(true);
            $this->_helper->layout->disableLayout();
            $freight['FreightName']= htmlspecialchars($this->_request->getParam('freightname'));
            $freight['FreightType']= $this->_request->getParam('freighttype');            
            $freight['Url']= $this->_request->getParam('url');
            $freight['Sort']= $this->_request->getParam('sort');
            $freight['IsDeleted']= '0';

           

            $result = FreightService::save($freight);
            if ($result['success']) {
                $result['message'] = '保存物流公司成功！';
            }
            $this->_helper->json->sendJson($result);
        } else {

            if ($freightId > 0) {
                $freight = FreightService::getFreightById($freightId);
                if (!$freight) {
                    // process not exist logic;
                }
            }
        }

        $this->view->freightInfo = $freight;
    }

    public function deleteAction()
    {
        $this->_helper->viewRenderer->setNoRender(true);
        $this->_helper->layout->disableLayout();

        $freightId =  intval($this->_request->getParam('freightid')) ;

        $freight = array('FreightId' => $freightId);

        if ($this->_request->isPost()) {

            $result = FreightService::deleteFreight($freight);
            $this->_helper->json->sendJson($result);
        }
    }


}
