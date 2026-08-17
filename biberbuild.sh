#!/usr/bin/env bash

BIBER_BRANCH=${branch:-dev}
BIBER_REPO=${repo:-plk/biber}
BIBER_BINARY=biber-linux_arm64

ARCH="$(uname -a | rev | cut -d' ' -f2 | rev)"

echo "Building branch: ${BIBER_BRANCH} of ${BIBER_REPO}"

# ldconfig: Needs to be run *after* installdeps to run tests sucessfully.
git clone https://github.com/"${BIBER_REPO}".git
cd biber
git checkout "${BIBER_BRANCH}"

perl ./Build.PL && ./Build installdeps && \
     echo "/usr/local/lib" > /etc/ld.so.conf.d/biber.conf && ldconfig && \
#     ./Build test && \
     ./Build install

cd ./dist/linux_"${ARCH}"
bash ./build.sh

if test -f /root/biber/dist/linux_"${ARCH}"/"${BIBER_BINARY}"; then
    cp /root/biber/dist/linux_"${ARCH}"/"${BIBER_BINARY}" /opt/biber
fi
