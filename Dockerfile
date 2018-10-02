FROM jenkins/jenkins:lts-alpine
MAINTAINER Valery M. <manycoding@users.noreply.github.com>

USER root

RUN apk add --no-cache python3 python3-dev curl gcc g++ && \
    ln -s /usr/include/locale.h /usr/include/xlocale.h && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --upgrade pip setuptools && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
    rm -r /root/.cache

COPY requirements.txt /server_requirements.txt
RUN PIP_INDEX_URL=http://172.17.42.1:3141/root/public/ \
    PIP_TRUSTED_HOST=172.17.42.1 && \
    pip install -U pipenv && \
    pip install --extra-index-url=https://pypi.python.org/simple/ --no-cache-dir -r /server_requirements.txt

USER jenkins
