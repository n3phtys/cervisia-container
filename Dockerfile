FROM ekidd/rust-musl-builder  AS compiler

RUN echo "Will run musl-builder first to build frontend and backend, and copy artifacts into a final alpine image"

USER root

# RUN echo "deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-6.0 main" >> /etc/apt/sources.list

# RUN echo "deb-src http://apt.llvm.org/xenial/ llvm-toolchain-xenial-6.0 main" >> /etc/apt/sources.list

# RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -

RUN mkdir /var/lib/apt/lists/partial && apt-get update && apt-get install -y build-essential wget libssl-dev curl git bash gnupg apt-file pkg-config libssl-dev apt-utils nano && apt-get update && apt-get install -y clang-6.0 lldb-6.0 lld-6.0







RUN apt-get update
RUN printenv



#RUN ls -la /usr/include
#RUN ls -la /usr/include/openssl
#RUN ls -la /usr
#RUN ls -la /usr/lib
#RUN ls -la /usr/local/ssl
#RUN ls -la /usr/lib
#RUN ls -la /usr/lib/ssl




RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -

RUN apt-get install -y nodejs 

RUN npm install -g @angular/cli

RUN npm --version
RUN git --version

WORKDIR /root/.cervisia-server/
WORKDIR /usr/cervisia/frontend/
WORKDIR /usr/cervisia/backend/
WORKDIR /usr/cervisia/

RUN git clone --recursive https://github.com/n3phtys/ng-cervisia
WORKDIR /usr/cervisia/ng-cervisia
RUN echo "export function gitLog() {   return \`" > src/app/git_log.ts && git log --pretty=medium | tr "\`$" _ >> src/app/git_log.ts && echo "\`};" >> src/app/git_log.ts
RUN ls -la . && ls -la src && ls -la src/assets
RUN npm install
RUN ng build --prod
#--base-href /bierliste-test/
WORKDIR /usr/cervisia/
RUN rm -rf /usr/cervisia/frontend
RUN mkdir /usr/cervisia/frontend
RUN ls -la /usr/cervisia/ng-cervisia
RUN cp -a /usr/cervisia/ng-cervisia/dist/. /usr/cervisia/frontend/
RUN rm -rf ng-cervisia


WORKDIR /usr/cervisia/

RUN git clone --recursive https://github.com/n3phtys/cervisia-server

RUN chown -R rust:rust cervisia-server

USER rust


WORKDIR /usr/cervisia/
RUN cargo --version

WORKDIR /usr/cervisia/cervisia-server


RUN cargo build --release
#RUN export OPENSSL_INCLUDE_DIR=/usr/include/openssl && export OPENSSL_LIB_DIR=/usr/lib/x86_64-linux-gnu && export OPENSSL_STATIC=1 && ls -la /usr/lib/ssl && apt-file list libssl-dev && printenv && cargo build --release --target=x86_64-unknown-linux-musl


RUN ls /usr/bin/
RUN ls -la /usr/cervisia/cervisia-server/target
RUN ls -la /usr/cervisia/cervisia-server/target/x86_64-unknown-linux-musl/release
RUN ld.lld-6.0 /usr/cervisia/cervisia-server/target/x86_64-unknown-linux-musl/release/cervisia-server


USER root

WORKDIR /usr/cervisia/
RUN rm -rf /usr/cervisia/backend
RUN mkdir /usr/cervisia/backend
RUN ls -la /usr/cervisia/cervisia-server/target/x86_64-unknown-linux-musl/release

RUN md5sum /usr/cervisia/cervisia-server/target/x86_64-unknown-linux-musl/release/cervisia-server

RUN cp -a /usr/cervisia/cervisia-server/target/x86_64-unknown-linux-musl/release/cervisia-server /usr/cervisia/backend/
RUN rm -rf cervisia-server

RUN md5sum /usr/cervisia/backend/cervisia-server

FROM alpine:latest

RUN apk update && apk add ca-certificates curl && rm -rf /var/cache/apk/*
RUN update-ca-certificates


RUN echo "building new"

COPY --from=compiler /usr/cervisia /usr/cervisia


RUN md5sum /usr/cervisia/backend/cervisia-server

ENV CERVISIA_WEB_PATH /usr/cervisia/frontend/

WORKDIR /db/
WORKDIR /usr/cervisia/

RUN ls -la /usr
RUN echo "Hello World"
RUN ls -la /usr/cervisia
RUN ls -la /usr/cervisia/backend
RUN ls -la /usr/cervisia/frontend
