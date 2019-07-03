FROM ruby:2.6.3

ARG COMPLIANCE_CHECKER_API_URL
ENV COMPLIANCE_CHECKER_API_URL=$COMPLIANCE_CHECKER_API_URL

RUN apt-get update && \
      apt-get -y install sudo && \
      useradd -m docker && \
      echo "docker:docker" | chpasswd && \
      adduser docker sudo

RUN sudo apt-get update && \
      curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash - && \
      sudo apt install npm && \
      npm install --global yarn
RUN gem install bundler --version 2.0.2

COPY . /myapp
WORKDIR /myapp

RUN bundle install
RUN yarn install --check-files
RUN bundle exec rails assets:precompile

EXPOSE 3000
# CMD ["rails", "server", "-b", "ssl://0.0.0.0:3000?key=config/ssl/app.key&cert=config/ssl/app.crt"]
