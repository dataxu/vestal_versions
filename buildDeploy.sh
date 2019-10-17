#!/bin/bash
# A Simple Shell Script to build a ruby gem, and push it to Artifactory.

##############
# PARAMETERS #
##############
GEM_NAME=vestal_versions
SPEC_FILE=vestal_versions.gemspec
AWS_REGION=us-east-1


# Build Ruby Gem
gem build $SPEC_FILE

# Obtain Artifactory login creds
RUBY_PASSWD=$(aws secretsmanager get-secret-value --secret-id jenkins-ruby-deployer --region $AWS_REGION | jq .SecretString -r)

# Obtain Artifactory api key
curl http://artifactory.devaws.dataxu.net/artifactory/api/gems/ruby-local/api/v1/api_key.yaml -u ruby-deployer:$RUBY_PASSWD > ~/.gem/credentials

# Push Gem to Artifactory
gem push $(ls -1 $GEM_NAME*.gem) --host http://artifactory.devaws.dataxu.net/artifactory/api/gems/ruby-local -k rubygems --verbose
