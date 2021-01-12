#!/bin/bash

bundle exec rake move:init
if [[ "$CONTEXT" == "branch_deploy" ]]; then
    mkdir -p _site/docs
    bundle exec jekyll build -d _site/docs
else
    bundle exec jekyll build
fi

