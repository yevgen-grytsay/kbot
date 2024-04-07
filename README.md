# kbot

Link [yevhenhrytsai_bot](https://t.me/yevhenhrytsai_bot)

Commands:
- `/start hello`
- `/say <message>`


## Cobra CLI
https://github.com/spf13/cobra-cli

```sh
~/go/bin/cobra-cli add <new-command>

```

## Dev Notes

```sh
go build -ldflags="-X="github.com/yevgen-grytsay/kbot/cmd.appVersion=v1.0.0
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


### Комбінації `GOOS` та `GOARCH`
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

## Створення образу
Щоб створити образ для потрібної архітектури, використовуйте змінні `TARGETOS` та `TARGETARCH`. Приклад:
```sh
make image TARGETOS=windows TARGETARCH=arm64
```

## Змінити версію `go`
```sh
go mod edit -go=1.20
```

## Resources
- [gopkg.in](https://labix.org/gopkg.in)
- [gopkg.in/telebot.v3](https://gopkg.in/telebot.v3)
- [Golang: Optional environment variables](https://go.dev/doc/install/source#environment)
- [Docker: Build variables](https://docs.docker.com/build/building/variables/)