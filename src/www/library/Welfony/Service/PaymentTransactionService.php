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

use Welfony\Core\Enum\AppointmentStatus;
use Welfony\Core\Enum\PaymentTransactionStatus;
use Welfony\Repository\AppointmentRepository;
use Welfony\Repository\CompanyRepository;
use Welfony\Repository\PaymentTransactionRepository;

class PaymentTransactionService
{

    public static function save($data)
    {
        $result = array('success' => false, 'message' => '');

        if (!isset($data['PaymentSystem']) || intval($data['PaymentSystem']) <= 0) {
            $result['message'] = '支付方式不合法。';

            return $result;
        }

        if (!isset($data['ExternalId']) || empty($data['ExternalId'])) {
            $result['message'] = '交易ID不合法。';

            return $result;
        }

        if (!isset($data['Amount']) || floatval($data['Amount']) <= 0) {
            $result['message'] = '支付金额不合法。';

            return $result;
        }

        if (!isset($data['Fee']) || floatval($data['Fee']) <= 0) {
            $result['message'] = '支付费用不合法。';

            return $result;
        }

        if (!isset($data['Status']) || intval($data['Status']) <= 0) {
            $result['message'] = '支付状态不合法。';

            return $result;
        }

        $existedPaymentTransaction = PaymentTransactionRepository::getInstance()->findByExternalId($data['ExternalId']);
        if ($existedPaymentTransaction) {
            $data['PaymentTransactionId'] = $existedPaymentTransaction['PaymentTransactionId'];
        }

        $appointmentId = null;
        if (isset($data['AppointmentId'])) {
            $appointmentId = intval($data['AppointmentId']);
            unset($data['AppointmentId']);
        }

        if ($data['PaymentTransactionId'] == 0) {
            $data['CreatedDate'] = date('Y-m-d H:i:s');

            $newId = PaymentTransactionRepository::getInstance()->save($data);
            if ($newId) {
                $data['PaymentTransactionId'] = $newId;

                $result['success'] = true;
                $result['transaction'] = $data;
            } else {
                $result['message'] = '添加交易失败！';
            }
        } else {
            $data['LastModifiedDate'] = date('Y-m-d H:i:s');

            $result['success'] = PaymentTransactionRepository::getInstance()->update($data['PaymentTransactionId'], $data);
            $result['message'] = $result['success'] ? '更新交易成功！' : '更新交易失败！';
        }

        if ($appointmentId > 0 && $data['Status'] == PaymentTransactionStatus::Completed) {
            $appointmentInfo = AppointmentRepository::getInstance()->findAppointmentById($appointmentId);
            if ($appointmentInfo['PaymentTransactionId'] <= 0) {
                $appointmentData = array(
                    'AppointmentId' => $appointmentId,
                    'Status' => AppointmentStatus::Paid,
                    'PaymentTransactionId' => $data['PaymentTransactionId'],
                    'LastModifiedDate' => date('Y-m-d H:i:s')
                );
                AppointmentRepository::getInstance()->update($appointmentId, $appointmentData);

                if ($appointmentInfo) {
                    $companyInfo = CompanyRepository::getInstance()->findCompanyById($appointmentInfo['CompanyId']);
                    $companyData = array(
                        'CompanyId' => $appointmentInfo['CompanyId'],
                        'Amount' => $companyInfo['Amount'] + (floatval($data['Amount']) - floatval($data['Fee'])) * 0.9,
                        'LastModifiedDate' => date('Y-m-d H:i:s')
                    );

                    CompanyRepository::getInstance()->update($companyData['CompanyId'], $companyData);
                }
            }
        }

        return $result;
    }

}
