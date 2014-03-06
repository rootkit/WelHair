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
use Welfony\Service\CompanyService;

class Ajax_CompanyController extends AbstractAdminController
{

    public function searchAction()
    {
        $searchText = htmlspecialchars($this->_request->getParam('search'));
        $response = array();

        $companyList = CompanyService::seachByNameAndPhone($searchText);
        foreach ($companyList as $company) {
            $response[] = array(
                'value' => $company['CompanyId'],
                'title' => $company['Name'],
                'detail' => $company['ProvinceName'] . ' - ' . $company['CityName'] . ' - ' . $company['DistrictName'],
                'icon' => count($company['PictureUrl']) > 0 ? $company['PictureUrl'][0] : ''
            );
        }
        $this->_helper->json->sendJson($response);
    }

}
