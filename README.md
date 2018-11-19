# clojure-docker

This repo contains the generating `Makefile` for oft-used Clojure `Dockerfile`s
supporting varying versions of Clojure, clj-tools, and optionally, `lein`.

`make` targets are listed below for `Dockerfile`s without `lein`, and then
those with it. All containers do come with cli-tools, `clj`, and `clojure`.

clj-tools (i.e., just using `deps.cfg`) only:
* `make clj16` creates tag `clojusc/clojure-1.6.0-jdk-11.0.1`
* `make clj17` creates tag `clojusc/clojure-1.7.0-jdk-11.0.1`
* `make clj18` creates tag `clojusc/clojure-1.8.0-jdk-11.0.1`
* `make clj19` creates tag `clojusc/clojure-1.9.0-jdk-11.0.1`
* `make clj110` creates tag `clojusc/clojure-1.10.0-beta6-jdk-11.0.1`

clj-tools with `lein`:
* `make clj16-lein` creates tag `clojusc/clojure-1.6.0-lein-jdk-11.0.1`
* `make clj17-lein` creates tag `clojusc/clojure-1.7.0-lein-jdk-11.0.1`
* `make clj18-lein` creates tag `clojusc/clojure-1.8.0-lein-jdk-11.0.1`
* `make clj19-lein` creates tag `clojusc/clojure-1.9.0-lein-jdk-11.0.1`
* `make clj110-lein` creates tag `clojusc/clojure-1.10.0-beta6-lein-jdk-11.0.1`
