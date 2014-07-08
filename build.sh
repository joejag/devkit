#!/bin/bash

NAME='devkit'

MAJOR_VERSION="0"
MINOR_VERSION="1"
BUILD_REVISION=${GO_PIPELINE_COUNTER:="LocalBuild"}

VERSION_STRING="$MAJOR_VERSION.$MINOR_VERSION.$BUILD_REVISION"

test -d lib/devkit || mkdir -p lib/devkit

cat <<EOF > lib/devkit/version.rb
module Devkit
  VERSION = "${VERSION_STRING}"
end
EOF

cat lib/devkit/version.rb

rake build

fpm -s gem -t rpm --force --iteration ${BUILD_REVISION} pkg/${NAME}-${VERSION_STRING}.gem | tee rpms/fpm.log

rm -rf ./rpms
mkdir rpms
touch rpms/nolog.log

mv rubygem-${NAME}*.rpm rpms

rm -rf ./srpms
mkdir srpms
touch srpms/nolog.log
