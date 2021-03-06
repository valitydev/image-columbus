UTILS_PATH := build_utils
TEMPLATES_PATH := .

SERVICE_NAME := postgres-geodata
SERVICE_IMAGE_TAG ?= $(shell git rev-parse HEAD)
SERVICE_IMAGE_PUSH_TAG ?= $(SERVICE_IMAGE_TAG)

BASE_IMAGE_NAME := rbkmoney/postgres
BASE_IMAGE_TAG := a5ebd642e6efdd1ef87d844c58765fd3766b0440

-include $(UTILS_PATH)/make_lib/utils_image.mk
CUSTOM_BASE_IMAGE := $(REGISTRY)/$(BASE_IMAGE_NAME):$(BASE_IMAGE_TAG)
export CUSTOM_BASE_IMAGE

$(SUBTARGETS): %/.git: %
	git submodule update --init $<
	touch $@

submodules: $(SUBTARGETS)


clean:
	rm Dockerfile

