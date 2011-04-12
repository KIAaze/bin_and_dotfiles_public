#!/bin/bash

rm -iv *.tar.gz

set -eux

VERSION="1.3.7"
UBU="0ubuntu8"
NAME=$NAME_JZ
MAIL=$MAIL_JZ

./testing/release.sh "$NAME" $MAIL 1 && totalnotify.sh "SUCCESS" || ( totalnotify.sh "FAILURE" && false )
./testing/check_tarball.sh ./release/webcontentcontrol_$VERSION.orig.tar.gz ./release/ $HOME/opt/ && totalnotify.sh "SUCCESS" || ( totalnotify.sh "FAILURE" && false )
./testing/check_tarball.sh ./release/webcontentcontrol_$VERSION.orig.tar.gz ./release/ /usr && totalnotify.sh "SUCCESS" || ( totalnotify.sh "FAILURE" && false )
./testing/check_deb.sh ./release/webcontentcontrol_$VERSION-$UBU\_i386.deb && totalnotify.sh "SUCCESS" || ( totalnotify.sh "FAILURE" && false )
