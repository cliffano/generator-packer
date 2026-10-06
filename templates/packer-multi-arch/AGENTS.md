# AGENTS.md

This repository contains a Packer-based, multi-architecture machine image
project following a unified standard for tooling, build automation, and
coding conventions. All projects share the same conventions to keep image
builds consistent and maintainable.

The key components of the standard include:

- Build automation (Backpacker)
- Image building (Packer + Docker builder, `linux/amd64` and `linux/arm64`)
- Provisioning (Ansible + shell)
- Infrastructure testing (Testinfra/pytest)
- Publishing (Docker Hub, as a combined multi-arch manifest)

This document outlines the common conventions that apply across the Packer
multi-architecture machine image projects.

## Runtime & Dependencies

- **Python Version**: 3 (via `venv`)
- **Dependency Manager**: pip-tools (`requirements.txt` / `requirements-dev.txt` / `requirements.in`)
- **Image Building**: Packer, with `hashicorp/docker` and `hashicorp/ansible` plugins
- **Configuration Tooling**: yq

### Adding Dependencies

```bash
# Add the dependency to requirements.in
make deps-upgrade                 # Recompile and upgrade locked dependencies
make deps                         # Install Python deps and Packer plugins
```

## Project Structure

```text
project/
├── conf/                    # Packer variable files
├── provisioners/            # Ansible playbooks and shell provisioning scripts
├── templates/               # Packer template (docker.pkr.hcl)
├── test/                    # Testinfra tests (test/testinfra/*.py)
├── .github/                 # GitHub workflows and actions
├── backpacker.yml           # Backpacker project configuration
├── Makefile                 # Build automation (Backpacker)
├── requirements.in           # Direct Python dependencies
└── README.md                  # Project README
```

## Build Automation (Backpacker)

This project uses **Backpacker** as its standard build automation tool for
Packer-based machine image projects.

### Multi-Architecture Builds

Unlike single-architecture Packer components, this project parameterises the
build with an `ARCH` variable (`amd64` or `arm64`, defaulting to the host
architecture), and separates "build+publish a single architecture" from
"combine architectures into one manifest":

- `build-docker` / `publish-docker` operate on **one** architecture at a time,
  driven by `ARCH`. `publish-docker` only ever pushes the `version-arch` tag —
  never `latest` or the plain `version` tag.
- `publish-docker-manifest` runs **once**, after every architecture has been
  built and pushed, and uses `docker buildx imagetools create` to combine the
  per-architecture tags into a single multi-arch `version` and `latest` tag.

In CI, this means the build/publish workflow uses a matrix with one job per
architecture (each on its own native runner, e.g. `ubuntu-26.04` for `amd64`
and `ubuntu-26.04-arm` for `arm64` — no cross-compilation or QEMU emulation),
followed by a separate `manifest` job that depends on both matrix jobs
completing.

### Common Commands

```bash
make ci                        # Run clean + deps + lint + build-docker + test-docker (current ARCH)
make all                       # Alias for ci
make clean                     # Remove logs/ directory
make deps                      # Install Python deps and Packer plugins
make deps-upgrade              # Upgrade dependencies and recompile requirements
make lint                      # Validate Packer template, lint Ansible, YAML, and JSON config
make build-docker               # Build the Docker machine image via Packer for $(ARCH)
make test-docker                 # Run Testinfra tests against the built image
make publish-docker               # Push the $(ARCH)-specific image tag to Docker Hub
make publish-docker-manifest       # Combine amd64 + arm64 tags into a multi-arch version/latest tag
```

### Update Targets

```bash
make update-to-latest   # Update Makefile to latest Backpacker release
make update-to-main     # Update Makefile to Backpacker main branch
make update-to-version  # Update Makefile to a specific Backpacker version
```

## Development Environment

This project is designed to be developed in a consistent environment via Docker
image `cliffano/studio`.

You can run the container using: `docker run --rm --workdir /opt/workspace -v /var/run/docker.sock:/var/run/docker.sock -v $PWD:/opt/workspace -i -t cliffano/studio` and then run the build commands inside the container.

