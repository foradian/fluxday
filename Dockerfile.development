FROM phusion/baseimage:0.9.19
MAINTAINER Halisson Vitor

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

ENV LANGUAGE en_US.UTF-8

# Install os dependencies
RUN apt-add-repository ppa:brightbox/ruby-ng
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y nodejs \
    ruby2.1 \
    ruby2.1-dev \
    build-essential \
    curl \
    zlib1g-dev \
    libssl-dev \
    libreadline-dev \
    libyaml-dev \
    libxml2-dev \
    libxslt-dev \
    libpq-dev \
    git python-virtualenv \
    libmysqlclient-dev \
    libmagickwand-dev \
    gnuplot \
    imagemagick-doc \
    imagemagick \
    wkhtmltopdf

RUN gem install bundler

ENV APP_HOME /share
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/
RUN bundle install

ADD . $APP_HOME

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
