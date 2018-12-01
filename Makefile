JDK_VERS=11.0.1
V16=1.6.0
V17=1.7.0
V18=1.8.0
V19=1.9.0
V110=1.10.0-RC2
BASE_CLJ_VERS=${V19}
ORG=clojusc
BASE_JDK_IMAGE=openjdk:$(JDK_VERS)-jdk-slim-sid
BASE_CLJ_IMAGE=$(ORG)/clojure-$(BASE_CLJ_VERS)-jdk-$(JDK_VERS)
BASE_LEIN_IMAGE=$(ORG)/clojure-$(BASE_CLJ_VERS)-lein-jdk-$(JDK_VERS)
BASE_BOOT_IMAGE=$(ORG)/clojure-$(BASE_CLJ_VERS)-boot-jdk-$(JDK_VERS)

all:
	$(MAKE) clj19-all
	$(MAKE) clj16-all
	$(MAKE) clj17-all
	$(MAKE) clj18-all
	$(MAKE) clj110-all

publish-all: all
	for CLOJURE_VERSION in $(V16) $(V17) $(V18) $(V19) $(V110); do \
	CLOJURE_VERSION_LOWER=`echo $$CLOJURE_VERSION | tr A-Z a-z`; \
	docker push $(ORG)/clojure-$$CLOJURE_VERSION_LOWER-jdk-$(JDK_VERS); \
	for BUILD_TOOL in lein boot; do \
	docker push $(ORG)/clojure-$$CLOJURE_VERSION_LOWER-$$BUILD_TOOL-jdk-$(JDK_VERS); \
	done; \
	done

clj:
	if [ -z "$(BUILD_TOOL)" ]; then \
	docker build ./$(CLOJURE_VERSION_LOWER) -t $(ORG)/clojure-$(CLOJURE_VERSION_LOWER)-jdk-$(JDK_VERS); \
	else \
	docker build ./$(CLOJURE_VERSION_LOWER) -t $(ORG)/clojure-$(CLOJURE_VERSION_LOWER)-$(BUILD_TOOL)-jdk-$(JDK_VERS); \
	fi

setup-deps:
	mkdir -p $(CLOJURE_VERSION_LOWER)
	cp common/Dockerfile common/linux-install-$(BASE_CLJ_VERS).397.sh ./$(CLOJURE_VERSION_LOWER)/
	sed 's/CLOJURE_VERSION/$(CLOJURE_VERSION)/g' common/deps.edn > ./$(CLOJURE_VERSION_LOWER)/deps.edn

setup-build-tool:
	@echo "Setting up '$(BUILD_TOOL)' build tool ..."
	if [ "$(BUILD_TOOL)" = "lein" ]; then \
	if [ "$(CLOJURE_VERSION)" = "$(BASE_CLJ_VERS)" ]; then \
	echo "FROM $(BASE_CLJ_IMAGE)" > ./$(CLOJURE_VERSION_LOWER)/Dockerfile; \
	cat common/Dockerfile.lein >> ./$(CLOJURE_VERSION_LOWER)/Dockerfile; \
	else \
	echo "FROM $(BASE_LEIN_IMAGE)" > ./$(CLOJURE_VERSION_LOWER)/Dockerfile; \
	fi; \
	cat common/Dockerfile >> ./$(CLOJURE_VERSION_LOWER)/Dockerfile; \
	elif [ "$(BUILD_TOOL)" = "boot" ]; then \
	if [ "$(CLOJURE_VERSION)" = "$(BASE_CLJ_VERS)" ]; then \
	echo "FROM $(BASE_CLJ_IMAGE)" > ./$(CLOJURE_VERSION_LOWER)/Dockerfile; \
	cat common/Dockerfile.boot >> ./$(CLOJURE_VERSION_LOWER)/Dockerfile; \
	else \
	echo "FROM $(BASE_BOOT_IMAGE)" > ./$(CLOJURE_VERSION_LOWER)/Dockerfile; \
	fi; \
	cat common/Dockerfile >> ./$(CLOJURE_VERSION_LOWER)/Dockerfile; \
	elif [ "$(CLOJURE_VERSION)" = "$(BASE_CLJ_VERS)" ]; then \
	echo "FROM $(BASE_JDK_IMAGE)" > ./$(CLOJURE_VERSION_LOWER)/Dockerfile; \
	cat common/Dockerfile.deps >> ./$(CLOJURE_VERSION_LOWER)/Dockerfile; \
	cat common/Dockerfile >> ./$(CLOJURE_VERSION_LOWER)/Dockerfile; \
	else \
	echo "FROM $(BASE_CLJ_IMAGE)" > ./$(CLOJURE_VERSION_LOWER)/Dockerfile; \
	cat common/Dockerfile >> ./$(CLOJURE_VERSION_LOWER)/Dockerfile; \
	fi

setup: setup-deps setup-build-tool

teardown:
	rm -rf $(CLOJURE_VERSION_LOWER)

