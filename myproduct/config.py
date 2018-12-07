"""Application configuration."""

import logging
import os
from os.path import abspath
from os.path import dirname
from os.path import join
from os.path import pardir

from dotenv import load_dotenv
import newrelic.agent


# Load environment variables from a .env file if present
dotenv_path = abspath(join(dirname(__file__), pardir, '.env'))
load_dotenv(dotenv_path)

# Service information
SERVICE_NAME = 'ows-myproduct'
SERVICE_VERSION = '1.0.0'

# Production environment
PROD_ENVIRONMENT = 'prod'
DEV_ENVIRONMENT = 'dev'
QA_ENVIRONMENT = 'qa'
ENVIRONMENT = os.environ.get('Environment') or DEV_ENVIRONMENT

if ENVIRONMENT == PROD_ENVIRONMENT:
    newrelic.agent.initialize('newrelic.ini')

# Errors and loggers
SENTRY = os.environ.get('SENTRY_DSN') or None
LOGGER_DSN = os.environ.get('LOGGER_DSN') or None
LOGGER_LEVEL = logging.INFO
LOGGER_NAME = 'ows1'

# Generic handlers
HEALTH_CHECK = '/hello/'

# Swagger documentation path
SWAGGER_FILE_PATH = 'spec/ows_myproduct-1.0.0.yaml'
