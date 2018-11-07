#!/bin/bash
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

show_help() {
cat << EOF
Usage: init_rss_feed.sh

Creates skeleton rss feed file.
Can be configured with config file .ryjo.conf in present working directory.
The following could be your default configuration:

    -d, --description
        Value for description in feed file.
        Can be configured in .ryjo.conf file like so:

        RYJO_RSS_FEED_DESCRIPTION=foo.xml

    -f, --feed-file
        Feed file to add item to.
        Can be configured in .ryjo.conf file like so:

        RYJO_RSS_FEED_FILE=rss.xml

        Default: feed.rss

    -l, --language
        Value for language in feed file.
        Can be configured in .ryjo.conf file like so:

        RYJO_RSS_FEED_LANGUAGE=es

        Default: en

    -s, --site-url
        Value for link in feed file.
        Can be configured in .ryjo.conf file like so:

        RYJO_SITE_URL=https://example.com

    -t, --title
        Value for title in feed file.
        Can be configured in .ryjo.conf file like so:

        RYJO_RSS_FEED_TITLE="Example Feed"

EOF
}

RYJO_RSS_FEED_FILE="feed.rss"
RYJO_RSS_FEED_LANGUAGE="en"
if [ -e "./.ryjo.conf" ]
then
  source "./.ryjo.conf"
fi

while :; do
  case "$1" in 
    -d|--description)
      if [ "$2" ]
      then
        RYJO_RSS_FEED_DESCRIPTION="$2"
        shift
      else
        echo "-d or --description requires a non-empty argument"
        exit 1;
      fi
      ;;
    --description=?*)
      RYJO_RSS_FEED_DESCRIPTION=${1#*=}
      ;;
    --description=)
      echo "-d or --description requires a non-empty argument"
      exit 1;
      ;;
    -f|--feed-file)
      if [ "$2" ]
      then
        RYJO_RSS_FEED_FILE="$2"
        shift
      else
        echo "-f or --feed-file requires a non-empty argument"
        exit 1;
      fi
      ;;
    --feed-file=?*)
      RYJO_RSS_FEED_FILE=${1#*=}
      ;;
    --feed-file=)
      echo "-f or --feed-file requires a non-empty argument"
      exit 1;
      ;;
    -h|--help)
      show_help
      exit
      ;;
    -l|--language)
      if [ "$2" ]
      then
        RYJO_RSS_FEED_LANGUAGE="$2"
        shift
      else
        echo "-l or --language requires a non-empty argument"
        exit 1;
      fi
      ;;
    --language=?*)
      RYJO_RSS_FEED_LANGUAGE=${1#*=}
      ;;
    --language=)
      echo "-l or --language requires a non-empty argument"
      exit 1;
      ;;
    -s|--site-url)
      if [ "$2" ]
      then
        RYJO_SITE_URL="$2"
        shift
      else
        echo "-s or --site-url requires a non-empty argument"
        exit 1;
      fi
      ;;
    --site-url=?*)
      RYJO_SITE_URL=${1#*=}
      ;;
    --site-url=)
      echo "-s or --site-url requires a non-empty argument"
      exit 1;
      ;;
    -t|--title)
      if [ "$2" ]
      then
        RYJO_RSS_FEED_TITLE="$2"
        shift
      else
        echo "-t or --title requires a non-empty argument"
        exit 1;
      fi
      ;;
    --title=?*)
      RYJO_RSS_FEED_TITLE=${1#*=}
      ;;
    --title=)
      echo "-t or --title requires a non-empty argument"
      exit 1;
      ;;
    --)
      shift
      break
      ;;
    *)
      break
  esac

  shift
done

current_date_timestamp=$(date -Ru)
echo "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>
<rss version=\"2.0\">
  <channel>
    <title>$RYJO_RSS_FEED_TITLE</title>
    <description>$RYJO_RSS_FEED_DESCRIPTION</description>
    <link>$RYJO_SITE_URL</link>
    <language>$RYJO_RSS_FEED_LANGUAGE</language>
    <lastBuildDate>$current_date_timestamp</lastBuildDate>
    <pubDate>$current_date_timestamp</pubDate>
  </channel>
</rss>" > "$PWD/$RYJO_RSS_FEED_FILE"
