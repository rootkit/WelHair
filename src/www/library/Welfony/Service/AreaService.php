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

namespace Welfony\Service;

use Welfony\Repository\AreaRepository;

class AreaService
{

    public static function listAreaByParent($parentId)
    {
        $areaList = AreaRepository::getInstance()->getAreasByParent($parentId);
        return $areaList;
    }

}
