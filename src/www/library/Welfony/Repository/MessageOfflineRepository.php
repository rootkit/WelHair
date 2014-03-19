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

namespace Welfony\Repository;

use Welfony\Repository\Base\AbstractRepository;

class MessageOfflineRepository extends AbstractRepository
{

    public function getAllOfflineMessagesByUser($userId)
    {
        $strSql = "SELECT
                       M.*,
                       MO.MessageOfflineId
                   FROM MessageOffline MO
                   INNER JOIN Message M ON M.MessageId = MO.MessageId
                   WHERE MO.UserId = ?
                   ORDER BY M.MessageId DESC";

        return $this->conn->fetchAll($strSql, array($userId));
    }

    public function save($data)
    {
        try {
            if ($this->conn->insert('MessageOffline', $data)) {
                return $this->conn->lastInsertId();
            }
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }

        return false;
    }

    public function remove($id)
    {
        $this->conn->delete('MessageOffline', array('MessageOfflineId' => $id));
    }

}
