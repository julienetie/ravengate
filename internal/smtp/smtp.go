package smtp

import "fmt"

func SendEmail(to, subject, body string) error {
	fmt.Printf("Sending email to: %s, subject: %s\n", to, subject)
	// Dummy implementation
	return nil
}
