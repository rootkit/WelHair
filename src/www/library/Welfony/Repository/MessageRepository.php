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

class MessageRepository extends AbstractRepository
{

    public function save($data)
    {
        try {
            if ($this->conn->insert('Message', $data)) {
                return $this->conn->lastInsertId();
            }
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }

        return false;
    }

    public function update($messageId, $data)
    {
        try {
            return $this->conn->update('Message', $data, array('MessageId' => $messageId));
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }

    public function listMessagesCount($fromId, $toId)
    {
        $strSql = "SELECT
                     COUNT(1) `Total`
                   FROM Message M
                   WHERE (M.ToId = ? AND M.FromId = ?) OR (M.ToId = ? AND M.FromId = ?)
                   LIMIT 1";

        $row = $this->conn->fetchAssoc($strSql, array($toId, $fromId, $fromId, $toId));

        return $row['Total'];
    }

    public function listMessages($fromId, $toId, $page, $pageSize)
    {
        $offset = ($page - 1) * $pageSize;

        $strSql = "SELECT * FROM (
                   SELECT
                     M.MessageId,
                     M.Body,
                     M.CreatedDate,
                     M.MediaType,
                     M.MediaUrl,

                     FU.UserId FromUserId,
                     FU.Username FromUsername,
                     FU.Nickname FromNickname,
                     FU.AvatarUrl FromAvatarUrl,

                     TU.UserId ToUserId,
                     TU.Username ToUsername,
                     TU.Nickname ToNickname,
                     TU.AvatarUrl ToAvatarUrl
                   FROM Message M
                   INNER JOIN Users FU ON FU.UserId = M.FromId
                   INNER JOIN Users TU ON TU.UserId = M.ToId
                   WHERE (M.ToId = ? AND M.FromId = ?) OR (M.ToId = ? AND M.FromId = ?)
                   ORDER BY MessageId DESC
                   LIMIT $offset, $pageSize
                   ) TBL
                   ORDER BY TBL.MessageId DESC";

        return $this->conn->fetchAll($strSql, array($toId, $fromId, $fromId, $toId));
    }

}
