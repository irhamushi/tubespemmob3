<?php
// loop_engine.php
// Usage (CLI): php loop_engine.php [--interval=5]
// Optional: --daemon to run long-running loop (CTRL+C to stop)

require_once __DIR__ . '/db.php';

$opts = getopt("", ["interval::", "daemon::"]);
$interval = isset($opts['interval']) ? (int)$opts['interval'] : 5; // seconds
$daemon = array_key_exists('daemon', $opts);

echo "Starting loop engine (interval={$interval}s)\n";

function step_once() {
    // call the loop_step logic directly
    include __DIR__ . '/loop_step.php';
}

if ($daemon) {
    while (true) {
        step_once();
        sleep($interval);
    }
} else {
    // Do single step
    step_once();
}

?>