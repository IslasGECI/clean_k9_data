FROM islasgeci/base:latest
COPY . /workdir
RUN pip install --upgrade pip && pip install \
    black \
    codecov \
    flake8 \
    mutmut \
    mypy \
    pylint \
    pytest \
    pytest-cov
    
# Install static version of module
RUN pip install . 
