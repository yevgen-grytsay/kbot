package app

import (
	telebot "gopkg.in/telebot.v3"
)

type HandlerSet struct {
	HandlerFunc        telebot.HandlerFunc
	MiddlewareFuncList []telebot.MiddlewareFunc
}

var CommandHandlersConfig = map[string]HandlerSet{
	"/echo": {
		HandlerFunc: EchoCommandHandler,
	},
	telebot.OnText: {
		HandlerFunc: OnTextCommandHandler,
	},
}
