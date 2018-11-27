#!/bin/bash
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

show_help() {
cat << EOF
Usage: add_item_to_rss_feed.sh [-d -f] articles/example-article.html

Adds an item to rss feed file based on html meta tags and automatically
updates its pubDate and lastBuildDate fields.

    -b, --lastbuilddate
        Value for lastBuildDate for feed.

        Default: result of date -Ru

    -d, --description
        Value for description of the item.

        Default: content attribute of description meta tag in html document

    -f, --feed-file
        Feed file to add item to.
        Can be configured in .ryjo.conf file like so:

        RYJO_RSS_FEED_FILE=rss.xml

        Default: feed.rss

    -g, --guid
        Value for guid field for item.

        Default: \$RYJO_SITE_URL\$1

    -l, --link
        Value for link field for item.

        Default: \$RYJO_SITE_URL\$1

    -p, --pubdate
        Value for pubDate for the item.

        Default: result of date -Ru

    -t, --title
        Value for title of the item.

        Default: content attribute of title meta tag in html document

EOF
}

RYJO_RSS_FEED_FILE="feed.rss"
if [ -e "./.ryjo.conf" ]
then
  source "./.ryjo.conf"
fi

while :; do
  case "$1" in 
    -b|--lastbuilddate)
      if [ "$2" ]
      then
        RYJO_RSS_FEED_ITEM_LASTBUILDDATE="$2"
        shift
      else
        echo "-l or --lastbuilddate requires a non-empty argument"
        exit 1;
      fi
      ;;
    --lastbuilddate=?*)
      RYJO_RSS_FEED_ITEM_LASTBUILDDATE=${1#*=}
      ;;
    --lastbuilddate=)
      echo "-l or --lastbuilddate requires a non-empty argument"
      exit 1;
      ;;
    -d|--description)
      if [ "$2" ]
      then
        RYJO_RSS_FEED_ITEM_DESCRIPTION="$2"
        shift
      else
        echo "-d or --description requires a non-empty argument"
        exit 1;
      fi
      ;;
    --description=?*)
      RYJO_RSS_FEED_ITEM_DESCRIPTION=${1#*=}
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
    -g|--guid)
      if [ "$2" ]
      then
        RYJO_RSS_FEED_ITEM_GUID="$2"
        shift
      else
        echo "-g or --guid requires a non-empty argument"
        exit 1;
      fi
      ;;
    --guid=?*)
      RYJO_RSS_FEED_ITEM_GUID=${1#*=}
      ;;
    --guid=)
      echo "-g or --guid requires a non-empty argument"
      exit 1;
      ;;
    -h|--help)
      show_help
      exit
      ;;
    -l|--link)
      if [ "$2" ]
      then
        RYJO_RSS_FEED_ITEM_LINK="$2"
        shift
      else
        echo "-l or --link requires a non-empty argument"
        exit 1;
      fi
      ;;
    --link=?*)
      RYJO_RSS_FEED_ITEM_LINK=${1#*=}
      ;;
    --link=)
      echo "-l or --link requires a non-empty argument"
      exit 1;
      ;;
    -p|--pubdate)
      if [ "$2" ]
      then
        RYJO_RSS_FEED_ITEM_PUBDATE="$2"
        shift
      else
        echo "-p or --pubdate requires a non-empty argument"
        exit 1;
      fi
      ;;
    --pubdate=?*)
      RYJO_RSS_FEED_ITEM_PUBDATE=${1#*=}
      ;;
    --pubdate=)
      echo "-p or --pubdate requires a non-empty argument"
      exit 1;
      ;;
    -t|--title)
      if [ "$2" ]
      then
        RYJO_RSS_FEED_ITEM_TITLE="$2"
        shift
      else
        echo "-t or --title requires a non-empty argument"
        exit 1;
      fi
      ;;
    --title=?*)
      RYJO_RSS_FEED_ITEM_TITLE=${1#*=}
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

if [ ! -e "$1" ]
then
  echo "$1 does not exist!"
  exit 1;
fi

current_date_timestamp=$(date -Ru)

if [ ! -e "$RYJO_RSS_FEED_FILE" ]
then
  echo "Feed file $RYJO_RSS_FEED_FILE does not exist! Create one with init_rss_feed.sh, configure where it is in .ryjo.conf or pass its path to this command with -f."
  exit 1;
fi

if [ ! "$RYJO_RSS_FEED_ITEM_DESCRIPTION" ]
then
  RYJO_RSS_FEED_ITEM_DESCRIPTION=$(awk 'match($0, /<meta name="description" content="(.*)"/, a) {print a[1]; exit}' "$1")
fi

if [ ! "$RYJO_RSS_FEED_ITEM_GUID" ]
then
  RYJO_RSS_FEED_ITEM_GUID="$RYJO_SITE_URL$1"
fi

if [ ! "$RYJO_RSS_FEED_ITEM_LASTBUILDDATE" ]
then
  RYJO_RSS_FEED_ITEM_LASTBUILDDATE="$current_date_timestamp"
fi

if [ ! "$RYJO_RSS_FEED_ITEM_LINK" ]
then
  RYJO_RSS_FEED_ITEM_LINK=$RYJO_SITE_URL$1
fi

if [ ! "$RYJO_RSS_FEED_ITEM_PUBDATE" ]
then
  RYJO_RSS_FEED_ITEM_PUBDATE="$current_date_timestamp"
fi


if [ ! "$RYJO_RSS_FEED_ITEM_TITLE" ]
then
  RYJO_RSS_FEED_ITEM_TITLE=$(awk 'match($0, /<meta name="title" content="(.*)"/, a) {print a[1]; exit}' "$1")
fi

ITEM_XML="    <item>\n      <title>$RYJO_RSS_FEED_ITEM_TITLE</title>\n      <description>$RYJO_RSS_FEED_ITEM_DESCRIPTION</description>\n      <link>$RYJO_RSS_FEED_ITEM_LINK</link>\n      <guid>$RYJO_RSS_FEED_ITEM_GUID</guid>\n      <pubDate>$RYJO_RSS_FEED_ITEM_PUBDATE</pubDate>\n    </item>"

sed -i "0,/\(\s*\(<item>\|<\/channel>\)\)/s||${ITEM_XML}\n\1|" "$PWD/$RYJO_RSS_FEED_FILE"
sed -i "0,/<lastBuildDate>.*<\/lastBuildDate>/s||<lastBuildDate>${RYJO_RSS_FEED_ITEM_LASTBUILDDATE}<\/lastBuildDate>|" "$PWD/$RYJO_RSS_FEED_FILE"
sed -i "0,/<pubDate>.*<\/pubDate>/s||<pubDate>${RYJO_RSS_FEED_ITEM_PUBDATE}<\/pubDate>|" "$PWD/$RYJO_RSS_FEED_FILE"
