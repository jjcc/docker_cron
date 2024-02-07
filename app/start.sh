#!/bin/bash
# Start supervisord that manages cron
/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf &
flask run --host 0.0.0.0 --port 5000