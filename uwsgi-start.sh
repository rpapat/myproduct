#!/bin/bash

# Modeled closely after flask portion of amazon/aws-eb-python:3.4.2-onbuild-3.5.1 entrypoint script

UWSGI_NUM_PROCESSES='1'
UWSGI_NUM_THREADS='15'
UWSGI_UID='uwsgi'
UWSGI_GID='uwsgi'
UWSGI_LOG_FILE='/var/log/uwsgi/uwsgi.log'
UWSGI_TIMEOUT='60'

cd /var/app

. bin/activate

# Flask support
if cat requirements.txt | grep -q -i Flask && [ -z "${WSGI_MODULE}" ]; then
  UWSGI_MODULE='--module application:app'
fi

# defaulting to application.py if not explicitly set
[ -z "${WSGI_PATH}" ] && WSGI_PATH=application.py

uwsgi --http :8080 --chdir /var/app --wsgi-file ${WSGI_PATH} ${UWSGI_MODULE} --master --processes ${UWSGI_NUM_PROCESSES} --threads ${UWSGI_NUM_THREADS} --uid ${UWSGI_UID} --gid ${UWSGI_GID} --logto2 ${UWSGI_LOG_FILE} -t ${UWSGI_TIMEOUT} --http-keepalive
