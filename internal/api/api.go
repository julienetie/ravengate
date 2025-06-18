package api

import (
	"encoding/json"
	"net/http"

	"github.com/julienetie/ravengate/internal/smtp"
)

func GetMessages(w http.ResponseWriter, r *http.Request) {
	messages := []map[string]string{
		{"id": "1", "subject": "Test Email", "from": "test@example.com"},
		{"id": "2", "subject": "Another Email", "from": "user@example.com"},
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(messages)
}

func SendMessage(w http.ResponseWriter, r *http.Request) {
	var req struct {
		To      string `json:"to"`
		Subject string `json:"subject"`
		Body    string `json:"body"`
	}

	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid JSON", http.StatusBadRequest)
		return
	}

	err := smtp.SendEmail(req.To, req.Subject, req.Body)
	if err != nil {
		http.Error(w, "Failed to send email", http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(map[string]string{"status": "sent"})
}
