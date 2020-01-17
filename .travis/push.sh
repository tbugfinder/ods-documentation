#!/usr/bin/env bash
set -euxo pipefail

setup_git() {
  git config --global user.email "travis@travis-ci.org"
  git config --global user.name "Travis CI"
}

commit_website_files() {
  cd docs
  sudo touch .nojekyll
  git add -A . 
  git commit --message "Travis build: $TRAVIS_BUILD_NUMBER [ci skip]"
  git branch temp-changes
  git checkout $TRAVIS_BRANCH
  git merge temp-changes
}

upload_files() {
  git remote add origin-pages https://${GH_TOKEN}@github.com/${TRAVIS_REPO_SLUG}.git > /dev/null 2>&1
  git push --quiet --set-upstream origin-pages $TRAVIS_BRANCH
}

setup_git
commit_website_files
upload_files
