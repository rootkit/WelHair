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
use Welfony\Service\SpecService;

class Goods_SpecController extends AbstractAdminController
{

    public function searchAction()
    {
        $this->view->pageTitle = '规格列表';

        $pageSize = 10;
        $page =  intval($this->_request->getParam('page'));

        $page =  $page<=0? 1 : $page;

        $result = SpecService::listSpec($page, $pageSize);

        $this->view->rows = $result['specs'];

        $this->view->pagerHTML =  $this->renderPager($this->view->baseUrl('/goods/spec/search?'),
                                                     $page,
                                                     ceil($result['total'] / $pageSize));
    }

    public function infoAction()
    {
    	
        
        $this->view->pageTitle = '添加规格';


        $specId = $this->_request->getParam('spec_id')?  intval($this->_request->getParam('spec_id')) : 0;


        $spec = array(
            'SpecId' => $specId,
            'Name' => '',
            'Value' => '',
            'Type' => '',
            'Note' => '',
            'IsDeleted' => 0
        );


        if ($this->_request->isPost()) {
            $spec['Name']= htmlspecialchars($this->_request->getParam('name'));
            $spec['Value']= $this->_request->getParam('value');
            $spec['Type']= '1';
            $spec['Note']= htmlspecialchars($this->_request->getParam('note'));        


            $result = SpecService::save($spec);
            if ($result['success']) {

            
                $this->view->successMessage = '保存规格成功！';
            } else {
                $this->view->errorMessage = $result['message'];
            }
        } else {

            
            if ($specId > 0) {
                $spec = SpecService::getSpecById($specId);
                if (!$spec) {
                    // process not exist logic;
                }
            }
        }

        $this->view->specInfo = $spec;
    }


    public function deleteAction()
    {
        $this->_helper->viewRenderer->setNoRender(true);
        $this->_helper->layout->disableLayout();

        $specId =  intval($this->_request->getParam('specid')) ;

        $spec = array('SpecId' => $specId);

        if ($this->_request->isPost()) {
           

            $result = SpecService::deleteSpec($spec);
            $this->_helper->json->sendJson($result);
        } 
    }

    public function selectAction()
    {
        //$this->_helper->viewRenderer->setNoRender(true);
        $this->_helper->layout->disableLayout();

        static $pageSize = 10;


        $page = intval($this->_request->getParam('page'));
        $func = intval($this->_request->getParam('func'));
        $searchResult = SpecService::listSpec($page, $pageSize);

        $this->view->dataList = $searchResult['specs'];
        $this->view->pager = $this->renderPager('',
                                                $page,
                                                ceil($searchResult['total'] / $pageSize), $func);
    }


}