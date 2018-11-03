#!/bin/bash
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

show_help() {
cat << EOF
Usage: publish.sh [-b -c -s] FILE...

Publish files to s3 bucket.
Can be configured with config file .ryjo.conf in present working directory.

    -b, --bucket-name
        Bucket name to publish to.
        Can be configured in .ryjo.conf file like so:

        RYJO_BUCKET=foo.bar.com

        Default: current working directory.

    -c, --cache-control-max-age
        Change the Cache-Control maxage header for these files.
        Can be configured in .ryjo.conf file like so:

        RYJO_CACHE_CONTROL_MAX_AGE=3600

        Default: 86400 (seconds, which is 1 day)

    -h, --help
        Display this help file.

    -s, --silent
        Don't display output. Helpful if you want to use this within other scripts.

    -t, --content-type
        Override the automatically detected Content-Type for these files.

        Default: automatically detected, falls back on RYJO_DEFAULT_CONTENT_TYPE
        (which is text/plain by default).

        Note:
        This just uses the file's extension because using file or magic to
        detect it can return unexpected results for css. If it is not found in
        the (very short) list of supported extensions, it'll use the default
        configured mimetype:

        RYJO_DEFAULT_CONTENT_TYPE=text/html

EOF
}

RYJO_BUCKET="${PWD##*/}"
RYJO_CACHE_CONTROL_MAX_AGE=86400
RYJO_DEFAULT_CONTENT_TYPE="text/plain"
if [ -e "./.ryjo.conf" ]
then
  source "./.ryjo.conf"
fi

silent=false

while :; do
  case "$1" in 
    -b|--bucket)
      if [ "$2" ]
      then
        RYJO_BUCKET="$2"
        shift
      else
        echo "-b or --bucket requires a non-empty argument"
        exit 1;
      fi
      ;;
    --bucket=?*)
      RYJO_BUCKET=${1#*=}
      ;;
    --bucket=)
      echo "-b or --bucket requires a non-empty argument"
      exit 1;
      ;;
    -c|--cache-control-max-age)
      if [ "$2" ]
      then
        RYJO_CACHE_CONTROL_MAX_AGE="$2"
        shift
      else
        echo "-c or --cache-control-max-age requires a non-empty argument"
        exit 1;
      fi
      ;;
    --cache-control-max-age=?*)
      RYJO_CACHE_CONTROL_MAX_AGE=${1#*=}
      ;;
    --cache-control-max-age=)
      echo "-c or --cache-control-max-age requires a non-empty argument"
      exit 1;
      ;;
    -h|--help)
      show_help
      exit
      ;;
    -s|--silent)
      silent=true
      ;;
    -t|--content-type)
      if [ "$2" ]
      then
        RYJO_CONTENT_TYPE="$2"
        shift
      else
        echo "-t or --content-type requires a non-empty argument"
        exit 1;
      fi
      ;;
    --content-type=?*)
      RYJO_CONTENT_TYPE="${1#*=}"
      ;;
    --content-type=)
      echo "-t or --content-type requires a non-empty argument"
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

if [ ! "$?" -eq 0 ]
then
  exit "$?"
fi

if [ "$#" -eq 0 ]
then
  echo "You must pass files to be published!"
  exit 1;
fi

for file in "$@"
do
  if [ ! -f "$file" ]
  then
    echo "$file does not exist! publish canceled."
    exit 1;
  fi
done

declare -A filetypes
filetypes=(
  ["css"]="text/css"
  ["html"]="text/html"
  ["js"]="application/javascript"
  ["json"]="application/json"
  ["txt"]="text/plain"
)

for file in "$@"
do
  if [ "$RYJO_CONTENT_TYPE" ]
  then
    mimetype="$RYJO_CONTENT_TYPE"
  else
    filename="${file##*/}"
    extension="${filename##*.}"
    mimetype=${filetypes["$extension"]}
    if [ ! "$mimetype" ]
    then
      mimetype="$RYJO_DEFAULT_CONTENT_TYPE"
    fi
  fi
  printf "Publishing %s as %s... " "$file" "$mimetype"
  result=$(aws s3api put-object --bucket "$RYJO_BUCKET" --key "$file" --body "$file" --cache-control "max-age=$RYJO_CACHE_CONTROL_MAX_AGE" --content-type "$mimetype" 2>&1)
  if [ "$?" -eq 0 ]
  then
    echo -e "${GREEN}Published${NC}"
  else
    echo -e "${RED}Nope${NC}"
    echo "There was an error publishing $file:"
    echo "$result"
    exit $?
  fi
done
