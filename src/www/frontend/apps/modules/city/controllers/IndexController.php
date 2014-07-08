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
use Welfony\Service\AreaService;

class City_IndexController extends AbstractFrontendController
{

    public function indexAction()
    {
        $cityList = array();

        $areaList = AreaService::listAllAreas();
        foreach ($areaList as $privince) {
            if (isset($privince['Child'])) {
                foreach ($privince['Child'] as $city) {
                    if (strpos($city['Name'], '自治州') > 0) {
                        continue;
                    }

                    $char = substr($city['FirstChar'], 0, 1);
                    $cityList[$char][] = array(
                        'ProvinceId' => $privince['AreaId'],
                        'CityId' => $city['AreaId'],
                        'Name' => str_replace('市', '', $city['Name'])
                    );
                }
            }
        }

        ksort($cityList);
        $this->view->areaList = $cityList;

        if ($this->_request->isPost()) {
            $userContext = new \Zend_Session_Namespace(self::SESSION_KEY_USER_CONTEXT);

            $provinceId = intval($this->_request->getParam('province'));
            $cityId = intval($this->_request->getParam('city'));

            $province = AreaService::getAreaById($provinceId);
            if ($province) {
                $userContext->area['Province'] = $province;
            }
            $city = AreaService::getAreaById($cityId);
            if ($city) {
                $userContext->area['City'] = $city;
            }

            $this->_redirect($this->view->baseUrl(''));
        }

        $this->view->provinceList = AreaService::listAreaByParent(0);
        $this->view->cityList = $this->userContext->area['Province']['AreaId'] > 0 ? AreaService::listAreaByParent($this->userContext->area['Province']['AreaId']) : array();
    }

    public function selectAction()
    {
        $this->_helper->viewRenderer->setNoRender(true);
        $this->_helper->layout->disableLayout();

        $userContext = new \Zend_Session_Namespace(self::SESSION_KEY_USER_CONTEXT);

        $provinceId = intval($this->_request->getParam('province'));
        $cityId = intval($this->_request->getParam('city'));

        $province = AreaService::getAreaById($provinceId);
        if ($province) {
            $userContext->area['Province'] = $province;
        }
        $city = AreaService::getAreaById($cityId);
        if ($city) {
            $userContext->area['City'] = $city;
        }

        $this->_redirect($this->view->baseUrl(''));
    }

}