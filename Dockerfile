FROM ruby:2.6-alpine AS builder

RUN apk add --no-cache git

# do this to get rid of this warning:
#   the running version of Bundler (1.17.2) is older than the version that created the lockfile (1.17.3).
RUN gem uninstall bundler
RUN gem install bundler -v 1.17.3

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /usr/src/app

RUN git clone git://github.com/developertogo/yacs-checkout.git

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

CMD ["ruby", "./yacs_register.rb"]


