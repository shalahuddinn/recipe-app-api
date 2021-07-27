FROM python:3.7-alpine
MAINTAINER Shalahuddin Al Ayyubi

# Run python in unbuffered mode
ENV PYTHONUNBUFFERED 1

# Install dependencies
COPY ./requirements.txt /requirements.txt
RUN pip install -r /requirements.txt

# Setup directory structure
RUN mkdir /app
WORKDIR /app
COPY ./app/ /app

# Create user and switch to the user to run the application. So the app will not run using root which is dangerous.
RUN adduser -D user
USER user