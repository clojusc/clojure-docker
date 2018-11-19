FROM clojusc/clojure-1.9.0-jdk-11.0.1

WORKDIR /clojure
COPY deps.edn /clojure
RUN clojure --eval '(println "Finished downloading core Clojure files.")'
