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

namespace Welfony\Controller\API;

use Welfony\Controller\Base\AbstractAPIController;
use Welfony\Service\AddressService;
use Welfony\Service\AreaService;

class AddressController extends AbstractAPIController
{

    public function setToDefault($addressId)
    {
        $result = AddressService::setAddressToDefaultById($addressId);
        $this->sendResponse($result);
    }

    public function listByUser($userId)
    {
        $dataList = AddressService::listAllAddressesByUser($userId);
        $this->sendResponse($dataList);
    }

    public function create()
    {
        $reqData = $this->getDataFromRequestWithJsonFormat();
        $reqData['UserId'] = $this->currentContext['UserId'];

        if (isset($reqData['City']) && $reqData['City'] > 0) {
            $province = AreaService::findParentAreaByChild($reqData['City']);
            $reqData['Province'] = $province['AreaId'];
        } else {
            $reqData['Province'] = 0;
        }
        $reqData['District'] = 0;

        $result = AddressService::save($reqData);
        $this->sendResponse($result);
    }

    public function update($addressId)
    {
        $reqData = $this->getDataFromRequestWithJsonFormat();

        $result = AddressService::update($addressId, $reqData);
        $this->sendResponse($result);
    }

    public function remove($addressId)
    {
        $result = array('success' => false, 'message' => '');
        $result['success'] = AddressService::remove($addressId);
        $this->sendResponse($result);
    }

}
