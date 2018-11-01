#!/bin/bash

echo "Just FYI: You'll need sudo priviledges since we're installing things in /usr/local/bin"

sudo ln -s "$PWD/publish.sh" /usr/local/bin/

echo "Great! Now you can access these tools from any directory."
