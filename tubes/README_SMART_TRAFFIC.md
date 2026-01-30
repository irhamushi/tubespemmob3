Smart Traffic App - Setup & Run

Backend (XAMPP / PHP / MySQL)
1. Put the folder `htdocs/traffic_api` into your XAMPP `htdocs`.
2. Import `htdocs/traffic_api/db.sql` into MySQL (phpMyAdmin). That creates `traffic_system` and sample data.
3. Edit `db.php` if your MySQL credentials are different.
4. Test endpoints:
   - http://localhost/traffic_api/get_lights.php
   - http://localhost/traffic_api/get_light.php?id=1
   - http://localhost/traffic_api/loop_step.php
5. For continuous server-side looping:
   - Run in terminal: `php <path-to-xampp>/htdocs/traffic_api/loop_engine.php --interval=5 --daemon`

Flutter (frontend)
1. Ensure `pubspec.yaml` has `flutter_map`, `latlong2`, `http` (already present).
2. Run `flutter pub get`.
3. Run app: `flutter run` (use emulator or device). For android emulator use `10.0.2.2` base URL.

Notes
- For production, add API authentication (API key / JWT) and HTTPS.
- The server loop works well as a background PHP CLI process. Alternatively use a CRON that calls `loop_step.php` periodically.
