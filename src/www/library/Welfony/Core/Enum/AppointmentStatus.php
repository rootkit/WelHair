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

class AppointmentStatus extends Enum
{

    const Pending = 0;
    const Paid = 1;
    const Completed = 2;
    const Refund = 3;
    const Cancelled = 4;

}
