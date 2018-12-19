#!/bin/bash

set -e

if [ -z "${CHART_VERSION}" ]; then
    # Get the first semver tag
    echo "No CHART_VERSION defined.  Using .tags file."
    IFS=',' read -ra TAGS <<< $(cat .tags)
    for t in "${TAGS[@]}"; do
        echo "Found tag: ${t}"
        if [[ $t =~ [v]*[0-9]+\.[0-9]+\.[0-9]+.* ]]; then
            CHART_VERSION=$t
            break
        fi
    done
fi
echo "CHART_VERSION: $CHART_VERSION"

if [ -z "${CHART_NAME}" ]; then
    echo "No CHART_NAME defined. Using CICD_GIT_BRANCH"
    CHART_NAME="${CICD_GIT_BRANCH}"
fi
echo "CHART_NAME: ${CHART_NAME}"

mkdir -p .build/

echo '======'
echo "${GIT_USER}"
echo "${GIT_PASSWORD}"
echo '======'
echo "${CHART_NAME}"
echo "${CHART_VERSION}"

git config --global user.email "engineering@vaultdragon.com"
git config --global user.name "Dragoneering"

git clone https://${GIT_USER}:${GIT_PASSWORD}@bitbucket.org/vaultdragon/charts.git .build/



ls .build/charts

mkdir -p .build/charts/${CHART_NAME}/${CHART_VERSION}/
cp -a .chart/. .build/charts/${CHART_NAME}/${CHART_VERSION}/

# sed replace version and name
sed -i -e "s/%VERSION%/${CHART_VERSION}/g" .build/charts/${CHART_NAME}/${CHART_VERSION}/Chart.yaml
sed -i -e "s/%VERSION%/${CHART_VERSION}/g" .build/charts/${CHART_NAME}/${CHART_VERSION}/values.yaml
sed -i -e "s/%CHART_NAME%/${CHART_NAME}/g" .build/charts/${CHART_NAME}/${CHART_VERSION}/Chart.yaml

echo ".build/charts/${CHART_NAME}/${CHART_VERSION}/Chart.yaml"
cat .build/charts/${CHART_NAME}/${CHART_VERSION}/Chart.yaml
echo ".build/charts/${CHART_NAME}/${CHART_VERSION}/values.yaml"
cat .build/charts/${CHART_NAME}/${CHART_VERSION}/values.yaml

cd .build/
git add .
git commit -m "publish ${CHART_NAME} ${CHART_VERSION}"
git push

echo "successfully publish ${CHART_NAME} ${CHART_VERSION}"

