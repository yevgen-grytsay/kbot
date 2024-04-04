# kbot

Link [yevhenhrytsai_bot](https://t.me/yevhenhrytsai_bot)

Commands:
- `/start hello`
- `/say <message>`


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


## Resources
- [gopkg.in](https://labix.org/gopkg.in)
- [gopkg.in/telebot.v3](https://gopkg.in/telebot.v3)
