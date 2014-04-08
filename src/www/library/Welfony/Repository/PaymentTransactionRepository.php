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

class PaymentTransactionRepository extends AbstractRepository
{

    public function findByExternalId($externalId)
    {
        $strSql = 'SELECT
                       PT.*
                   FROM PaymentTransaction PT
                   WHERE PT.ExternalId = ?
                   LIMIT 1';

        return $this->conn->fetchAssoc($strSql, array($externalId));
    }

    public function save($data)
    {
        try {
            if ($this->conn->insert('PaymentTransaction', $data)) {
                return $this->conn->lastInsertId();
            }
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }

        return false;
    }

    public function update($paymentTransactionId, $data)
    {
        try {
            return $this->conn->update('PaymentTransaction', $data, array('PaymentTransactionId' => $paymentTransactionId));
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }

}
