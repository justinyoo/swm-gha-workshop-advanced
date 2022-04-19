# 앱 배포 오토파일럿 #

## 로컬 앱 환경 설정 및 실행 ##

* `local.settings.sample.json` ➡️ `local.settings.json`

```bash
dotnet restore .
dotnet build .

cd api
func start
```


## 오토파일럿 ##

[![Deploy To Azure](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.svg?sanitize=true)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fjustinyoo%2Fswm-gha-workshop-advanced%2Fmain%2Finfra%2Fazuredeploy.json)
