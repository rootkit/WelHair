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

class MessageConversationRepository extends AbstractRepository
{

    public function listByTo($toId)
    {
        $strSql = "SELECT
                       U.UserId,
                       U.Username,
                       U.Nickname,
                       U.AvatarUrl,

                       MC.NewMessageCount,

                       CASE
                       WHEN M.MediaType = 1 THEN M.Body
                       WHEN M.MediaType = 2 THEN '图片'
                       WHEN M.MediaType = 3 THEN '语音'
                       ELSE ''
                       END NewMessageSummary,

                       CASE
                       WHEN M.MessageId > 0 THEN M.CreatedDate
                       ELSE ''
                       END NewMessageDate
                   FROM MessageConversation MC
                   INNER JOIN Users U ON U.UserId = MC.FromId
                   LEFT OUTER JOIN Message M ON M.MessageId = MC.LastMessageId
                   WHERE MC.ToId = ?
                   ORDER BY MC.LastMessageId DESC";

        return $this->conn->fetchAll($strSql, array($toId));
    }

    public function getByFromAndTo($fromId, $toId)
    {
        $strSql = "SELECT
                       MC.*
                   FROM MessageConversation MC
                   WHERE MC.FromId = ? AND MC.ToId = ?
                   ORDER BY MC.LastMessageId DESC";

        return $this->conn->fetchAssoc($strSql, array($fromId, $toId));
    }

    public function save($data)
    {
        try {
            if ($this->conn->insert('MessageConversation', $data)) {
                return $this->conn->lastInsertId();
            }
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }

        return false;
    }

    public function updateByFromAndTo($fromId, $toId, $data)
    {
        try {
            return $this->conn->update('MessageConversation', $data, array('FromId' => $fromId, 'ToId' => $toId));
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }

    public function remove($id)
    {
        $this->conn->delete('MessageConversation', array('MessageConversation' => $id));
    }

}
