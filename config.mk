.DEFAULT_GOAL := all
# TODO Add descriptions.
help:
	$(info make all)
	$(info make build)
	$(info make summarise)
	$(info make archive-contents)
	$(info make json)
	$(info make html)
	$(info make clean-working)
	$(info make clean-packages)
	$(info make clean-json)
	$(info make clean-sandbox)
	$(info make clean)
	$(info make pull-package-build)
#	$(info make get-pkgdir)
	$(info make sandbox)
	$(info make docker_build_rebuild)
	$(info make docker_build_shell)
	$(info make docker_build_run)

# This is only used by the `pull-package-build' target:
PACKAGE_BUILD_REPO ?= "~/.config/emacs/lib/package-build"

# This is used by targets that may be run inside and
# outside of docker.
ifeq ($(shell whoami), builder)
LOAD_PATH = /mnt/store/package-build
else ifeq ($(shell whoami), jonas)
LOAD_PATH = /home/jonas/.config/emacs/lib/package-build
endif

docker_build_rebuild:
	docker build \
	--build-arg UID=`id --user` \
	--build-arg GID=`id --group` \
	-t melpa_builder docker/builder

docker_build_shell:
	docker run -it \
	--mount type=bind,src=$$PWD,target=/mnt/store/melpa \
	--mount type=bind,src=$(LOAD_PATH),target=/mnt/store/package-build \
	-e INHIBIT_MELPA_PULL=t \
	melpa_builder bash

docker_build_run:
	docker run -it \
	--mount type=bind,src=$$PWD,target=/mnt/store/melpa \
	--mount type=bind,src=$(LOAD_PATH),target=/mnt/store/package-build \
	-e INHIBIT_MELPA_PULL=t \
	melpa_builder
