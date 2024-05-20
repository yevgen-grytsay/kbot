package app

import (
	"fmt"
	"log"

	telebot "gopkg.in/telebot.v3"
)

var EchoCommandHandler = func(ctx telebot.Context) error {
	log.Print(ctx.Message().Payload, ctx.Text())

	payload := ctx.Message().Payload
	if payload == "" {
		return nil
	}

	return ctx.Send(fmt.Sprintf("Bot says: %s", payload))
}

var RollDiceCommandHandler = func(ctx telebot.Context) error {
	log.Print(ctx.Message().Payload, ctx.Text())

	result := RollDice(ctx.Sender().Username)

	return ctx.Send(result)
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

var VersionCommandHandler = func(ctx telebot.Context) (err error) {
	log.Printf("Version: %s", AppVersion)

	err = ctx.Send(AppVersion)

	return err
}
