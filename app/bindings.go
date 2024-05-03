package app

import (
	telebot "gopkg.in/telebot.v3"
)

type HandlerSet struct {
	HandlerFunc        telebot.HandlerFunc
	MiddlewareFuncList []telebot.MiddlewareFunc
	Alias              []string
}

var CommandHandlersConfig = map[string]HandlerSet{
	"/echo": {
		HandlerFunc: EchoCommandHandler,
	},
	"/version": {
		HandlerFunc: VersionCommandHandler,
		Alias:       []string{"/ver", "/v"},
	},
	telebot.OnText: {
		HandlerFunc: OnTextCommandHandler,
	},
}
