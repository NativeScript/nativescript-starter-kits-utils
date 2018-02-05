#!/bin/bash 

#
# Update template apps
#


if [ $# -eq 0 ] || [ $# -eq 1 ]; then
	echo "Usage:"
	echo "sh merge.sh <template-filter> <base-branch> <head-branch> <message>"
	echo
	echo "Comments:"
	echo "  <template-filter> is grep filter to filter repo names in github NS org"
	echo "  <base-branch> is the branch that we want to merge to"
	echo "	<head-branch> is the branch that we want to merge from"
	echo "  <message> is commit message"
	exit 1
fi

# Name of organisation
ORG="Nativescript"

# Data needed to talk to API
USER=""
PASS="x-oauth-basic"

# API info
API="https://api.github.com"
PERPAGE=100

# Additional info
TEMPLATEFILTER="$1"
BASEBRANCH="$2"
HEADBRANCH="$3"
MESSAGE="$4"

ESCAPEDGITHUBURL=https:\/\/github.com

# curl -s -I -u $USER:$PASS ${API}/orgs/${ORG}/repos?per_page=${PERPAGE} | grep Link:
# outputs
# Link: <https://api.github.com/organizations/1152554/repos?per_page=100&page=2>; rel="next", <https://api.github.com/organizations/1152554/repos?per_page=100&page=2>; rel="last"
# now get the page with 'last' index

PAGES=`curl -s -I -u $USER:$PASS ${API}/orgs/${ORG}/repos?per_page=${PERPAGE} | grep Link: | awk '{print $4}' | cut -d'=' -f 3 | cut -d'>' -f 1`
echo "# examining a total of $PAGES pages of repositories"
for ((PAGE=1;PAGE<=$PAGES;PAGE++)); do
	echo "## getting list of repos from page $PAGE"
	echo

	# get a list of all repositories
	REPOLIST=`curl -s -u $USER:$PASS "${API}/orgs/${ORG}/repos?per_page=${PERPAGE}&page=${PAGE}" | grep ssh_url | grep ${TEMPLATEFILTER} | awk '{print $2}' | cut -f 1 -d , `
	
	for REPOQUOTES in $REPOLIST; do
		REPO="${REPOQUOTES%\"}"
		REPO="${REPO#\"}"
		REPONAME=`echo ${REPO} | cut -d'/' -f 2 | cut -d'.' -f 1`
		# `git clone` clones in a folder named $REPONAME
		echo ${REPO}
        ssh-agent bash -c "ssh-add ~/.ssh/id_rsa; git clone ${REPO}"

		echo "$REPONAME"
		echo
		cd "$REPONAME"
		echo
		hub pull-request -m "$MESSAGE" -b $BASEBRANCH -h $HEADBRANCH
		cd ..

		echo
		echo "## Removing working directory..."
		echo
		rm -rf $REPONAME
	done
done


echo "Update successfull"