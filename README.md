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

## Resources
- [gopkg.in](https://labix.org/gopkg.in)
- [gopkg.in/telebot.v3](https://gopkg.in/telebot.v3)
