#!/bin/bash

(
    sleep 0.2
    echo "EHLO localhost"
    sleep 0.2
    echo "MAIL FROM:<j8@paralot.org>"
    sleep 0.2
    echo "RCPT TO:<julius@localhost>"
    sleep 0.2
    echo "DATA"
    sleep 0.2
    echo "Subject: Test Email"
    echo "From: test@example.com"
    echo "To: receiver@example.com"
    echo ""
    echo "This is a test email sent using telnet with short fractional sleeps."
    echo "."
    sleep 0.2
    echo "QUIT"
) | telnet localhost 2525
