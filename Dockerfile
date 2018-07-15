#
# Title:  rashid/Dockerfile
#
# Description:
#   Dockerfile definition to execute a scripte, rashid, to shrink Raspbian
#   images. Heavy lifting provided by https://github.com/aoakley/cotswoldjam.git
#
# Dependencies:
#   (1) Uses multistage builds, requiring Docker >17.05
#   (2) Requires extra capabilities, and access to /dev (to use loop devices)
#
# Credits:
#   Andrew Oakley and cotswoldjam.org https://github.com/aoakley/cotswoldjam.git
#
# Usage:
#   (1) Build the Docker image like this, from within the directory containing
#       the Dockerfile:
#
#         docker build --no-cache --shrink -t <tag>/rashid .
#
#       Replacing <tag> with the name of your Docker repository.
#
#   (2) Assuming the image you want to shrink is contained in the current
#       working directory, run the container:
#
#         docker run --rm \
#             -it \
#             -v `pwd`:/work-dir \
#             --device=/dev:/dev/ \
#             --cap-add=SYS_ADMIN \
#             --name rashid \
#             <tag>/rashid [-e] [-f] [-m MB] [-y]  source.img shrunk.img
#
#   Replace <tag> with the tag you used to build this image in the previous
#   step.
#
# Maintainer: dr.j.osborne@gmail.com
#
# License: MIT, see LICENSE file in repository root
#
FROM alpine AS intermediate

# We need git
RUN apk --no-cache update && apk --no-cache add git

# Get a copy of the cotswoldjam repo, we only use raspbian-shrink
RUN git clone https://github.com/aoakley/cotswoldjam.git

FROM debian:stable-slim

LABEL maintainer "dr.j.osborne@gmail.com"
LABEL status "production"
LABEL version "1.0"

# Install some extra packages we need
RUN apt-get update && apt-get -y install dcfldd \
	&& rm -rf /var/lib/apt/lists/*

# Copy the script file into somewhere on the $PATH
COPY --from=intermediate /cotswoldjam/raspbian-shrink/raspbian-shrink /usr/local/bin/

# This script is used to parse the CLI parameters and call raspbian-shrink
COPY rashid /usr/local/bin

# This script is put into the shrunk image if the -e flag is used
COPY resize2fs_once /tmp

# Change the script permissions
RUN chmod a+x /usr/local/bin/raspbian-shrink \
              /usr/local/bin/rashid        \
              /tmp/resize2fs_once

WORKDIR /work-dir

ENTRYPOINT [ "/usr/local/bin/rashid" ]
CMD ["original.img", "shrunk.img"]
