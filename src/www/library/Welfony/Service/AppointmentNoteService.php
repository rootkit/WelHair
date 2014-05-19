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

use Welfony\Repository\AppointmentNoteRepository;

class AppointmentNoteService
{

    public static function listAppointmentNote($appointmentId, $page, $pageSize)
    {
        $page = $page <= 0 ? 1 : $page;
        $pageSize = $pageSize <= 0 ? 20 : $pageSize;
        $result = array('');

        $total = AppointmentNoteRepository::getInstance()->getAllAppointmentNoteCount($appointmentId);

        $tempRst = AppointmentNoteRepository::getInstance()->getAllAppointmentNote($appointmentId, $page, $pageSize);
        $appointmentNotes = self::assembleAppointmentNoteList($tempRst);

        return array('total' => $total, 'appointmentNotes' => $appointmentNotes);
    }

    public static function save($data)
    {
        $result = array('success' => false, 'message' => '');

        $body = htmlspecialchars($data['Body']);

        $appointmentNote = array(
            'Body' => $body,
            'PictureUrl' => isset($data['PictureUrl']) && is_array($data['PictureUrl']) ? json_encode($data['PictureUrl']) : '[]',
            'CreatedDate' => date('Y-m-d H:i:s')
        );

        if (isset($data['AppointmentId'])) {
            $appointmentNote['AppointmentId'] = intval($data['AppointmentId']);
        }

        $newId = AppointmentNoteRepository::getInstance()->save($appointmentNote);
        if ($newId) {
            $appointmentNote['AppointmentNoteId'] = $newId;
            $appointmentNote['PictureUrl'] = json_decode($appointmentNote['PictureUrl'], true);

            $result['success'] = true;
            $result['appointmentNote'] = $appointmentNote;
        }

        return $result;
    }

    private static function assembleAppointmentNoteList($tempRst)
    {
        $appointmentNotes = array();
        foreach ($tempRst as $row) {
            $appointmentNote = array(
                'AppointmentNoteId' => $row['AppointmentNoteId'],
                'Body' => htmlspecialchars_decode($row['Body']),
                'PictureUrl' => json_decode($row['PictureUrl'], true),
                'CreatedDate' => $row['CreatedDate'],
                'Client' => array(
                    'UserId' => $row['UserId'],
                    'Username' => $row['Username'],
                    'Nickname' => $row['Nickname'],
                    'Email' => $row['Email'],
                    'AvatarUrl' => $row['AvatarUrl']
                )
            );

            $appointmentNotes[] = $appointmentNote;
        }

        return $appointmentNotes;
    }

}
