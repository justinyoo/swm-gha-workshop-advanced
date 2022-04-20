# 깃헙 액션 리팩토링 &ndash; `workflow_call` #

## 앱 빌드 및 배포 액션 워크플로우 ##

```yaml
name: 'SWM: Deploy to Azure'

on:
  push:
    branches:
    - main

jobs:
  build_test:
    name: 'Build and Test'

    runs-on: ubuntu-latest

    steps:
    - name: Set environment variables
      shell: bash
      run: |
        echo "FUNCTION_APP_PATH=${{ github.workspace }}/api" >> $GITHUB_ENV

    # - name: Check environment variables
    #   shell: bash
    #   run: |
    #     echo $FUNCTION_APP_PATH
    #     echo $RESOURCE_PATH

    - name: Checkout the repo
      uses: actions/checkout@v2

    - name: Setup .NET Core SDK
      uses: actions/setup-dotnet@v1
      with:
        dotnet-version: '6.x'

    - name: Restore NuGet packages
      shell: bash
      run: |
        dotnet restore .

    - name: Build solution
      shell: bash
      run: |
        dotnet build . -c Release

    - name: Test solution
      shell: bash
      run: |
        dotnet test . -c Release

    - name: Create FunctionApp artifact
      shell: bash
      run: |
        pushd "${{ env.FUNCTION_APP_PATH }}"
        dotnet publish . -c Release -o published
        popd

    - name: Upload FunctionApp artifact
      uses: actions/upload-artifact@v2
      with:
        name: apiapp
        path: ${{ env.FUNCTION_APP_PATH }}/published

  app_deploy_azure:
    name: 'Deploy to Azure'
    needs: build_test

    runs-on: ubuntu-latest

    steps:
    - name: Set environment variables
      shell: bash
      run: |
        echo "RESOURCE_GROUP_NAME=rg-${{ secrets.resource_group_name }}" >> $GITHUB_ENV
        echo "FUNCTION_APP_PATH=${{ github.workspace }}/published" >> $GITHUB_ENV
        echo "FUNCTION_APP_NAME=fncapp-${{ secrets.resource_name }}-dev-api" >> $GITHUB_ENV

    # - name: Check environment variables
    #   shell: bash
    #   run: |
    #     echo $RESOURCE_GROUP_NAME
    #     echo $FUNCTION_APP_PATH
    #     echo $FUNCTION_APP_NAME

    - name: Download FunctionApp artifact
      uses: actions/download-artifact@v2
      with:
        name: apiapp
        path: ${{ env.FUNCTION_APP_PATH }}

    - name: Login to Azure
      uses: Azure/login@v1
      with:
        creds: ${{ secrets.AZURE_CREDENTIALS }}

    - name: Get FunctionApp publish profile
      id: publishprofile
      uses: aliencube/publish-profile-actions@v1
      env:
        AZURE_CREDENTIALS: ${{ secrets.AZURE_CREDENTIALS }}
      with:
        resourceGroupName: ${{ env.RESOURCE_GROUP_NAME }}
        appName: ${{ env.FUNCTION_APP_NAME }}

    - name: Deploy FunctionApp
      uses: Azure/functions-action@v1
      with:
        app-name: ${{ env.FUNCTION_APP_NAME }}
        package: ${{ env.FUNCTION_APP_PATH }}
        publish-profile: ${{ steps.publishprofile.outputs.profile }}

    - name: Reset FunctionApp publish profile
      uses: aliencube/publish-profile-actions@v1
      env:
        AZURE_CREDENTIALS: ${{ secrets.AZURE_CREDENTIALS }}
      with:
        resourceGroupName: ${{ env.RESOURCE_GROUP_NAME }}
        appName: ${{ env.FUNCTION_APP_NAME }}
        reset: true
```


## 깃헙 액션 워크플로우 리팩토링 ##

### 풀리퀘스트 ###

TBD

### 애저로 배포하기 ###

TBD
