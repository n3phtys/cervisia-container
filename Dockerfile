FROM ubuntu:rolling
RUN apt-get update
RUN apt-get install -y build-essential
RUN apt-get install -y curl file git nodejs npm 
RUN npm install -g @angular/cli
RUN curl -sf -L https://static.rust-lang.org/rustup.sh | sh


RUN npm --version
RUN git --version
RUN cargo --version

WORKDIR /.cervisia-server/
WORKDIR /usr/cervisia/frontend/
WORKDIR /usr/cervisia/backend/
WORKDIR /usr/cervisia/

COPY startup.sh /usr/cervisia/
COPY Settings.toml /.cervisia-server/

EXPOSE 8080
ENTRYPOINT  ["/usr/cervisia/startup.sh"]