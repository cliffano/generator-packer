<img align="right" src="https://raw.github.com/{{github_id}}/{{github_repo}}/main/avatar.jpg" alt="Avatar"/>

[![Build Status](https://github.com/{{github_id}}/{{github_repo}}/workflows/CI/badge.svg)](https://github.com/{{github_id}}/{{github_repo}}/actions?query=workflow%3ACI)
[![Code Scanning Status](https://github.com/{{github_id}}/{{github_repo}}/workflows/CodeQL/badge.svg)](https://github.com/{{github_id}}/{{github_repo}}/actions?query=workflow%3ACodeQL)
[![Security Status](https://snyk.io/test/github/{{github_id}}/{{github_repo}}/badge.svg)](https://snyk.io/test/github/{{github_id}}/{{github_repo}})
[![Published Version](https://img.shields.io/docker/v/{{github_id}}/{{project_id}}.svg)](https://hub.docker.com/r/{{github_id}}/{{project_id}}/)
[![Docker Pulls Count](https://img.shields.io/docker/pulls/{{github_id}}/{{project_id}}.svg)](https://hub.docker.com/r/{{github_id}}/{{project_id}}/)

{{project_name}}
{{underline "-" project_name.length}}

{{project_name}} is a {{project_desc}}.

This image provides `{{project_id}}`, a command-line message transformer that
prints the original message plus reverse, uppercase, and lowercase variants.

Installation
------------

Pull the Docker image from Docker Hub:

```shell
docker pull {{github_id}}/{{project_id}}
```

Or alternatively, you can build the Docker image locally:

```shell
git clone https://github.com/{{github_id}}/{{github_repo}}
cd {{github_repo}}
make build-docker
```

Usage
-----

Run container using default message (`Hello World`):

```shell
docker run --rm {{github_id}}/{{project_id}}
```

Run container using a custom message:

```shell
docker run --rm {{github_id}}/{{project_id}} --message 'Hello Packer'
```

Example output:

```yaml
Original: Hello Packer
Reverse: rekcaP olleH
Uppercase: HELLO PACKER
Lowercase: hello packer
```

Colophon
--------

Related projects:

* [Backpacker](https://github.com/cliffano/backpacker) - Build Packer-based machine images using a reusable Makefile workflow