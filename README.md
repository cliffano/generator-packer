<!-- BEGIN:AVATAR -->
![Avatar](avatar.jpg)
<!-- END:AVATAR -->

<!-- BEGIN:BADGES -->
[![Build Status](https://github.com/cliffano/generator-packer/workflows/CI/badge.svg)](https://github.com/cliffano/generator-packer/actions?query=workflow%3ACI)
[![Code Scanning Status](https://github.com/cliffano/generator-packer/workflows/CodeQL/badge.svg)](https://github.com/cliffano/generator-packer/actions?query=workflow%3ACodeQL)
[![Security Status](https://snyk.io/test/github/cliffano/generator-packer/badge.svg)](https://snyk.io/test/github/cliffano/generator-packer)
<!-- END:BADGES -->

# Generator Packer

Generator Packer is Code generator for Packer builders.

It provides the following components:

| Component | Description |
|-----------|-------------|
| packer-python | <some_component_desc> |
| packer-python-partials | Generate README partial snippets for Packer Python projects. |

## Usage

Generate code generator project:

```shell
make generate-packer-python
```

Generate Packer Python partial snippets:

```shell
make generate-packer-python-partials
```

This component will prompt you the following inputs:

| Prompt | Description |
|--------|-------------|
| Project ID | Used for package names and project repo name. |
| Project Name | Used in documentation or comments. |
| Project Description | Used in documentation or comments. |
| Author Name | The name of the project author. |
| Author Email | The email of the project author. |
| Author URL | The author's website URL. |
| GitHub ID | The GitHub ID of the project repo. |

Move to the generated project directory:

```shell
cd stage/packer-python/
```

## Usage With Config File

Each component also has a `-with-config` target that skips the interactive prompts by reading the inputs from a Backpacker YAML config file. See [examples/](examples/) for sample config files for each component.

Pass the config file path via the `GENERATOR_CONFIG` variable, it defaults to `backpacker.yml`:

```shell
make generate-packer-python-with-config GENERATOR_CONFIG=path/to/backpacker.yml
make generate-packer-python-partials-with-config GENERATOR_CONFIG=path/to/backpacker.yml
```

## Configuration

| Key | Value |
|-----|-------|
| project_id | generator-packer |
| project_name | Generator Packer |
| project_desc | Code generator for Packer builders |
| author_name | Cliffano Subagio |
| author_email | blah@cliffano.com |
| github_id | cliffano |
| github_repo | generator-packer |

## Colophon

<!-- BEGIN:DEVELOPERS_GUIDE -->
[Developer's Guide](https://cliffano.github.io/developers-guide-makefile.html)
<!-- END:DEVELOPERS_GUIDE -->

<!-- BEGIN:BUILD_REPORTS -->
Build reports:

<!-- END:BUILD_REPORTS -->

Related Projects:

* [Backpacker](https://github.com/cliffano/backpacker) - Makefile for building Packer-based machine images
