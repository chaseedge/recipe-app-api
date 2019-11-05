FROM python:3.7-alpine
MAINTAINER Chase Edge

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /requirements.txt
RUN apk add --update --no-cache postgresql-client jpeg-dev
# ones below are removed after build b/c of the --virtual option
RUN apk add --update --no-cache --virtual .tmp-build-deps \
        gcc libc-dev linux-headers postgresql-dev musl-dev zlib zlib-dev
RUN pip install -r /requirements.txt
RUN apk del .tmp-build-deps

RUN mkdir /app
WORKDIR /app
COPY ./app/ /app

# -p means make dir if it doesn't exist
RUN mkdir -p /vol/web/media
RUN mkdir -p /vol/web/static
RUN adduser -D user
# need to change ownership before switch. -R means recursive
RUN chown -R user:user /vol
RUN chmod -R  755 /vol/web
USER user
