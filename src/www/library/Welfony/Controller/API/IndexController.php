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
use Welfony\Core\Enum\NotificationType;
class IndexController extends AbstractAPIController
{

    public function index()
    {
    	//\Welfony\Notification\Apple::send('3c945e41b76d3a853a54c8ac0ed34be12396ec7ca4410d26f42b7c65f078b1d5', array( 'type' => NotificationType::NotificationTypeStaffGetAppointment . '', 'alert' => '使用打扮吧'));
         // \Welfony\Notification\Apple::send('b5383bb452d332707501baeddd6c438a344e74bb000981438707a6177b0829c6', array('alert' => '欢迎使用打扮吧'));

        $this->sendResponse(array(
            'message' => sprintf('%s API service', $this->app->config->app->name)
        ));
    }

}
