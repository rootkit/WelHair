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

use Welfony\Repository\AddressRepository;

class AddressService
{

    public static function save($data)
    {
        $result = array('success' => false, 'message' => '');

        if (!isset($data['UserId']) || intval($data['UserId']) <= 0) {
            $result['message'] = '用户信息遗漏。';

            return $result;
        }

        if (empty($data['ShippingName'])) {
            $result['message'] = '请填写收件人。';

            return $result;
        }

        if (empty($data['Mobile'])) {
            $result['message'] = '请填写手机。';

            return $result;
        }

        if (intval($data['Province']) <= 0 || intval($data['City']) <= 0) {
            $result['message'] = '地区选择不全。';

            return $result;
        }

        if (empty($data['Address'])) {
            $result['message'] = '请填写地址。';

            return $result;
        }

        $data = array(
            'AddressId' => isset($data['AddressId']) ? $data['AddressId'] : 0,
            'UserId' => intval($data['UserId']),
            'Province' => intval($data['Province']),
            'Mobile' => htmlspecialchars($data['Mobile']),
            'Address' => htmlspecialchars($data['Address']),
            'ShippingName' => htmlspecialchars($data['ShippingName']),
            'City' => intval($data['City']),
            'District' => isset($data['District']) ? intval($data['District']) : 0,
            'IsDefault' => isset($data['IsDefault']) ? intval($data['IsDefault']) : 0
        );

        if ($data['AddressId'] == 0) {
            $data['CreatedDate'] = date('Y-m-d H:i:s');

            $newId = AddressRepository::getInstance()->save($data);
            if ($newId) {
                $data['AddressId'] = $newId;

                $result['success'] = true;
                $result['address'] = $data;

                return $result;
            } else {
                $result['message'] = '添加地址失败！';

                return $result;
            }
        } else {
            $data['LastModifiedDate'] = date('Y-m-d H:i:s');

            $result['success'] = AddressRepository::getInstance()->update($data['AddressId'], $data);
            $result['message'] = $result['success'] ? '更新地址成功！' : '更新地址失败！';

            return $result;
        }
    }

    public static function update($appointmentId, $data)
    {
        $result = array('success' => false, 'message' => '');

        $data['LastModifiedDate'] = date('Y-m-d H:i:s');

        $result['success'] = AddressRepository::getInstance()->update($appointmentId, $data);
        $result['message'] = $result['success'] ? '更新地址成功！' : '更新地址失败！';

        return $result;

    }

    public static function listAllAddressesByUser($userId)
    {
        $addressList = AddressRepository::getInstance()->getAllAddressesByUser($userId);

        return array('total' => count($addressList), 'addresses' => $addressList);
    }

    public static function getAddressById($id)
    {
        return AddressRepository::getInstance()->findAddressById($id);
    }

    public static function remove($id)
    {
        return AddressRepository::getInstance()->remove($id);
    }

    public static function setAddressToDefaultById($addressId)
    {
        $result = array('success' => false, 'message' => '');

        $address = AddressRepository::getInstance()->findAddressById($addressId);
        AddressRepository::getInstance()->updateAddressByUser($address['UserId'], array('IsDefault' => 0));

        $result['success'] = AddressRepository::getInstance()->update($addressId, array('IsDefault' => 1));
        $result['message'] = $result['success'] ? '更新地址成功！' : '更新地址失败！';

        return $result;
    }

}
