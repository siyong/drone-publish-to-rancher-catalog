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

git clone https://${GIT_USER}:${GIT_PASSWORD}@bitbucket.org/vaultdragon/charts.git .build/



ls .build/charts

mkdir -p .build/charts/${CHART_NAME}/${CHART_VERSION}/
cp -a .chart/. .build/charts/${CHART_NAME}/${CHART_VERSION}/
## echo ".build/charts/${CHART_NAME}/${CHART_VERSION}/"
## ls .build/charts/${CHART_NAME}/${CHART_VERSION}/

## sleep 5s

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

## export HELM_HOME=/root/.helm

# Lint Chart
##helm lint .build/${CHART_NAME}

# Package Chart
##helm package -d .build/charts .build/${CHART_NAME}

# Add Remote Repo
##helm repo add --username "${HELM_REPO_USERNAME}" --password "${HELM_REPO_PASSWORD}" \
##pipeline-tmp ${HELM_REPO_URL}

# Publish Chart 
##helm push .build/charts/${CHART_NAME}-${CHART_VERSION}.tgz pipeline-tmp
