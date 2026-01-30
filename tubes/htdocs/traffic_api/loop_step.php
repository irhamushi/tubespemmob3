<?php
// loop_step.php - trigger one loop iteration (atomic)
require_once __DIR__ . '/db.php';

$mysqli = get_db();
$mysqli->begin_transaction();

try {
    // For each junction, apply loop rules:
    // 1) All YELLOW -> RED
    // 2) GREEN -> YELLOW (mark what was green)
    // 3) The next light after previous green becomes GREEN

    // Get all distinct junctions
    $junctions = [];
    $rs = $mysqli->query("SELECT DISTINCT junction_id FROM traffic_light");
    while ($r = $rs->fetch_assoc()) $junctions[] = $r['junction_id'];
    $rs->free();

    foreach ($junctions as $junction) {
        // 1) YELLOW -> RED
        $mysqli->query("UPDATE traffic_light SET status='RED' WHERE junction_id=".(int)$junction." AND status='YELLOW'");

        // 2) Find current GREEN. We'll take the one with smallest id if multiple.
        $res = $mysqli->query("SELECT id FROM traffic_light WHERE junction_id=".(int)$junction." AND status='GREEN' ORDER BY id LIMIT 1");
        $currentGreen = null;
        if ($row = $res->fetch_assoc()) {
            $currentGreen = (int)$row['id'];
        }
        $res->free();

        if ($currentGreen !== null) {
            // set current green to YELLOW
            $stmt = $mysqli->prepare("UPDATE traffic_light SET status='YELLOW' WHERE id = ?");
            $stmt->bind_param('i', $currentGreen);
            $stmt->execute();
            $stmt->close();

            // find next light by id
            $res = $mysqli->query("SELECT id FROM traffic_light WHERE junction_id=".(int)$junction." AND id > ".$currentGreen." ORDER BY id LIMIT 1");
            $next = null;
            if ($r = $res->fetch_assoc()) $next = (int)$r['id'];
            $res->free();

            if ($next === null) {
                // wrap around to first id in junction
                $res = $mysqli->query("SELECT id FROM traffic_light WHERE junction_id=".(int)$junction." ORDER BY id LIMIT 1");
                if ($r = $res->fetch_assoc()) $next = (int)$r['id'];
                $res->free();
            }

            if ($next !== null) {
                $stmt = $mysqli->prepare("UPDATE traffic_light SET status='GREEN' WHERE id = ?");
                $stmt->bind_param('i', $next);
                $stmt->execute();
                $stmt->close();
            }
        } else {
            // No green exists, set the first light of the junction to GREEN
            $res = $mysqli->query("SELECT id FROM traffic_light WHERE junction_id=".(int)$junction." ORDER BY id LIMIT 1");
            if ($r = $res->fetch_assoc()) {
                $first = (int)$r['id'];
                $stmt = $mysqli->prepare("UPDATE traffic_light SET status='GREEN' WHERE id = ?");
                $stmt->bind_param('i', $first);
                $stmt->execute();
                $stmt->close();
            }
            $res->free();
        }
    }

    $mysqli->commit();
    json_ok(['success' => true, 'message' => 'Loop step executed']);
} catch (Exception $e) {
    $mysqli->rollback();
    http_response_code(500);
    echo json_encode(['error' => $e->getMessage()]);
}

$mysqli->close();
?>