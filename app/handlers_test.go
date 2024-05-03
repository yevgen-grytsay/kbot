package app

import (
	"testing"

	gomock "go.uber.org/mock/gomock"

	telebot "gopkg.in/telebot.v3"

	mock "github.com/yevgen-grytsay/kbot/tests"
)

func TestEchoCommandHandler(t *testing.T) {
	ctrl := gomock.NewController(t)
	defer ctrl.Finish()

	message := telebot.Message{Payload: "Hello!"}

	context := mock.NewMockContext(ctrl)
	context.EXPECT().Message().AnyTimes().Return(&message)
	context.EXPECT().Text().AnyTimes()
	context.EXPECT().Send("Bot says: Hello!")

	EchoCommandHandler(context)
}
