FROM ruby:2.6.3-alpine3.9

# Set correct environment variables.
ARG secret_key_base
ENV SECRET_KEY_BASE=$secret_key_base

RUN apk add --no-cache --update build-base \
  linux-headers \
  tzdata \
  nodejs \
  tzdata \
  openssh \
  libxml2-dev \
  libxslt-dev \
  yarn \
  curl-dev \
  sqlite-dev \
  && PACKAGES="ca-certificates procps curl pcre libstdc++ libexecinfo" \
  && BUILD_PACKAGES="pcre-dev libexecinfo-dev" \
  && apk add --update $PACKAGES $BUILD_PACKAGES \
  && rm -rf /var/cache/apk/*

# Install bundle of gems
RUN mkdir -p /home/app
WORKDIR /home/app
COPY Gemfile Gemfile.lock package.json /home/app/
RUN gem install bundler \
  && bundle install && yarn install --frozen-lockfile --non-interactive

# Install node packages and precompile assets
COPY . /home/app

CMD ["rspec"]
