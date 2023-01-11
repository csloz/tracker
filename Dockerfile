# pull official base image
FROM python:3.9-alpine

# set work directory
WORKDIR /app

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# install dependencies
RUN apk update
RUN apk upgrade
RUN apk add --virtual .build-deps gcc python3-dev musl-dev postgresql-dev git

#git clone the repo
RUN mkdir /usr/src/tracker 
RUN cd /usr/src/ 
RUN git clone https://github.com/nonanomalous/tracker.git tracker

#pip
WORKDIR /app/tracker
RUN pip install --upgrade pip
RUN pip install -r requirements.txt
#COPY .env .

#cleanup leftovers and install nginx
RUN apk del .build-deps
RUN apk add nginx
COPY nginx.default /etc/nginx/sites-available/default
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log


# copy project
WORKDIR /usr/src/tracker
COPY . .
