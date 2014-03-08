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

use Welfony\Repository\ServiceRepository;

class ServiceService
{

    public static function save($data)
    {
        $result = array('success' => false, 'message' => '');

        if (empty($data['Title'])) {
            $result['message'] = '请填写服务名称。';

            return $result;
        }

        if (floatval($data['OldPrice']) <= 0 || floatval($data['Price']) <= 0) {
            $result['message'] = '请填写服务价格。';

            return $result;
        }

        if (floatval($data['Price']) > floatval($data['OldPrice'])) {
            $result['message'] = '请填写服务价格不可以大于原价。';

            return $result;
        }

        $serviceWithSameTitle = ServiceRepository::getInstance()->findServiceByTitleAndStaff($data['Title'], $data['UserId']);
        if ($serviceWithSameTitle && $serviceWithSameTitle['ServiceId'] != $data['ServiceId']) {
            $result['message'] = '同名服务已经存在。';

            return $result;
        }

        if ($data['ServiceId'] == 0) {
            $data['CreatedDate'] = date('Y-m-d H:i:s');

            $newId = ServiceRepository::getInstance()->save($data);
            if ($newId) {
                $data['ServiceId'] = $newId;

                $result['success'] = true;
                $result['service'] = $data;

                return $result;
            } else {
                $result['message'] = '添加服务失败！';

                return $result;
            }
        } else {
            $data['LastModifiedDate'] = date('Y-m-d H:i:s');

            $result['success'] = ServiceRepository::getInstance()->update($data['ServiceId'], $data);
            $result['message'] = $result['success'] ? '更新服务成功！' : '更新服务失败！';

            return $result;
        }
    }

    public static function listAllServices($page, $pageSize, $staffId)
    {
        $page = $page <= 0 ? 1 : $page;
        $pageSize = $pageSize <= 0 ? 20 : $pageSize;

        $total = ServiceRepository::getInstance()->getAllServicesCount($staffId);
        $serviceList = ServiceRepository::getInstance()->getAllServices($page, $pageSize, $staffId);
        $services = array();
        foreach ($serviceList as $service) {
            $services[] = $service;
        }

        return array('total' => $total, 'services' => $services);
    }

    public static function getServiceById($serviceId)
    {
        $service = ServiceRepository::getInstance()->findServiceById($serviceId);

        return $service;
    }

}
