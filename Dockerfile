FROM python:3.7-alpine
MAINTAINER Shalahuddin Al Ayyubi

# Run python in unbuffered mode
ENV PYTHONUNBUFFERED 1

# Install dependencies
COPY ./requirements.txt /requirements.txt
# Install postgresql-client without saving the registry by using --no-cache option
# jpeg-dev for Pillow
RUN apk add --update --no-cache postgresql-client jpeg-dev
# install temporary reuirements for installing the requirements.txt
# --virtual set up an alias for our dependecies that we can use to easily remove all those dependencies later
RUN apk add --update --no-cache --virtual .tmp-build-deps \
# these list are obtained by trial and error
      gcc libc-dev linux-headers postgresql-dev musl-dev zlib zlib-dev
RUN pip install -r /requirements.txt
# remove all the temporary requirements
RUN apk del .tmp-build-deps

# Setup directory structure
RUN mkdir /app
WORKDIR /app
COPY ./app/ /app

# This - P here that we add to the mkdir means make all of the sub directories including the directory that
# we need so if the vol directory doesn't exist it will create vol web and media
RUN mkdir -p /vol/web/media
RUN mkdir -p /vol/web/static

# Create user and switch to the user to run the application. So the app will not run using root which is dangerous.
RUN adduser -D user

# Change the vol folder ownership
RUN chown -R user:user /vol/
# Change the permission of vol folder
RUN chmod -R 755 /vol/web
USER user