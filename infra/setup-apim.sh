#!/bin/bash

set -e

# Get artifacts from GitHub
urls=$(curl -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/justinyoo/swm-gha-workshop-advanced/releases/latest | jq '.assets[] | { name: .name, url: .browser_download_url }')
apizip=$(echo $urls | jq 'select(.name == "api.zip") | .url' -r)

# Deploy function apps
apiapp=$(az functionapp deploy -g rg-$RESOURCE_NAME -n fncapp-$RESOURCE_NAME-api --src-url $apizip --type zip)
