FROM ruby:2.2.3

# app dependencies
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev

RUN mkdir /usr/src/app
