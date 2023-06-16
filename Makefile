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
	black --check --line-length 100 src
	black --check --line-length 100 tests
	flake8 --max-line-length 100 ${module}
	flake8 --max-line-length 100 src
	flake8 --max-line-length 100 tests
	mypy ${module}
	mypy src
	mypy tests

clean:
	rm --force --recursive ${module}.egg-info
	rm --force --recursive ${module}/__pycache__
	rm --force --recursive .*_cache
	rm --force --recursive tests/__pycache__
	rm --force .mutmut-cache
	rm --force NAMESPACE
	rm --force coverage.xml

coverage: install
	pytest --cov=${module} --cov-report=term-missing --verbose

format:
	black --line-length 100 ${module}
	black --line-length 100 src
	black --line-length 100 tests

mutants: install
	mutmut run --paths-to-mutate ${module}
	mutmut run --paths-to-mutate src

init: setup tests
	git config --global --add safe.directory /workdir
	git config --global user.name "Ciencia de Datos • GECI"
	git config --global user.email "ciencia.datos@islas.org.mx"

install:
	pip install --editable .

setup: clean install
	shellspec --init

tests: tests_python tests_spec

tests_python:
	pytest --verbose

tests_spec:
	shellspec

red: format
	pytest --verbose \
	&& git restore tests/*.py \
	|| (git add tests/*.py && git commit -m "🛑🧪 Fail tests")
	chmod g+w -R .

green: format
	pytest --verbose \
	&& (git add ${module}/*.py tests/*.py && git commit -m "✅ Pass tests") \
	|| git restore ${module}/*.py
	chmod g+w -R .

refactor: format
	pytest --verbose \
	&& (git add ${module}/*.py tests/*.py && git commit -m "♻️  Refactor") \
	|| git restore ${module}/*.py tests/*.py
	chmod g+w -R .
