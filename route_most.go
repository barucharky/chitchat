package main

import (
	"fmt"
	"net/http"

	"github.com/barucharky/chitchat/data"
)

func most(writer http.ResponseWriter, request *http.Request) {
	mosts, err := data.Mosts()
	fmt.Println("Here are the mosts", mosts)
	if err != nil {
		error_message(writer, request, "Cannot get mosts")
	} else {
		_, err := session(writer, request)
		if err != nil {
			generateHTML(writer, mosts, "layout", "public.navbar", "mosts")
		} else {
			generateHTML(writer, mosts, "layout", "private.navbar", "mosts")
		}
	}
}
