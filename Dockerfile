FROM ruby:2.6

# Env
ENV PHANTOMJS_VERSION 1.9.8

# Install phantomjs
RUN mkdir -p /srv/var && \
  wget -q --no-check-certificate -O /tmp/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 && \
  tar -xjf /tmp/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 -C /tmp && \
  rm -f /tmp/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 && \
  mv /tmp/phantomjs-$PHANTOMJS_VERSION-linux-x86_64/ /srv/var/phantomjs && \
  ln -s /srv/var/phantomjs/bin/phantomjs /usr/bin/phantomjs

ENV RAILS_ENV=test

# Install node
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -

RUN mkdir /my_app
WORKDIR /my_app

COPY Gemfile /my_app
COPY Gemfile.lock /my_app
RUN bundle install

COPY . /my_app

CMD ["rails", "test:system"]