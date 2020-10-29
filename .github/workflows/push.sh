#!/usr/bin/env bash
set -euxo pipefail

setup_git() {
  git config --global user.email "ghactions@github.com"
  git config --global user.name "GitHub Actions"
}

commit_website_files() {
  cd docs
  sudo touch .nojekyll
  git add -A . 
  git commit --message "GitHub Actions Build: $GITHUB_RUN_ID [ci skip]"
  git branch temp-changes
  git checkout $GITHUB_REF
  git merge temp-changes
}

upload_files() {
  git remote add origin-pages https://${GH_TOKEN}@github.com/${GITHUB_REPOSITORY}.git > /dev/null 2>&1
  git push --quiet --set-upstream origin-pages $GITHUB_REF
}

setup_git
commit_website_files
upload_files
