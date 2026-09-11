ci: clean stage deps test-packer-python test-packer-python-partials

clean:
	rm -rf stage/

clean-packer-python:
	rm -rf stage/packer-python/

stage:
	mkdir -p stage/

deps:
	npm install .

########################################
# Utility targets
########################################

GENERATOR_CONFIG ?= backpacker.yml

define set_generator_vars
$(1): GENERATOR_COMPONENT = $$(shell yq .generator.component $(2))
$(1): GENERATOR_INPUTS_PROJECT_ID = $$(shell yq .generator.inputs.project_id $(2))
$(1): GENERATOR_INPUTS_PROJECT_NAME = $$(shell yq .generator.inputs.project_name $(2))
$(1): GENERATOR_INPUTS_PROJECT_DESC = $$(shell yq .generator.inputs.project_desc $(2))
$(1): GENERATOR_INPUTS_AUTHOR_NAME = $$(shell yq .generator.inputs.author_name $(2))
$(1): GENERATOR_INPUTS_AUTHOR_EMAIL = $$(shell yq .generator.inputs.author_email $(2))
$(1): GENERATOR_INPUTS_AUTHOR_URL = $$(shell yq .generator.inputs.author_url $(2))
$(1): GENERATOR_INPUTS_GITHUB_ID = $$(shell yq .generator.inputs.github_id $(2))
$(1): GENERATOR_INPUTS_GITHUB_REPO = $$(shell yq .generator.inputs.github_repo $(2))
$(1): GENERATOR_INPUTS_GITHUB_TOKEN_PREFIX = $$(shell yq .generator.inputs.github_token_prefix $(2))
endef

########################################
# packer-python targets
########################################

generate-packer-python: clean-packer-python
	node_modules/.bin/plop packer-python

$(eval $(call set_generator_vars,generate-packer-python-with-config,$(GENERATOR_CONFIG)))
generate-packer-python-with-config: clean-packer-python
	node_modules/.bin/plop $(GENERATOR_COMPONENT) -- \
	    --project_id "$(GENERATOR_INPUTS_PROJECT_ID)" \
		--project_name "$(GENERATOR_INPUTS_PROJECT_NAME)" \
		--project_desc "$(GENERATOR_INPUTS_PROJECT_DESC)" \
		--author_name "$(GENERATOR_INPUTS_AUTHOR_NAME)" \
		--author_email "$(GENERATOR_INPUTS_AUTHOR_EMAIL)" \
		--author_url "$(GENERATOR_INPUTS_AUTHOR_URL)" \
		--github_id "$(GENERATOR_INPUTS_GITHUB_ID)" \
		--github_repo "$(GENERATOR_INPUTS_GITHUB_REPO)" \
		--github_token_prefix "$(GENERATOR_INPUTS_GITHUB_TOKEN_PREFIX)"

test-packer-python: clean-packer-python
	make generate-packer-python-with-config GENERATOR_CONFIG=examples/backpacker-packer-python.yml
	cd stage/packer-python/ && \
	  make ci

########################################
# packer-python-partials targets
########################################

clean-packer-python-partials:
	rm -rf stage/packer-python-partials/

generate-packer-python-partials: clean-packer-python-partials
	node_modules/.bin/plop packer-python-partials

$(eval $(call set_generator_vars,generate-packer-python-partials-with-config,$(GENERATOR_CONFIG)))
generate-packer-python-partials-with-config: clean-packer-python-partials
	node_modules/.bin/plop $(GENERATOR_COMPONENT) -- \
	    --project_id "$(GENERATOR_INPUTS_PROJECT_ID)" \
		--project_name "$(GENERATOR_INPUTS_PROJECT_NAME)" \
		--project_desc "$(GENERATOR_INPUTS_PROJECT_DESC)" \
		--author_name "$(GENERATOR_INPUTS_AUTHOR_NAME)" \
		--author_email "$(GENERATOR_INPUTS_AUTHOR_EMAIL)" \
		--author_url "$(GENERATOR_INPUTS_AUTHOR_URL)" \
		--github_id "$(GENERATOR_INPUTS_GITHUB_ID)" \
		--github_repo "$(GENERATOR_INPUTS_GITHUB_REPO)" \
		--github_token_prefix "$(GENERATOR_INPUTS_GITHUB_TOKEN_PREFIX)"

test-packer-python-partials: clean-packer-python-partials
	make generate-packer-python-partials-with-config GENERATOR_CONFIG=examples/backpacker-packer-python-partials.yml

update-backpacker-to-latest:
	cd templates/packer-python && make update-to-latest

.PHONY: ci clean clean-packer-python stage deps generate-packer-python generate-packer-python-with-config test-packer-python clean-packer-python-partials generate-packer-python-partials generate-packer-python-partials-with-config test-packer-python-partials update-backpacker-to-latest
