FROM python:3.7-alpine
MAINTAINER Shalahuddin Al Ayyubi

# Run python in unbuffered mode
ENV PYTHONUNBUFFERED 1

# Install dependencies
COPY ./requirements.txt /requirements.txt
# Install postgresql-client without saving the registry by using --no-cache option
RUN apk add --update --no-cache postgresql-client
# install temporary reuirements for installing the requirements.txt
# --virtual set up an alias for our dependecies that we can use to easily remove all those dependencies later
RUN apk add --update --no-cache --virtual .tmp-build-deps \
# these list are obtained by trial and error
      gcc libc-dev linux-headers postgresql-dev
RUN pip install -r /requirements.txt
# remove all the temporary requirements
RUN apk del .tmp-build-deps

# Setup directory structure
RUN mkdir /app
WORKDIR /app
COPY ./app/ /app

# Create user and switch to the user to run the application. So the app will not run using root which is dangerous.
RUN adduser -D user
USER user