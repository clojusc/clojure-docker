clj:
	if [ -z "$(BUILD_TOOL)" ]; then \
	docker build ./$(CLOJURE_VERSION) -t clojusc/clojure-$(CLOJURE_VERSION)-jdk-11.0.1; \
	else \
	docker build ./$(CLOJURE_VERSION) -t clojusc/clojure-$(CLOJURE_VERSION)-$(BUILD_TOOL)-jdk-11.0.1; \
	fi

clj19: CLOJURE_VERSION=1.9.0
clj19: clj

setup:
	mkdir $(CLOJURE_VERSION)
	cp common/Dockerfile ./$(CLOJURE_VERSION)/
	sed 's/CLOJURE_VERSION/$(CLOJURE_VERSION)/g' common/deps.edn > ./$(CLOJURE_VERSION)/deps.edn
	if [ "$(BUILD_TOOL)" = "lein" ]; then \
	cat common/Dockerfile.lein >> ./$(CLOJURE_VERSION)/Dockerfile; \
	fi

teardown:
	rm -rf $(CLOJURE_VERSION)

## Clojure-only
	
clj16: CLOJURE_VERSION=1.6.0
clj16: setup clj teardown
	
clj17: CLOJURE_VERSION=1.7.0
clj17: setup clj teardown
	
clj18: CLOJURE_VERSION=1.8.0
clj18: setup clj teardown

clj110: CLOJURE_VERSION=1.10.0-beta6
clj110: setup clj teardown

## With lein

clj16-lein: BUILD_TOOL=lein
clj16-lein: clj16

clj17-lein: BUILD_TOOL=lein
clj17-lein: clj17

clj18-lein: BUILD_TOOL=lein
clj18-lein: clj18

clj19-lein: BUILD_TOOL=lein
clj19-lein: clj19

clj110-lein: BUILD_TOOL=lein
clj110-lein: clj110

