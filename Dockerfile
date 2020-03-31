FROM ruby:2.6

ENV RAILS_ENV=test

# libnss3-dev is necessary to install google-chrome & run chromedriver-helper
RUN apt-get update -qq && apt-get install -y libnss3-dev

# Install node
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -

RUN mkdir /my_app
WORKDIR /my_app

COPY . /my_app
RUN bundle install

CMD ["rails", "test:system"]