#!/bin/bash

echo "Just FYI: You'll need sudo priviledges since we're removing things in /usr/local/bin"

sudo unlink /usr/local/bin/publish.sh

echo "Great! Those three symlinks have been removed."
