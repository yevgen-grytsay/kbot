package app

import (
	"fmt"
	"log"

	telebot "gopkg.in/telebot.v3"
)

var EchoCommandHandler = func(ctx telebot.Context) error {
	payload := ctx.Message().Payload
	if payload == "" {
		return nil
	}

	return ctx.Send(fmt.Sprintf("Bot says: %s", payload))
}

var OnTextCommandHandler = func(ctx telebot.Context) (err error) {

	log.Print(ctx.Message().Payload, ctx.Text())
	payload := ctx.Message().Payload

	switch payload {
	case "hello":
		err = ctx.Send(fmt.Sprintf("Hello I'm kbot %s", AppVersion))
	}

	return err
}