## Versions

clj19-all:
	$(MAKE) clj19
	$(MAKE) clj19-lein
	$(MAKE) clj19-boot
clj16-all:
	$(MAKE) clj16
	$(MAKE) clj16-lein
	$(MAKE) clj16-boot
clj17-all:
	$(MAKE) clj17
	$(MAKE) clj17-lein
	$(MAKE) clj17-boot
clj18-all:
	$(MAKE) clj18
	$(MAKE) clj18-lein
	$(MAKE) clj18-boot
clj110-all:
	$(MAKE) clj110
	$(MAKE) clj110-lein
	$(MAKE) clj110-boot

## Clojure-only

clj19: CLOJURE_VERSION=$(V19)
clj19: CLOJURE_VERSION_LOWER=$(shell echo $(CLOJURE_VERSION) | tr A-Z a-z)
clj19: setup clj teardown

clj16: CLOJURE_VERSION=$(V16)
clj16: CLOJURE_VERSION_LOWER=$(shell echo $(CLOJURE_VERSION) | tr A-Z a-z)
clj16: setup clj teardown

clj17: CLOJURE_VERSION=$(V17)
clj17: CLOJURE_VERSION_LOWER=$(shell echo $(CLOJURE_VERSION) | tr A-Z a-z)
clj17: setup clj teardown

clj18: CLOJURE_VERSION=$(V18)
clj18: CLOJURE_VERSION_LOWER=$(shell echo $(CLOJURE_VERSION) | tr A-Z a-z)
clj18: setup clj teardown

clj110: CLOJURE_VERSION=$(V110)
clj110: CLOJURE_VERSION_LOWER=$(shell echo $(CLOJURE_VERSION) | tr A-Z a-z)
clj110: setup clj teardown

## With lein

clj19-lein: CLOJURE_VERSION=$(V19)
clj19-lein: CLOJURE_VERSION_LOWER=$(shell echo $(CLOJURE_VERSION) | tr A-Z a-z)
clj19-lein: BUILD_TOOL=lein
clj19-lein: clj19

clj16-lein: CLOJURE_VERSION=$(V16)
clj16-lein: CLOJURE_VERSION_LOWER=$(shell echo $(CLOJURE_VERSION) | tr A-Z a-z)
clj16-lein: BUILD_TOOL=lein
clj16-lein: clj16

clj17-lein: CLOJURE_VERSION=$(V17)
clj17-lein: CLOJURE_VERSION_LOWER=$(shell echo $(CLOJURE_VERSION) | tr A-Z a-z)
clj17-lein: BUILD_TOOL=lein
clj17-lein: clj17

clj18-lein: CLOJURE_VERSION=$(V18)
clj18-lein: CLOJURE_VERSION_LOWER=$(shell echo $(CLOJURE_VERSION) | tr A-Z a-z)
clj18-lein: BUILD_TOOL=lein
clj18-lein: clj18

clj110-lein: CLOJURE_VERSION=$(V110)
clj110-lein: CLOJURE_VERSION_LOWER=$(shell echo $(CLOJURE_VERSION) | tr A-Z a-z)
clj110-lein: BUILD_TOOL=lein
clj110-lein: clj110

## With boot

clj19-boot: CLOJURE_VERSION=$(V19)
clj19-boot: CLOJURE_VERSION_LOWER=$(shell echo $(CLOJURE_VERSION) | tr A-Z a-z)
clj19-boot: BUILD_TOOL=boot
clj19-boot: clj19

clj16-boot: CLOJURE_VERSION=$(V16)
clj16-boot: CLOJURE_VERSION_LOWER=$(shell echo $(CLOJURE_VERSION) | tr A-Z a-z)
clj16-boot: BUILD_TOOL=boot
clj16-boot: clj16

clj17-boot: CLOJURE_VERSION=$(V17)
clj17-boot: CLOJURE_VERSION_LOWER=$(shell echo $(CLOJURE_VERSION) | tr A-Z a-z)
clj17-boot: BUILD_TOOL=boot
clj17-boot: clj17

clj18-boot: CLOJURE_VERSION=$(V18)
clj18-boot: CLOJURE_VERSION_LOWER=$(shell echo $(CLOJURE_VERSION) | tr A-Z a-z)
clj18-boot: BUILD_TOOL=boot
clj18-boot: clj18

clj110-boot: CLOJURE_VERSION=$(V110)
clj110-boot: CLOJURE_VERSION_LOWER=$(shell echo $(CLOJURE_VERSION) | tr A-Z a-z)
clj110-boot: BUILD_TOOL=boot
clj110-boot: clj110

.PHONY: setup setup-deps setup-build-tool teardown \
		clj clj16 clj17 clj18 clj19 clj110 \
		clj16-lein clj17-lein clj18-lein clj19-lein clj110-lein \
		clj16-boot clj17-boot clj18-boot clj19-boot clj110-boot \
		clj16-all clj17-all clj18-all clj19-all clj110-all
