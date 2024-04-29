# Notes

## Cobra CLI
https://github.com/spf13/cobra-cli

```sh
~/go/bin/cobra-cli add <new-command>

```

## Комбінації `GOOS` та `GOARCH`
[docs](https://go.dev/doc/install/source#environment)
```
$ go tool dist list
aix/ppc64
android/386
android/amd64
android/arm
android/arm64
darwin/amd64
darwin/arm64
dragonfly/amd64
freebsd/386
freebsd/amd64
freebsd/arm
freebsd/arm64
freebsd/riscv64
illumos/amd64
ios/amd64
ios/arm64
js/wasm
linux/386
linux/amd64
linux/arm
linux/arm64
linux/loong64
linux/mips
linux/mips64
linux/mips64le
linux/mipsle
linux/ppc64
linux/ppc64le
linux/riscv64
linux/s390x
netbsd/386
netbsd/amd64
netbsd/arm
netbsd/arm64
openbsd/386
openbsd/amd64
openbsd/arm
openbsd/arm64
openbsd/ppc64
plan9/386
plan9/amd64
plan9/arm
solaris/amd64
wasip1/wasm
windows/386
windows/amd64
windows/arm
windows/arm64
```

## Dev Notes

```sh
go build -ldflags="-X="github.com/yevgen-grytsay/kbot/app.AppVersion=v1.0.0
```

```sh
gofmt -s -w ./
```

Щоб в історії команд не залишити sensitive дані:
```sh
read -s TELE_TOKEN
export TELE_TOKEN
```

Подивитися архітектуру бінарника:
```sh
# arm64
$ file ./kbot 
./kbot: ELF 64-bit LSB executable, ARM aarch64, version 1 (SYSV), statically linked, Go BuildID=dFUkN9gBrewkchuNLQel/jHQoD8nCG19muqABdANI/MyD6bEGfVTg7pkrlv_ln/ksh8tS5dFXJu4Sm0Y-zA, with debug_info, not stripped

# amd64
file ./kbot 
./kbot: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), statically linked, Go BuildID=difsgrmEqQwNcFjKB23t/zbYpMcL0C92OhTP4i_wq/EKF8uqFXJfxzP95wFk_2/Kfz--gpAmfZnNOn_t9yB, with debug_info, not stripped
```


Щоб зробити імедж неефективним з точки зору наших правил `dive` (`dive --ci --lowestEfficiency=0.9 <image>`):
```Dockerfile
FROM ubuntu:22.04
...
RUN apt-get update && apt-get upgrade -y
```


## Helm

### Helm upgrade

```sh
$ kubectl get all
NAME                             READY   STATUS    RESTARTS   AGE
pod/kbot-init-56f6f77f77-vlgr5   1/1     Running   0          70s

NAME                        READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/kbot-init   1/1     1            1           70s

NAME                                   DESIRED   CURRENT   READY   AGE
replicaset.apps/kbot-init-56f6f77f77   1         1         1       70s


$ helm upgrade kbot-init ./helm/ --set secret.tokenValue=$(echo $TELE_TOKEN | tr -d '\n' | base64)
Release "kbot-init" has been upgraded. Happy Helming!
NAME: kbot-init
LAST DEPLOYED: Sun Apr 21 16:03:59 2024
NAMESPACE: kbot
STATUS: deployed
REVISION: 2
TEST SUITE: None


$ kubectl get all
NAME                             READY   STATUS    RESTARTS   AGE
pod/kbot-init-7884557677-847xm   1/1     Running   0          53s

NAME                        READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/kbot-init   1/1     1            1           6m14s

NAME                                   DESIRED   CURRENT   READY   AGE
replicaset.apps/kbot-init-7884557677   1         1         1       53s
replicaset.apps/kbot-init-56f6f77f77   0         0         0       6m14s


$ helm ls
NAME            NAMESPACE       REVISION        UPDATED                                         STATUS          CHART           APP VERSION
kbot-init       kbot            2               2024-04-21 16:03:59.204850282 +0300 EEST        deployed        kbot-0.1.0      1.16.0
```

## Create Github release
```sh
$ gh release create
https://github.com/yevgen-grytsay/kbot/releases/tag/v1.0.2


$ gh release list
TITLE   TYPE    TAG NAME  PUBLISHED             
v1.0.2  Latest  v1.0.2    less than a minute ago


$ helm package ./helm/
Successfully packaged chart and saved it to: /home/yevhen/Dev/Prometheus DevOps/kbot/kbot-0.1.1.tgz


$ gh release upload v1.0.2 kbot-0.1.1.tgz
Successfully uploaded 1 asset to v1.0.2
```

## Змінити версію `go`
```sh
go mod edit -go=1.20
```


## Kubernetes

```sh
k3d cluster create kbot-cluster --registry-config /home/yevhen/.k3d/registries.yaml


read -s TELE_TOKEN
export TELE_TOKEN
kubectl create secret generic kbot-secret --from-literal=token="$TELE_TOKEN"

kubectl apply -f yaml/kbot.yaml

kubectl exec -i -t kbot -- /bin/sh -c 'echo $TELE_TOKEN'
```

## Helm
```sh
$ helm create helm
```
`1.1.1.1` -- DNS від Cloudflare

## Tests
### Generate mock files
```sh
$ go install go.uber.org/mock/mockgen@latest

$ go list -m all | grep mock
go.uber.org/mock v0.4.0

$ mockgen gopkg.in/telebot.v3 Context > tests/telebot_mocks.go
```


## Dive CI/CD
```yaml
- name: Image full name
    id: image-full-name
    run: echo "name=$(make image-tag)" >> "$GITHUB_OUTPUT"

- name: Dive
    uses: ${{ steps.image-full-name.name }}
```


## Configure the workload identity federation for GitHub Actions in Google Cloud

Docs:
- [Workload Identity Federation through a Service Account](https://github.com/google-github-actions/auth#workload-identity-federation-through-a-service-account)
- [Examples | Workload Identity Federation through a Service Account](https://github.com/google-github-actions/auth/blob/main/docs/EXAMPLES.md#workload-identity-federation-through-a-service-account)
- [Security Considerations](https://github.com/google-github-actions/auth/blob/main/docs/SECURITY_CONSIDERATIONS.md)

Далі йдуть кроки з [документації](https://github.com/google-github-actions/auth#workload-identity-federation-through-a-service-account) з моїми правками.

1. Create a Google Cloud Service Account.
```sh
PROJECT_ID=my-project-id

$ gcloud iam service-accounts create "github-service-account" \
    --project "${PROJECT_ID}"
```

2. Create a Workload Identity Pool:
```sh
gcloud iam workload-identity-pools create "github" \
    --project="${PROJECT_ID}" \
    --location="global" \
    --display-name="GitHub Actions Pool"
```


3. Get the full ID of the Workload Identity Pool:
```sh
gcloud iam workload-identity-pools describe "github" \
    --project="${PROJECT_ID}" \
    --location="global" \
    --format="value(name)"
```

4. Create a Workload Identity Provider in that pool:
[Security Considerations](https://github.com/google-github-actions/auth/blob/main/docs/SECURITY_CONSIDERATIONS.md)

Щоб отримати id репозиторію та id власника репозиторію:
```sh
curl -L \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    https://api.github.com/repos/yevgen-grytsay/kbot | jq .id,.owner.id
```

В наступній команді я змінив значення `--attribute-mapping` та `--attribute-condition`.
- до `--attribute-condition` додав рекомендовані перевірки ([Security Considerations](https://github.com/google-github-actions/auth/blob/main/docs/SECURITY_CONSIDERATIONS.md)).
- до `--attribute-mapping` додав мапінг `attribute.repository_id=assertion.repository_id` для того, щоб в `--attribute-condition` можна було використовувати цей параметр `assertion.repository_id`

> ❗️ IMPORTANT You must map any claims in the incoming token to attributes before you can assert on those attributes in a CEL expression or IAM policy!

Створити Workload Identity Provider:
```sh
gcloud iam workload-identity-pools providers create-oidc "kbot-repo" \
    --project="${PROJECT_ID}" \
    --location="global" \
    --workload-identity-pool="github" \
    --display-name="My GitHub repo Provider" \
    --attribute-mapping="google.subject=assertion.sub,attribute.actor=assertion.actor,attribute.repository=assertion.repository,attribute.repository_owner_id=assertion.repository_owner_id,attribute.repository_id=assertion.repository_id" \
    --attribute-condition="assertion.repository_owner_id == '675875' && assertion.repository_id == '776821562'" \
    --issuer-uri="https://token.actions.githubusercontent.com"
```

5. Allow authentications from the Workload Identity Pool to your Google Cloud Service Account.
```sh
WORKLOAD_IDENTITY_POOL_ID=my-workload-pool-id
REPO="yevgen-grytsay/kbot"

gcloud iam service-accounts add-iam-policy-binding "github-service-account@${PROJECT_ID}.iam.gserviceaccount.com" \
    --project="${PROJECT_ID}" \
    --role="roles/iam.workloadIdentityUser" \
    --member="principalSet://iam.googleapis.com/${WORKLOAD_IDENTITY_POOL_ID}/attribute.repository/${REPO}"
```

6. Extract the Workload Identity Provider resource name:
```sh
gcloud artifacts repositories add-iam-policy-binding "k8s-k3s" \
    --project="${PROJECT_ID}" \
    --role="roles/artifactregistry.writer" \
    --member="serviceAccount:github-service-account@${PROJECT_ID}.iam.gserviceaccount.com" \
    --location=us-central1
```


```yaml
jobs:
  ci:
    permissions:
      contents: "read"
      id-token: "write"
    
    steps:
      - name: Authenticate to Google Cloud
        id: auth
        uses: google-github-actions/auth@v2
        with:
          token_format: access_token
          workload_identity_provider: ${{ secrets.GCP_WORKLOAD_IDENTITY_PROVIDER }} # "projects/123456789/locations/global/workloadIdentityPools/github/providers/kbot-repo"
          service_account: ${{ secrets.GCP_SERVICE_ACCOUNT }} # github-service-account@my-project.iam.gserviceaccount.com

      - name: Login to GAR
        uses: docker/login-action@v3
        with:
          registry: ${{ secrets.GAR_REGISTRY }}
          username: oauth2accesstoken
          password: ${{ steps.auth.outputs.access_token }}
```

## Jenkins

apt install default-jre

go, gofmt in PATH

Plugins:
- SSH Build Agents plugin
- Docker Pipeline

Allow user jenkins to run docker commands:
https://docs.docker.com/engine/install/linux-postinstall/


## GitLab
https://docs.gitlab.com/ee/tutorials/create_register_first_runner/index.html


You can configure a project, group, or instance CI/CD variable to be available only to pipelines that run on protected branches or protected tags. 
https://docs.gitlab.com/ee/ci/variables/index.html#protect-a-cicd-variable


Configure a list of selectable prefilled variable values
https://docs.gitlab.com/ee/ci/pipelines/index.html#configure-a-list-of-selectable-prefilled-variable-values


https://docs.gitlab.com/ee/ci/docker/using_docker_build.html


https://docs.gitlab.com/runner/register/


https://docs.gitlab.com/ee/user/packages/container_registry/authenticate_with_container_registry.html


## References

https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect#understanding-the-oidc-token


https://cloud.google.com/iam/docs/workload-identity-federation#mapping


https://github.com/google-github-actions/auth/blob/main/docs/SECURITY_CONSIDERATIONS.md


https://cloud.google.com/iam/docs/overview?hl=en