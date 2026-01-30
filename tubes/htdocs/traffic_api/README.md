Smart Traffic API

Folder: htdocs/traffic_api (put under XAMPP htdocs)

Endpoints:
- /get_lights.php   GET -> returns array of traffic_light
- /get_light.php?id=ID   GET -> single record
- /update_light.php   POST JSON {id, status} -> update
- /loop_step.php   GET/POST -> perform one loop iteration (atomic)
- /loop_engine.php   CLI -> php loop_engine.php --interval=5 --daemon

Setup:
1) Import `db.sql` in MySQL (phpMyAdmin)
2) Configure DB credentials in `db.php`
3) Run `php loop_engine.php --interval=5 --daemon` from CLI to run continuous loop

Security & notes:
- All inputs are sanitized (basic) and prepared statements used
- For production, add authentication (API key/JWT), rate limiting, and HTTPS
- Adjust CORS policy in `db.php` if needed
