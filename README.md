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

#### Options

You have two options available to use `rashid`: using a pre-built image, or building your own image.

#### Pre-built image

I provide pre-built images for Intel and ARM (for Raspberry Pi), which can be downloaded by Docker like this:
```
# For Intel:
docker pull r.j2o.it/rashid
```
```
# For ARM:
docker pull r.j2o.it/arm32v6/rashid
```
And then jump right to the "Shrinking an image" section below, wherein you replace `<tag>` with `r.j2o.it` or `r.j2o.it/arm32v6` depending which image you pulled.

#### Build your own image

Building your own image from this repository is simple:

1. Clone this repository:
```
git clone https://github.com/jjo93sa/rashid.git
```
2. Build the Docker image like this, from within the directory containing the Dockerfile:
```
cd rashid
docker build --no-cache --shrink -t <tag>/rashid .
```
Replacing `<tag>` with the name of your Docker repository. The Cotswoldjam repository is pulled in during the first build stage.

#### Shrinking an image

Shrinking a disk image is achieved by running a `rashid` container, thus:

1. Assuming the disk image you want to shrink is contained in the current working directory, and called `source.img`, run the container:
```
# Replace <tag> with the tag you used to build this image in the previous step.
# For example if you downloaded the pre-built ARM image, <tag> would be r.j2o.it/arm32v6
docker run --rm -it -v `pwd`:/work-dir --device=/dev:/dev/ --cap-add=SYS_ADMIN --name rashid <tag>/rashid [-e] [-d] [-f] [-m MB] [-y] source.img shrunk.img
```
2. Consider setting the `docker run` command as function in your `.bashrc`, or elsewhere, for easier future use: 

```
# Replace <tag> with the value you used above
DOCKER_REPO_PREFIX=<tag>

rashid()
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
3. After (2) reload your `.bashrc` to load the function into yuor environment:
```
source .bashrc
```

### Support and feature requests

Ping me if you have any questions, suggestions or requests for new features.

### License

Distributed under the MIT License, see LICENSE file in the repository root for more information.