## Code Style and Linting

- Packer, Ansible, YAML, and JSON files are validated via `make lint`
- Workflow and build config changes should stay deterministic and minimal

### Packer Machine Image Code Guidelines

Applies to: `.github/workflows/**/*.yml`, `.github/workflows/**/*.yaml`, `templates/**/*.pkr.hcl`, `provisioners/ansible/**/*.yaml`, `provisioners/shell/**/*.sh`, `conf/**/*.json`, `backpacker.yml`, `README.md`, `CHANGELOG.md`

#### Style & Formatting

##### Workflow and Build Config

All workflow and build configuration changes should stay explicit, readable, and
reproducible.

Guidelines:

- Use two-space indentation in YAML files
- Keep workflow/job/step names descriptive
- Avoid compact one-liners that hide intent in CI definitions
- Keep shell snippets readable and fail fast
- Keep the per-architecture build/publish matrix and the manifest job separate — don't try to combine architectures in the same job

##### Packer Templates

The Packer template should remain syntactically valid:

```bash
packer validate -syntax-only templates/packer/docker.pkr.hcl
```

Guidelines:

- Keep build sources, provisioners, and post-processors explicit
- Prefer variable files (`conf/packer/*.json`) over hardcoded values
- Keep `platform = "linux/${var.arch}"` on the Docker source — this is what makes the build architecture-aware
- Keep both `latest` and `"${var.version}-${var.arch}"` in the `docker-tag` post-processor's `tags` list — `latest` lets each CI job immediately self-test its own build locally; the registry's real `latest` tag is only ever set by the separate manifest step

##### Ansible Provisioning

Ansible playbooks should stay lint-clean:

```bash
ansible-lint provisioners/ansible/*.yaml
```

Guidelines:

- Keep tasks named and idempotent

##### Shell Provisioning

Guidelines:

- Keep provisioning scripts under `provisioners/shell/` small and single-purpose
- Fail fast on missing dependencies or unexpected environment state
- Don't assume a specific base-image package manager beyond what `conf/packer/docker.json`'s `docker_source` implies

#### Site Structure Conventions

- Keep Packer template definitions in `templates/`
- Keep provisioning logic in `provisioners/`
- Keep build/runtime configuration values in `conf/` and `backpacker.yml`

#### Validation

- Treat lint failures as build failures
- Run `make lint` before merging provisioning or template changes
- Run `make build-docker` and `make test-docker` for both `ARCH=amd64` and `ARCH=arm64` when provisioning behavior changes

## Testing

- This project uses Testinfra (pytest-based) infrastructure tests against the built image
- Run validation with `make ci`

### Testing Guidelines

Applies to: `.github/workflows/**/*.yml`, `.github/workflows/**/*.yaml`, `test/testinfra/**/*.py`

#### Validation Strategy

This project validates the built machine image using Testinfra tests executed
via pytest, alongside deterministic lint/build checks. Each CI matrix job
only validates its own architecture's locally-built image (via the local
`latest` tag) — it never pulls or validates the published multi-arch manifest.

Primary validation commands:

```bash
make ci
make test-docker
```

#### What to Validate

- Packer template validity (`packer validate`)
- Ansible/YAML/JSON lint results
- Built image behavior (`test/testinfra/docker.py` via `make test-docker`)
- Workflow execution consistency for CI and publish flows, across both architectures

#### Workflow Test Practices

- Keep Testinfra assertions focused on observable container behavior
- Avoid network-dependent checks unless required by image build/publish behavior
- Fail fast on missing configuration values

#### Regression Prevention

When changing the Packer template, provisioning, or image configuration:

1. Run `make lint`
2. Run `make build-docker` and `make test-docker` for `ARCH=amd64`
3. Run `make build-docker` and `make test-docker` for `ARCH=arm64`
4. Verify `test/testinfra/docker.py` assertions still match the new image behavior on both architectures
