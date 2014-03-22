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
use Welfony\Service\AreaService;

class AreaController extends AbstractAPIController
{

    public function listAll()
    {
        $areaList = AreaService::listAllAreas();
        $this->sendResponse($areaList);
    }

}
