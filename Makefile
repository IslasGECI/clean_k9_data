module = clean_k9_data

define lint
	pylint \
        --disable=bad-continuation \
        --disable=missing-class-docstring \
        --disable=missing-function-docstring \
        --disable=missing-module-docstring \
        ${1}
endef

.PHONY: \
    check \
    clean \
    coverage \
    format \
    init \
    install \
    linter \
    mutants \
    tests

check:
	black --check --line-length 100 ${module}
	black --check --line-length 100 tests
	flake8 --max-line-length 100 ${module}
	flake8 --max-line-length 100 tests
	mypy ${module}

clean:
	rm --force --recursive ${module}.egg-info
	rm --force --recursive ${module}/__pycache__
	rm --force --recursive .*_cache
	rm --force --recursive tests/__pycache__
	rm --force .mutmut-cache
	rm --force NAMESPACE
	rm --force coverage.xml
	rm --force *.csv

coverage: install
	pytest --cov=${module} --cov-report=term-missing --verbose

format:
	black --line-length 100 ${module}
	black --line-length 100 tests

mutants: install
	mutmut run --paths-to-mutate ${module} --runner "shellspec --shell bash spec"

init: setup tests
	git config --global --add safe.directory /workdir
	git config --global user.name "Ciencia de Datos • GECI"
	git config --global user.email "ciencia.datos@islas.org.mx"

install:
	pip install --editable .

setup: clean install
	shellspec --init

tests: tests_spec

tests_python:
	pytest --verbose

tests_spec:
	shellspec

red: format
	shellspec \
	&& git restore spec/*spec.sh \
	|| (git add spec/*spec.sh && git commit -m "🛑🧪 Fail tests")
	chmod g+w -R .

green: format
	shellspec \
	&& (git add ${module}/*.py && git commit -m "✅ Pass tests") \
	|| git restore ${module}/*.py
	chmod g+w -R .

refactor: format
	shellspec \
	&& (git add ${module}/*.py spec/*spec.sh && git commit -m "♻️  Refactor") \
	|| git restore ${module}/*.py spec/*spec.sh
	chmod g+w -R .
