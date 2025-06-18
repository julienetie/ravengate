package main

import (
	"fmt"
	"log"
	"net/http"

	"github.com/julienetie/ravengate/internal/api"
)

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Hello from Ravengate!")
	})

	http.HandleFunc("/api/messages", api.GetMessages)
	http.HandleFunc("/api/send", api.SendMessage)

	fmt.Println("Ravengate server starting on :8080")
	log.Fatal(http.ListenAndServe(":8080", nil))
}
