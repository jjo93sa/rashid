## rashid - RAspbian SHrink In Docker

### About

`rashid` is used to shrink Raspbian images. This is useful if you've used dd or similar utility to create a bit-wise copy of a Raspberry Pi SD card. The image so created is the same size as the card capacity, but the working software occupies only a small fraction of that space. This utility shrinks the image reducing the size, thereby reducing storage requirements and transfer times.

All the heavy lifting is provided by the excellent `raspbian-shrink` tool written by Andrew Oakley at [cotswoldjam](https://cotswoldjam.org). I recommend you have a look at the instructions in their [repository](https://github.com/aoakley/cotswoldjam.git).

The script `rashid` - RAspbian SHrink In Docker - should run stand-alone alongside a copy of `raspbian-shrink`, but it is designed as the entry point for a Docker container. I created this because I wanted to use `raspbian-shrink` on my MacBook, but couldn't because macOS doesn't have native support for ext4 (the filesystem used in Raspbian). Also because everything should run in containers.


### Dependencies

The following dependencies are required:

1. Working installation of Docker >v17.05 (we use multi-stage builds);
2. Raspbian image (for example a dd copy of an SD-card), this does not work with Noobs;
1. Tested working with `commit 2909def47f675aea43ed8d915cab683e15c7fdf9` of [cotswoldjam](https://github.com/aoakley/cotswoldjam.git).

### Usage

1. Build the Docker image like this, from within the directory containing the Dockerfile:
```
docker build --no-cache --shrink -t <tag>/rashid .
```
Replacing `<tag>` with the name of your Docker repository. The Cotswoldjam repository is pulled in during the first build stage.

1. Assuming the image you want to shrink is contained in the current working directory, run the container:

```
docker run --rm -it -v `pwd`:/work-dir --device=/dev:/dev/ --cap-add=SYS_ADMIN --name rashid <tag>/rashid [-e] [-d] [-f] [-m MB] [-y]  source.img shrunk.img
```
Replace `<tag>` with the tag you used to build this image in the previous
step.

1. Consider setting the `docker run` command as function in your .bashrc, or elsewhere, for easier future use:

```
DOCKER_REPO_PREFIX=<repo>

shrink()
{
   docker run --rm \
       -it \
       -v `pwd`:/work-dir \
       --device=/dev/:/dev/ \
       --cap-add=SYS_ADMIN \
       --name rashid \
       ${DOCKER_REPO_PREFIX}/rashid "$@"
}
```

### Support and feature requests

Ping me if you have any questions, suggestions or requests for new features.

### License

Distributed under the MIT License, see LICENSE file in the repository root for more information.
