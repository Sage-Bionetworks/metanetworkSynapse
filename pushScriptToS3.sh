#!/bin/sh

#push

aws s3 cp --acl public-read cfnClusterPreinstall.sh s3://scriptsformetanetworkbootstrap/cfnClusterPreinstall.sh
