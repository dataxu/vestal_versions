FROM ruby:1.9.3-p551

RUN apt-get update -qq && apt-get install -qy awscli curl && apt-get clean

RUN useradd -c 'builder of ruby projs' -m -d /home/builder -s /bin/bash builder

# RUN mkdir -p $HOME/.bundle
# ENV BUNDLE_USER_HOME $HOME/.bundle
# ENV BUNDLE_PATH $HOME/.bundle

USER builder
ENV HOME /home/builder
RUN mkdir -p $HOME/app
ADD --chown=builder:builder . $HOME/app/
WORKDIR $HOME/app/

RUN gem install bundler -v 1.9.3-p551 && bundle install
