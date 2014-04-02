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
use Welfony\Service\ModelService;
use Welfony\Service\SpecService;
use Welfony\Service\AttributeService;

class Goods_ModelController extends AbstractAdminController
{

    public function searchAction()
    {
        $this->view->pageTitle = '模型列表';

        $allspecs = SpecService::listAllSpec();

        $this->view->allspec = $allspecs;

        $pageSize = 10;
        $page =  intval($this->_request->getParam('page'));

        $page =  $page<=0? 1 : $page;

        $result = ModelService::listModel($page, $pageSize);

        $this->view->rows = $result['models'];

        $this->view->pagerHTML = $this->renderPager($this->view->baseUrl('/goods/model/search'),
                                                    $page,
                                                    ceil($result['total'] / $pageSize));
    }

    public function infoAction()
    {
        $this->view->pageTitle = '添加模型';

        $modelId = $this->_request->getParam('model_id')?  intval($this->_request->getParam('model_id')) : 0;

        $model = array(
            'ModelId' => $modelId,
            'SpecIds' => '',
            'Name' => '',
            'IsDeleted' => 0
        );

        if ($this->_request->isPost()) {
            $this->_helper->viewRenderer->setNoRender(true);
            $this->_helper->layout->disableLayout();
            $model['Name']= htmlspecialchars($this->_request->getParam('name'));
            $model['SpecIds']= $this->_request->getParam('specids');
            $model['IsDeleted']= '0';

            $attributes = array();
            if ( $this->_request->getParam('attributes')) {
                foreach ( $this->_request->getParam('attributes') as $attr ) {
                    $attributes[]= array(
                            "Name" => $attr['name'],
                            "Type" => $attr['type'],
                            "Search" => $attr['search'],
                            "Value" => $attr["value"]
                        );
                }
            }

            $result = ModelService::save($model, $attributes);
            if ($result['success']) {
                $result['message'] = '保存模型成功！';
            }
            $this->_helper->json->sendJson($result);
        } else {

            if ($modelId > 0) {
                $this->view->specs = SpecService::listAllSpecByModel($modelId);
                $this->view->attributes = AttributeService::listAllAttributeByModel($modelId);
                $model = ModelService::getModelById($modelId);
                if (!$model) {
                    // process not exist logic;
                }
            }
        }

        $this->view->modelInfo = $model;
    }

    public function deleteAction()
    {
        $this->_helper->viewRenderer->setNoRender(true);
        $this->_helper->layout->disableLayout();

        $modelId =  intval($this->_request->getParam('modelid')) ;

        $model = array('ModelId' => $modelId);

        if ($this->_request->isPost()) {

            $result = ModelService::deleteModel($model);
            $this->_helper->json->sendJson($result);
        }
    }

}
