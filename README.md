## rashid - RAspbian SHrink In Docker

### About

`rashid` is used to shrink Raspbian images. This is useful if you've used dd or similar utility to create a bit-wise copy of a Raspberry Pi SD card. The image so created is the same size as the card capacity, but the working software occupies only a small fraction of that space. This utility shrinks the image reducing the size, thereby reducing storage requirements and transfer times.

All the heavy lifting is provided by the excellent `raspbian-shrink` tool written by Andrew Oakley at [Cotswoldjam](https://github.com/aoakley/cotswoldjam). I recommend you have a look at the instructions in that repository.

The script `rashid` - RAspbian SHrink In Docker - should run stand-alone, but it is designed as the entry point for a Docker container. I created this because I wanted to use `raspbian-shrink` on my MacBook, but couldn't because macOS doesn't have native support for ext4 (the filesystem used in Raspbian). And also because everything should be in Docker containers.


### Dependencies

The following dependencies are required:

1. Working installation of Docker >v17.05 (we use multi-stage builds)
2. Raspbian image (for example a dd copy of an SD-card), this does not work with Noobs.

### Usage

1. Build the Docker image like this, from within the directory containing the Dockerfile:
```
docker build --no-cache --shrink -t <tag>/rashid .
```
Replacing <tag> with the name of your Docker repository.

2. Assuming the image you want to shrink is contained in the current working directory, run the container:

```
docker run --rm -it -v `pwd`:/work-dir --device=/dev:/dev/ --cap-add=SYS_ADMIN --name rashid <tag>/rashid [-e] [-f] [-m MB] [-y]  source.img shrunk.img
```
Replace <tag> with the tag you used to build this image in the previous
step.

### Support and feature requests

Ping me if you have any questions, suggestions or requests for new features.

### License

Distributed under the MIT License, see LICENSE file in the repository root for more information.
