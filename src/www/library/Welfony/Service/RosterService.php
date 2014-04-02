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

use Welfony\Core\Enum\RosterStatus;
use Welfony\Repository\RosterRepository;
use Welfony\Repository\UserRepository;

class RosterService
{

    public static function listAllRostersByUserId($userId, $status)
    {
        $rosterList = RosterRepository::getInstance()->getAllRostersByToId($userId, $status);

        return $rosterList;
    }

    public static function getRosterById($rosterId)
    {
        $roster = RosterRepository::getInstance()->findRosterById($rosterId);

        return $roster;
    }

    public static function save($data)
    {
        $result = array('success' => false, 'message' => '');

        $fromUser = UserRepository::getInstance()->findUserById($data['FromId']);
        if (!$fromUser) {
            $result['message'] = '发起者不存在！';

            return $result;
        }
        $toUser = UserRepository::getInstance()->findUserById($data['ToId']);
        if (!$fromUser) {
            $result['message'] = '接受者不存在！';

            return $result;
        }

        $existed = RosterRepository::getInstance()->findRosterByFromAndTo($data['FromId'], $data['ToId']);
        if ($existed) {
            $existed['Status'] = $data['Status'];
            $existed['LastModifiedDate'] = date('Y-m-d H:i:s');
            $result['success'] = RosterRepository::getInstance()->update($existed['RosterId'], $existed);

            if ($data['Status'] == RosterStatus::Accepted) {
                $existedToFrom = RosterRepository::getInstance()->findRosterByFromAndTo($data['ToId'], $data['FromId']);
                if (!$existedToFrom) {
                    $dataToFrom = array(
                        'FromId' => $data['ToId'],
                        'ToId' => $data['FromId'],
                        'Status' => RosterStatus::Accepted,
                        'CreatedDate' => date('Y-m-d H:i:s')
                    );
                    RosterRepository::getInstance()->save($dataToFrom);
                }
            }
        } else {
            $newId = RosterRepository::getInstance()->save($data);
            if ($newId) {
                $data['RosterId'] = $newId;

                $result['success'] = true;
                $result['roster'] = $data;
            } else {
                $result['message'] = '添加好友失败！';
            }
        }

        return $result;
    }

}
