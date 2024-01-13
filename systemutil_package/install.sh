#!/bin/bash

# Copy systemutil script to /usr/local/bin
sudo cp systemutil /usr/local/bin/

# Copy man page to /usr/share/man/man1
sudo cp systemutil.1 /usr/share/man/man1/

# Update man database
sudo mandb

echo "systemutil has been installed successfully."

