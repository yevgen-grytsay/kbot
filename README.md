# kbot

Link [yevhenhrytsai_bot](https://t.me/yevhenhrytsai_bot)

Commands:
- `/start hello`
- `/echo <message>`


## make

### make image

Щоб створити образ для потрібної архітектури, використовуйте змінні `TARGETOS` та `TARGETARCH`. Приклад:
```sh
make image TARGETOS=windows TARGETARCH=arm64
```

### build
```sh
TARGETOS=windows TARGETARCH=arm64 make build
```

## Інсталювати за допомогою helm-чарту
```sh
k3d cluster create kbot-cluster \
    --registry-config /home/yevhen/.k3d/registries.yaml \
    --agents=3

helm install kbot-init ./helm/ --set secret.tokenValue=$(echo $TELE_TOKEN | tr -d '\n' | base64)
```

## Run tests
```sh
go test ./...
```

## Resources
- [gopkg.in](https://labix.org/gopkg.in)
- [gopkg.in/telebot.v3](https://gopkg.in/telebot.v3)
- [Golang: Optional environment variables](https://go.dev/doc/install/source#environment)
- [Docker: Build variables](https://docs.docker.com/build/building/variables/)
- [Kubernetes | Define container environment variables using Secret data](https://kubernetes.io/docs/tasks/inject-data-application/distribute-credentials-secure/#define-container-environment-variables-using-secret-data)
- [Docker login-action](https://github.com/docker/login-action)
