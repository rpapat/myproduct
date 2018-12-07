.PHONY: dev pip_dev lint test test_unit test_integration pip_test_integration clean clean_test_integration

dev: env dev.py
	env/bin/python3.6 dev.py

env pip_dev: requirements.txt requirements-dev.txt
	python3.6 -m venv env
	env/bin/pip3.6 install --upgrade pip
	env/bin/pip3.6 install -r requirements.txt
	env/bin/pip3.6 install -r requirements-dev.txt

lint: env ows-myproduct tests/ dev.py
	env/bin/flake8 ows-myproduct/ tests/ dev.py

test: env tests/unit/
	env/bin/py.test tests/unit/

test_unit: env ows-myproduct tests/unit/
	env/bin/py.test \
		--cov ows-myproduct tests/unit/ \
		--cov-report xml \
		--junitxml=pyunit.xml

test_integration: tests/integration/env tests/integration
	tests/integration/env/bin/py.test tests/integration

tests/integration/env pip_test_integration: tests/integration/requirements.txt
	python3.6 -m venv tests/integration/env
	tests/integration/env/bin/pip3.6 install --upgrade pip
	tests/integration/env/bin/pip3.6 install -r tests/integration/requirements.txt

clean:
	rm -rf env

clean_test_integration:
	rm -rf tests/integration/env
