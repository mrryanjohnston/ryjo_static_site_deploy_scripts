#!/bin/bash
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

silent=false

while :; do
  case "$1" in 
    -s|--silent)
      silent=true
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

if [ "$silent" = false ]
then
  printf "Checking if aws-cli is installed and available in PATH... "
fi

if [ ! "$(command -v aws)" ]
then
  if [ "$silent" = false ]
  then
    echo -e "${RED}Nope.${NC}"
    echo "You'll need to install aws-cli first."
  fi
  exit 1;
else
  if [ "$silent" = false ]
  then
    echo -e "${GREEN}Yep!${NC}"
  fi
fi

if [ "$silent" = false ]
then
  printf "Checking if AWS credentials are accessible for this user... "
fi

result=$(aws sts get-caller-identity &> /dev/null)

if [ "$silent" = true ]
then
  exit $?
fi

if ! $result
then
  echo -e "${RED}Nope.${NC}"
  echo "If you'd like, we can configure aws now and save your credentials for future uses."
  read -r -p "Run aws configure? (Y/n): " configure_aws
  configure_aws=${configure_aws:-Y}
  if [ "$configure_aws" == "Y" ]
  then
    echo "Do these things:"
    echo "  1. Open the IAM console"
    echo "  2. Choose Users from navigation pane"
    echo "  3. Choose your IAM username"
    echo "  4. Choose Security Credentials tab, then Create access key"
    echo "  5. Click Show and enter the info shown there in the following prompts"
    aws configure
    echo "Alright, let's try this again, shall we?"
    printf "Checking if AWS credentials are accessible for this user... "
    if ! aws sts get-caller-identity &> /dev/null
    then
      echo "Boo, that still didn't work :(. You're on your own for now. Sorry!"
      exit 1;
    else
      echo -e "${GREEN}Yep!${NC}"
    fi
  else
    echo "Ok, try to run this again then and just add the following to the front:"
    echo "AWS_ACCESS_KEY=<your access key> AWS_SECRET_ACCESS_KEY=<your secret access key>"
    exit 1;
  fi
else
  echo -e "${GREEN}Yep!${NC}"
fi
