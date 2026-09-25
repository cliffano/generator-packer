# AGENTS.md

This repository contains a Packer-based machine image project following a
unified standard for tooling, build automation, and coding conventions. All
projects share the same conventions to keep image builds consistent and
maintainable.

The key components of the standard include:

- Build automation (Backpacker)
- Image building (Packer + Docker builder)
- Provisioning (Ansible + shell)
- Infrastructure testing (Testinfra/pytest)
- Publishing (Docker Hub)

This document outlines the common conventions that apply across the Packer
machine image projects.

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
├── conf/                    # Packer variable files and Ansible defaults
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

### Common Commands

```bash
make ci                 # Run clean + deps + lint + build-docker + test-docker
make all                # Alias for ci
make clean              # Remove logs/ directory
make deps               # Install Python deps and Packer plugins
make deps-upgrade       # Upgrade dependencies and recompile requirements
make lint               # Validate Packer template, lint Ansible, YAML, and JSON config
make build-docker        # Build the Docker machine image via Packer
make test-docker          # Run Testinfra tests against the built image
make publish-docker        # Push the built image to Docker Hub
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

Applies to: `.github/workflows/**/*.yml`, `.github/workflows/**/*.yaml`, `templates/**/*.pkr.hcl`, `provisioners/ansible/**/*.yaml`, `provisioners/shell/**/*.sh`, `conf/**/*.yaml`, `conf/**/*.json`, `backpacker.yml`, `README.md`, `CHANGELOG.md`

#### Style & Formatting

##### Workflow and Build Config

All workflow and build configuration changes should stay explicit, readable, and
reproducible.

Guidelines:

- Use two-space indentation in YAML files
- Keep workflow/job/step names descriptive
- Avoid compact one-liners that hide intent in CI definitions
- Keep shell snippets readable and fail fast

##### Packer Templates

The Packer template should remain syntactically valid:

```bash
packer validate -syntax-only templates/packer/docker.pkr.hcl
```

Guidelines:

- Keep build sources, provisioners, and post-processors explicit
- Prefer variable files (`conf/packer/*.json`) over hardcoded values

##### Ansible Provisioning

Ansible playbooks should stay lint-clean:

```bash
ansible-lint provisioners/ansible/*.yaml
```

Guidelines:

- Keep tasks named and idempotent
- Keep default values in `conf/ansible/defaults.yaml`

##### Shell Provisioning

Guidelines:

- Keep provisioning scripts under `provisioners/shell/` small and single-purpose
- Fail fast on missing dependencies or unexpected environment state

#### Site Structure Conventions

- Keep Packer template definitions in `templates/`
- Keep provisioning logic in `provisioners/`
- Keep build/runtime configuration values in `conf/` and `backpacker.yml`

#### Validation

- Treat lint failures as build failures
- Run `make lint` before merging provisioning or template changes
- Run `make build-docker` and `make test-docker` when provisioning behavior changes

## Testing

- This project uses Testinfra (pytest-based) infrastructure tests against the built image
- Run validation with `make ci`

### Testing Guidelines

Applies to: `.github/workflows/**/*.yml`, `.github/workflows/**/*.yaml`, `test/testinfra/**/*.py`

#### Validation Strategy

This project validates the built machine image using Testinfra tests executed
via pytest, alongside deterministic lint/build checks.

Primary validation commands:

```bash
make ci
make test-docker
```

#### What to Validate

- Packer template validity (`packer validate`)
- Ansible/YAML/JSON lint results
- Built image behavior (`test/testinfra/docker.py` via `make test-docker`)
- Workflow execution consistency for CI and publish flows

#### Workflow Test Practices

- Keep Testinfra assertions focused on observable container behavior
- Avoid network-dependent checks unless required by image build/publish behavior
- Fail fast on missing configuration values

#### Regression Prevention

When changing the Packer template, provisioning, or image configuration:

1. Run `make lint`
2. Run `make build-docker`
3. Run `make test-docker`
4. Verify `test/testinfra/docker.py` assertions still match the new image behavior
