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

class UserLikeRepository extends AbstractRepository
{

    public function findByUserAndWorkId($createdBy, $workId)
    {
        $strSql = 'SELECT
                       *
                   FROM UserLike UL
                   WHERE UL.CreatedBy = ? AND UL.WorkId = ?
                   LIMIT 1';

        return $this->conn->fetchAssoc($strSql, array($createdBy, $workId));
    }

    public function findByUserAndUserId($createdBy, $userId)
    {
        $strSql = 'SELECT
                       *
                   FROM UserLike UL
                   WHERE UL.CreatedBy = ? AND UL.UserId = ?
                   LIMIT 1';

        return $this->conn->fetchAssoc($strSql, array($createdBy, $userId));
    }

    public function findByUserAndGoodsId($createdBy, $goodsId)
    {
        $strSql = 'SELECT
                       *
                   FROM UserLike UL
                   WHERE UL.CreatedBy = ? AND UL.GoodsId = ?
                   LIMIT 1';

        return $this->conn->fetchAssoc($strSql, array($createdBy, $goodsId));
    }

    public function removeByUserAndWorkId($createdBy, $workId)
    {
        try {
            $this->conn->delete('UserLike', array('CreatedBy' => $createdBy, 'WorkId' => $workId));

            return true;
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }

    public function removeByUserAndUserId($createdBy, $userId)
    {
        try {
            $this->conn->delete('UserLike', array('CreatedBy' => $createdBy, 'UserId' => $userId));

            return true;
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }

    public function removeByUserAndGoodsId($createdBy, $goodsId)
    {
        try {
            $this->conn->delete('UserLike', array('CreatedBy' => $createdBy, 'GoodsId' => $goodsId));

            return true;
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }

    public function save($data)
    {
        try {
            if ($this->conn->insert('UserLike', $data)) {
                return $this->conn->lastInsertId();
            }
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }

        return false;
    }

    public function update($userLikeId, $data)
    {
        try {
            return $this->conn->update('UserLike', $data, array('UserLikeId' => $userLikeId));
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }

}
