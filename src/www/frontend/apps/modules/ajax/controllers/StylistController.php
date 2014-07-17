
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
use Welfony\Core\Enum\StaffStatus;
use Welfony\Service\StaffService;
use Welfony\Service\UserLikeService;

class Ajax_StylistController extends AbstractFrontendController
{

    public function likeAction()
    {
        $this->_helper->viewRenderer->setNoRender(true);
        $this->_helper->layout->disableLayout();

        $userLike = array(
            'CreatedBy' => $this->currentUser['UserId'],
            'UserId' => intval($this->_request->getParam('stylist_id')),
            'IsLike' => intval($this->_request->getParam('is_like'))
        );

        $this->_helper->json->sendJson(UserLikeService::save($userLike));
    }

    public function approveAction()
    {
        $this->_helper->viewRenderer->setNoRender(true);
        $this->_helper->layout->disableLayout();

        $staffDetail = StaffService::getStaffDetail($this->currentUser['UserId'], $this->currentUser['UserId'], $this->userContext->location);
        $companyId = $staffDetail['Company']['CompanyId'];

        $staffId = intval($this->_request->getParam('stylist_id'));
        $isApproved = intval($this->_request->getParam('is_approved'));

        $staff = StaffService::getStaffByCompanyAndUser($companyId, $staffId);

        $this->_helper->json->sendJson(array('success' => StaffService::saveCompanyStaffByCompanyUser($staff['CompanyUserId'], $isApproved == 1 ? StaffStatus::Valid : StaffStatus::Invalid)));

    }

}
