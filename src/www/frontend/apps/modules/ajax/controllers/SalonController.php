
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
use Welfony\Service\CompanyService;
use Welfony\Service\StaffService;
use Welfony\Service\UserLikeService;

class Ajax_SalonController extends AbstractFrontendController
{

    public function likeAction()
    {
        $this->_helper->viewRenderer->setNoRender(true);
        $this->_helper->layout->disableLayout();

        $userLike = array(
            'CreatedBy' => $this->currentUser['UserId'],
            'CompanyId' => intval($this->_request->getParam('salon_id')),
            'IsLike' => intval($this->_request->getParam('is_like'))
        );

        $this->_helper->json->sendJson(UserLikeService::save($userLike));
    }

    public function joinAction()
    {
        $this->_helper->viewRenderer->setNoRender(true);
        $this->_helper->layout->disableLayout();

        $companyId = intval($this->_request->getParam('salon_id'));

        $result = array('success' => false, 'message' => '');
        $staff = StaffService::getStaffDetail($this->currentUser['UserId']);
        if ($staff && $staff['Company']) {
            if ($staff['Status'] == StaffStatus::Requested) {
                $result['message'] = '您的请求正在审核中，请耐心等待。';
            } else if ($staff['Status'] == StaffStatus::Invalid) {
                $saveRst = StaffService::saveCompanyStaff($this->currentUser['UserId'], $companyId, StaffStatus::Requested);
                if (!$saveRst) {
                    $result['message'] = '操作失败请重试。';
                } else {
                    $result['success'] = true;
                    $result['message'] = '您的请求正在审核中，请耐心等待。';
                }
            } else {
                $result['message'] = '您已经在一个沙龙中了。';
            }
        } else {
            $saveRst = StaffService::saveCompanyStaff($this->currentUser['UserId'], $companyId, StaffStatus::Requested);
            if (!$saveRst) {
                $result['message'] = '操作失败请重试。';
            } else {
                $result['success'] = true;
                $result['message'] = '您的请求正在审核中，请耐心等待。';
            }
        }

        $this->_helper->json->sendJson($result);
    }

}
