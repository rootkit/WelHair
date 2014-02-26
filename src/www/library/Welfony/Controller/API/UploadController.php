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

namespace Welfony\Controller\API;

use Imagine\Gd\Imagine;
use Imagine\Image\Box;
use Imagine\Image\Point;
use Symfony\Component\Filesystem\Filesystem;
use Symfony\Component\Filesystem\Exception\IOExceptionInterface;
use Welfony\Controller\Base\AbstractAPIController;
use Welfony\Utility\Validation;

class UploadController extends AbstractAPIController
{

    public function image()
    {
        $fileInputName = 'uploadfile';

        if (empty($_FILES) || !isset($_FILES[$fileInputName])) {
            self::sendResponse(array('success' => false, 'message' => 'No file found!'));
        }

        $file = $_FILES[$fileInputName];
        if ($file['error'] > 0) {
            self::sendResponse(array('success' => false, 'message' => $file['error']));
        }

        if (!Validation::isValidImage($file)) {
            self::sendResponse(array('success' => false, 'message' => 'File type is invalid!'));
        }

        $temp = explode('.', $file['name']);

        $targetFolder = implode(DS, array($this->app->config->file->media->path, date('Y'), date('m'), date('d')));
        $fs = new Filesystem();
        try {
            $fs->mkdir($targetFolder);
        } catch (IOExceptionInterface $e) {
            // $this->app->log->getWriter()->write('An error occurred while creating your directory at '. $e->getPath(), \Slim\Log::ERROR);
        }

        if (!$fs->exists($targetFolder)) {
            $this->sendOperationFailedResult('File');
        }

        $hashFileName = base64_encode(date('Ymdhis') . uniqid());
        $rtn = array(
            'Extention' => end($temp),
            'RawFileName' => $file['name'],
            'HashFileName' => $hashFileName,
            'FileTmpPath' => $file['tmp_name'],
            'Url' => implode('/', array($this->app->config->asset->baseUrl, 'media', date('Y'), date('m'), date('d'), $hashFileName . '.' . end($temp)))
        );

        $fileTargetPath = implode(DS, array($this->app->config->file->media->path, date('Y'), date('m'), date('d'), $rtn['HashFileName'] . '.' . $rtn['Extention']));
        move_uploaded_file($rtn['FileTmpPath'], $fileTargetPath);

        if ($type == 'image') {
            $imagine = new Imagine();
            $image = $imagine->open($fileTargetPath);
            $image->thumbnail(new Box(180, 180))->save(str_replace('.' . $rtn['Extention'], '_180x180.' . $rtn['Extention'], $fileTargetPath));

            $rtn['ThumbUrl'] = implode('/', array($this->app->config->asset->baseUrl, 'media', date('Y'), date('m'), date('d'), $rtn['HashFileName'] . '_180x180.' . $rtn['Extention']));
        }
    }

}