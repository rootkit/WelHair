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

namespace Welfony\Core\Enum;

use Welfony\Core\Enum;

class UserPointType extends Enum
{

    const Unknown = 0;

    const NewRegister = 1;

    const AppointmentClient = 2;
    const AppointmentStaff = 3;
    const AppointmentReferral = 4;

    const WorkLiked = 5;
    const WorkShared = 6;

}
