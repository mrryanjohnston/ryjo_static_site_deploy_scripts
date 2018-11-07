#!/bin/bash

echo "Just FYI: You'll need sudo priviledges since we're removing things in /usr/local/bin"

sudo unlink /usr/local/bin/add_item_to_rss_feed.sh
sudo unlink /usr/local/bin/init_rss_feed.sh
sudo unlink /usr/local/bin/publish.sh
sudo unlink /usr/local/bin/ryjo.sh

echo "Great! Those three symlinks have been removed."
