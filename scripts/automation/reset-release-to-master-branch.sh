#!/usr/bin/env bash
### Terminate script on error
set -e

### Global vars TODO Implement a method for more automated folder detection
TEMPLATES_BASE_DIR="$1";

GREEN='\033[0;32m'
WHITE='\033[1;37m'
RED='\033[0;31m'
NC='\033[0m' # No Color

### declare an array of template names
declare -a templates=(
    "template-blank"
    "template-blank-ts"
    "template-blank-ng"
    "template-blank-vue"
    "template-drawer-navigation"
    "template-drawer-navigation-ts"
    "template-drawer-navigation-ng"
    "template-tab-navigation"
    "template-tab-navigation-ts"
    "template-tab-navigation-ng"
    "template-master-detail"
    "template-master-detail-ts"
    "template-master-detail-ng"
    "template-master-detail-vue"
    "template-master-detail-kinvey"
    "template-master-detail-kinvey-ts"
    "template-master-detail-kinvey-ng"
    "template-health-survey-ng"
    "template-patient-care-ng"
)

### Check PWD
function checkDir() {
    if [[ -d ${TEMPLATES_BASE_DIR} ]]; then
        echo ${TEMPLATES_BASE_DIR};
    else
        echo -e "${RED}First argument must be a valid Directory${RED}${NC}";
        exit 1;
    fi
}

### Main function
function run() {
BASE_DIR=${PWD}
for i in "${templates[@]}"
do
    cd "${TEMPLATES_BASE_DIR}${i}";
    echo -e "${GREEN}Downloading the latest changes from the ${WHITE}${i}${GREEN} repository${NC}"
    git checkout master && git pull

    echo -e "${GREEN}Resetting release branch to master branch${NC}"
    git checkout release && git reset --hard master && git push -f

    cd ${BASE_DIR}
done;

}

checkDir
run
echo -e "${GREEN}Done${NC}"
exit 0;
