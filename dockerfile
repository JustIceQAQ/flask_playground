ARG PYTHON_VERSION=3.9

FROM python:${PYTHON_VERSION}

ARG WHEEL_DIR=/usr/src/app/wheels
ARG APP_HOME=/app
ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1

RUN apt-get update &&  \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false &&  \
    rm -rf /var/lib/apt/lists/*

WORKDIR ${APP_HOME}

COPY ./requirements.txt .

RUN python -m pip wheel --wheel-dir ${WHEEL_DIR} -r requirements.txt

RUN python -m pip install --no-cache-dir --no-index --find-links=${WHEEL_DIR} ${WHEEL_DIR}/*  && rm -rf ${WHEEL_DIR}

EXPOSE 5000

COPY . .

CMD python app.py



