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

class SocialRepository extends AbstractRepository
{

    public function getUserBySocial($externalId, $socialType)
    {
        $strSql = 'SELECT
                       U.*
                   FROM Social S
                   INNER JOIN Users U ON U.UserId = S.UserId
                   WHERE S.ExternalId = ? AND S.Type = ?
                   LIMIT 1';

        return $this->conn->fetchAssoc($strSql, array($externalId, $socialType));
    }

    public function save($data)
    {
        try {
            if ($this->conn->insert('Social', $data)) {
                return $this->conn->lastInsertId();
            }
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }

        return false;
    }

}
