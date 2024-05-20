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
	"/rolldice": {
		HandlerFunc: RollDiceCommandHandler,
		Alias:       []string{"/roll", "/rd"},
	},
	telebot.OnText: {
		HandlerFunc: OnTextCommandHandler,
	},
}
