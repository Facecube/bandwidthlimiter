#!/bin/bash

# Read the request line (e.g., GET /dummy HTTP/1.1)
read -r REQUEST_LINE

# Read all headers until we hit an empty line (\r\n)
CONTENT_LENGTH=0
while read -r HEADER; do
    # Strip trailing \r
    HEADER="${HEADER%%$'\r'}"
    # Break on empty line (end of headers)
    [ -z "$HEADER" ] && break
    # Capture Content-Length if present
    if [[ "$HEADER" =~ ^[Cc]ontent-[Ll]ength:\ *([0-9]+) ]]; then
        CONTENT_LENGTH="${BASH_REMATCH[1]}"
    fi
done

echo "Handling request with content length: $CONTENT_LENGTH" >&2

# Fully consume the request body based on Content-Length
if [ "$CONTENT_LENGTH" -gt 0 ] 2>/dev/null; then
    dd bs=1 count="$CONTENT_LENGTH" of=/dev/null 2>/dev/null
fi

# Build the response body
BODY='{"status":"ok","message":"request fully consumed"}'
BODY_LENGTH=${#BODY}

# Send the HTTP response
printf "HTTP/1.1 200 OK\r\n"
printf "Content-Type: application/json\r\n"
printf "Content-Length: %d\r\n" "$BODY_LENGTH"
printf "Connection: close\r\n"
printf "\r\n"
printf "%s" "$BODY"
