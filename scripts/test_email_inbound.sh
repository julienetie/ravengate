#!/bin/bash

current_date=$(date -R) # RFC 2822 format

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
    echo "Received: from testhost.local (localhost [127.0.0.1]) by mx.paralot.org with ESMTP id TEST12345 for <julius@localhost>; $current_date"
    echo "Date: $current_date"
    echo "From: j8@paralot.org"
    echo "To: julius@localhost"
    echo "Subject: Test Email"
    echo "User-Agent: BashTelnetMailer/0.1"
    echo ""
    echo "This is a test email sent using telnet with proper headers."
    echo "."
    sleep 0.2
    echo "QUIT"
) | openssl s_client -connect localhost:2525 -starttls smtp -crlf -quiet
