FROM ruby:2.6.3

ENV RAILS_ENV test
ENV NODE_ENV test

ARG COMPLIANCE_CHECKER_API_URL
ENV COMPLIANCE_CHECKER_API_URL=$COMPLIANCE_CHECKER_API_URL
ENV GOOGLE_ANALYTICS_ID=123
ENV SECRET_KEY_BASE=123

# Enable root privileges for further installations
RUN apt-get update && \
      apt-get -y install sudo && \
      useradd -m docker && \
      echo "docker:docker" | chpasswd && \
      adduser docker sudo

# Install node, yarn and bundler
RUN sudo apt-get update && \
      curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash - && \
      sudo apt install npm && \
      npm install --global yarn
RUN gem install bundler --version 2.0.2

# Copy Gemfile and bundle install before copying remainder of source to cache package installation
COPY Gemfile Gemfile.lock /drone/src
WORKDIR /drone/src
RUN bundle install

# Copy remainder of application code
COPY . /drone/src

RUN yarn install --frozen-lockfile --non-interactive
RUN rails webpacker:install
RUN bundle exec rails webpacker:compile
# RUN bundle exec rails assets:precompile

EXPOSE 3000
# CMD ["rails", "server", "-b", "ssl://0.0.0.0:3000?key=config/ssl/app.key&cert=config/ssl/app.crt"]
