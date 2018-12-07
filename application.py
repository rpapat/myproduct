"""Application."""

from raven.contrib import flask

from myproduct import api
from myproduct import config
from myproduct import handlers  # noqa


if config.SENTRY:
    api.app.config['SENTRY_DSN'] = config.SENTRY
    flask.Sentry(api.app)

app = api.app
