<?php

require_once __DIR__ . '/vendor/autoload.php';

use Graby\Graby;
use Http\Adapter\Guzzle6\Client as GuzzleAdapter;
use Monolog\Formatter\LineFormatter;
use Monolog\Handler\ErrorLogHandler;
use Monolog\Logger;

var_dump(LIBXML_DOTTED_VERSION);

$log = new Logger('double-images');
$handler = new ErrorLogHandler(ErrorLogHandler::OPERATING_SYSTEM, 'debug');
$formatter = new LineFormatter(null, null, true, true);
$formatter->includeStacktraces(true);
$handler->setFormatter($formatter);
$log->pushHandler($handler);

$graby = new Graby([
], new GuzzleAdapter());
$graby->setLogger($log);

$url = "https://uxmovement.com/content/strong-layout-hierarchy-reduces-content-overload/";

echo $graby->fetchContent($url)['html'];
