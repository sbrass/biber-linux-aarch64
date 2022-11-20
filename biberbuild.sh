#!/usr/bin/env bash

BIBER_BRANCH="${1:-dev}"
BIBER_REPO="${2:-plk/biber}"
BIBER_BINARY=biber-linux_arm64

ARCH="$(uname -a | rev | cut -d' ' -f2 | rev)"

echo "Building branch: ${BIBER_BRANCH} of ${BIBER_REPO}"

# git cherry-pick: Dirty trick to backport build script into versions v2.18 and lower (semantic versioning sorts lexically)
# ldconfig: Needs to be run *after* installdeps to run tests sucessfully.
(set -x
 git clone https://github.com/"${BIBER_REPO}".git && \
     cd biber && \
     git checkout "${BIBER_BRANCH}" && \
     { [[ "${BIBER_BRANCH}" < "v2.19" ]] && EMAIL="Castor Fiber <castor.fiber@localhost>" git cherry-pick e747c71e7cd2df5677f41908ee1baacd4877281c; } && \
     perl ./Build.PL && \
     ./Build installdeps && \
     echo "/usr/local/lib" > /etc/ld.so.conf.d/biber.conf && ldconfig && \
     ./Build test && \
     ./Build install && \
     cd ./dist/linux_"${ARCH}" && \
     bash ./build.sh
 )

if test -f biber/dist/linux_"${ARCH}"/"${BIBER_BINARY}"; then
    cp biber/dist/linux_"${ARCH}"/"${BIBER_BINARY}" /opt/biber
fi
