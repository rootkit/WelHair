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

    public function image($fileInputName, $onlyOriginal = false)
    {
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
            $this->app->log->getWriter()->write('An error occurred while creating your directory at '. $e->getPath(), \Slim\Log::ERROR);
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

        if ($onlyOriginal) {

            self::sendResponse(array(
                'OriginalUrl' => $rtn['Url']
            ));
        } else {
            $imagine = new Imagine();
            $image = $imagine->open($fileTargetPath);

            $size = $image->getSize();
            $width = $size->getWidth();
            $height = $size->getHeight();

            if ($width >= $height) {
                $image->crop(new Point(($width - $height) / 2, 0), new Box($height, $height));
            } else {
                $image->crop(new Point(0, ($height - $width) / 2), new Box($width, $width));
            }

            $image->save(str_replace('.' . $rtn['Extention'], '_square.' . $rtn['Extention'], $fileTargetPath));
            $rtn['SquareUrl'] = implode('/', array($this->app->config->asset->baseUrl, 'media', date('Y'), date('m'), date('d'), $rtn['HashFileName'] . '_square.' . $rtn['Extention']));

            $image->thumbnail(new Box(480, 480))->save(str_replace('.' . $rtn['Extention'], '_480x480.' . $rtn['Extention'], $fileTargetPath));
            $rtn['Thumb480Url'] = implode('/', array($this->app->config->asset->baseUrl, 'media', date('Y'), date('m'), date('d'), $rtn['HashFileName'] . '_480x480.' . $rtn['Extention']));

            $image->thumbnail(new Box(110, 110))->save(str_replace('.' . $rtn['Extention'], '_110x110.' . $rtn['Extention'], $fileTargetPath));
            $rtn['Thumb110Url'] = implode('/', array($this->app->config->asset->baseUrl, 'media', date('Y'), date('m'), date('d'), $rtn['HashFileName'] . '_110x110.' . $rtn['Extention']));

            self::sendResponse(array(
                'OriginalUrl' => $rtn['Url'],
                'SquareUrl' => $rtn['SquareUrl'],
                'Thumb480Url' => $rtn['Thumb480Url'],
                'Thumb110Url' => $rtn['Thumb110Url']
            ));
        }
    }

    public function imageCrop()
    {
        $x1 = $this->app->request->post('x1');
        $y1 = $this->app->request->post('y1');
        $x2 = $this->app->request->post('x2');
        $y2 = $this->app->request->post('y2');

        $img = $this->app->request->post('img');
        $img = str_replace($this->app->config->asset->baseUrl . '/media', '', $img);

        $fileOri = $this->app->config->file->media->path . $img;
        if (!is_file($fileOri)) {
            self::sendResponse(array('success' => false, 'message' => 'File is not exists!'));
        }

        $temp = explode('.', $fileOri);
        $ext = end($temp);

        $imagine = new Imagine();
        $image = $imagine->open($fileOri);

        $image->crop(new Point($x1, $y1), new Box($x2 - $x1, $y2 - $y1));

        $image->save(str_replace('.' . $ext, '_square.' . $ext, $fileOri));
        $image->thumbnail(new Box(480, 480))
              ->save(str_replace('.' . $ext, '_480x480.' . $ext, $fileOri));
        $image->thumbnail(new Box(110, 110))
              ->save(str_replace('.' . $ext, '_110x110.' . $ext, $fileOri));

        self::sendResponse(array('success' => true));
    }

}
