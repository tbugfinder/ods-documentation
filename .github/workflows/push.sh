#!/usr/bin/env bash
set -euxo pipefail

setup_git() {
  git config --global user.email "ghactions@github.com"
  git config --global user.name "GitHub Actions"
}

commit_website_files() {
  sudo touch docs/.nojekyll
  git add -A . 
  git commit --message "GitHub Actions Build: $GITHUB_RUN_NUMBER [ci skip]"
  git branch temp-changes
  git checkout $GITHUB_REF_SLUG
  git merge --no-commit --no-ff temp-changes
  git reset HEAD -- package.json
  git reset HEAD -- package-lock.json
  git commit --message "GitHub Actions Build: $GITHUB_RUN_NUMBER [ci skip]"
}

upload_files() {
  git remote add origin-pages https://username:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git > /dev/null 2>&1
  git push --quiet --set-upstream origin-pages $GITHUB_REF_SLUG
}

setup_git
commit_website_files
upload_files
