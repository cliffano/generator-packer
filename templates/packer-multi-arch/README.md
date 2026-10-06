<!-- BEGIN:AVATAR -->
![Avatar](avatar.jpg)
<!-- END:AVATAR -->

<!-- BEGIN:BADGES -->
[![Build Status](https://github.com/{{github_id}}/{{github_repo}}/workflows/CI/badge.svg)](https://github.com/{{github_id}}/{{github_repo}}/actions?query=workflow%3ACI)
[![Code Scanning Status](https://github.com/{{github_id}}/{{github_repo}}/workflows/CodeQL/badge.svg)](https://github.com/{{github_id}}/{{github_repo}}/actions?query=workflow%3ACodeQL)
[![Security Status](https://snyk.io/test/github/{{github_id}}/{{github_repo}}/badge.svg)](https://snyk.io/test/github/{{github_id}}/{{github_repo}})
[![Published Version](https://img.shields.io/docker/v/{{dockerhub_username}}/{{image_name}}.svg)](https://hub.docker.com/r/{{dockerhub_username}}/{{image_name}}/)
[![Docker Pulls Count](https://img.shields.io/docker/pulls/{{dockerhub_username}}/{{image_name}}.svg)](https://hub.docker.com/r/{{dockerhub_username}}/{{image_name}}/)
<!-- END:BADGES -->

# {{project_name}}

{{project_name}} is a {{project_desc}}.

This image provides `{{project_id}}`, a command-line message transformer that
prints the original message plus reverse, uppercase, and lowercase variants.
The image is built for both `linux/amd64` and `linux/arm64` and published as
a single multi-architecture manifest.

## Installation

Pull the Docker image from Docker Hub, Docker automatically selects the image
matching your host's architecture:

```shell
docker pull {{dockerhub_username}}/{{image_name}}
```

Or alternatively, you can build the Docker image locally:

```shell
git clone https://github.com/{{github_id}}/{{github_repo}}
cd {{github_repo}}
make build-docker
```

The image is built for the host architecture by default. The architecture can
be specified explicitly using `ARCH` (`amd64` or `arm64`):

```shell
make build-docker ARCH=arm64
```

## Usage

Run container using default message (`Hello World`):

```shell
docker run --rm {{dockerhub_username}}/{{image_name}}
```

Run container using a custom message:

```shell
docker run --rm {{dockerhub_username}}/{{image_name}} --message 'Hello Packer'
```

Example output:

```yaml
Original: Hello Packer
Reverse: rekcaP olleH
Uppercase: HELLO PACKER
Lowercase: hello packer
```

## Publishing

Each architecture is built and pushed independently, tagged with its own
`version-arch` tag:

```shell
make build-docker ARCH=amd64 && make publish-docker ARCH=amd64
make build-docker ARCH=arm64 && make publish-docker ARCH=arm64
```

Once both architectures have been pushed, combine them into a single
multi-arch manifest, published under the plain `version` and `latest` tags:

```shell
make publish-docker-manifest
```

## Colophon

<!-- BEGIN:DEVELOPERS_GUIDE -->
[Developer's Guide](https://{{github_id}}.github.io/developers-guide-packer.html)
<!-- END:DEVELOPERS_GUIDE -->

<!-- BEGIN:BUILD_REPORTS -->
<!-- END:BUILD_REPORTS -->
