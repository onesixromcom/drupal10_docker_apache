<?php

// @codingStandardsIgnoreFile

assert_options(ASSERT_ACTIVE, TRUE);
\Drupal\Component\Assertion\Handle::register();

$databases['default']['default'] = [
  'database' => getenv('DATABASE_NAME'),
  'driver' => 'mysql',
  'host' => getenv('DATABASE_HOST'),
  'namespace' => 'Drupal\\Core\\Database\\Driver\\mysql',
  'password' => getenv('DATABASE_PASSWORD'),
  'port' => getenv('DATABASE_PORT'),
  'prefix' => '',
  'username' => getenv('DATABASE_USER'),
];
$settings['trusted_host_patterns'] = [];

$settings['container_yamls'][] = DRUPAL_ROOT . '/sites/development.services.yml';
$config['system.logging']['error_level'] = 'verbose';

$config['system.performance']['css']['preprocess'] = FALSE;
$config['system.performance']['js']['preprocess'] = FALSE;

$settings['rebuild_access'] = TRUE;
$settings['skip_permissions_hardening'] = TRUE;

$settings['cache']['bins']['page'] = 'cache.backend.null';
$settings['cache']['bins']['render'] = 'cache.backend.null';
$settings['cache']['bins']['dynamic_page_cache'] = 'cache.backend.null';
