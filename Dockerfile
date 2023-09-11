FROM python:3.11-slim-bookworm as base
MAINTAINER Ashton Honnecke <ashton@pixelstub.com>

# This is all just copied, need to tweak it

ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
ENV AWS_DEFAULT_REGION us-west-2
ENV PYTHONUNBUFFERED 1
ENV PYTHON_PATH $PYTHON_PATH:/app
ENV WORKDIR /app

WORKDIR /app/

RUN pip install --upgrade pip
RUN pip install pipenv

COPY ./Pipfile* .
COPY ./src .

RUN pipenv requirements > requirements.txt && \
    pip install -r ./requirements.txt


# Start create user with uid 1000 and user
ARG _UID="1000"
ARG _USER="dockeruser"
RUN useradd --uid ${_UID}  -ms /bin/bash ${_USER}
RUN echo "${_USER}     ALL=NOPASSWD: ALL" >> /etc/sudoers
USER ${_USER}
# End create user with uid 1000 and user

ENTRYPOINT ["python", "main.py"]
