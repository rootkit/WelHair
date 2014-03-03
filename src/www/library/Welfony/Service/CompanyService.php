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

use Welfony\Repository\CompanyRepository;

class CompanyService
{

    public static function save($data)
    {
        $result = array('success' => false, 'message' => '');

        if (empty($data['Name']))) {
            $result['message'] = '请填写沙龙名称。';

            return $result;
        }

        if (empty($data['Tel']) && empty($data['Mobile'])) {
            $result['message'] = '联系电话和手机至少填写一项。';

            return $result;
        }

        if (intval($data['Province']) <=0 || intval($data['City']) <=0 || intval($data['Pistrict']) <=0) {
            $result['message'] = '地区选择不全。';

            return $result;
        }
    }

}
