FROM ubuntu:resolute-20261105.1

RUN \
  apt update && \
  apt install -y git curl rsync unzip python3-pip pipx && \
  pipx ensurepath && \
  pipx install shyaml && \
  useradd --create-home --shell /bin/bash build && \
  mkdir -p /home/build/src && \
  chown build:build /home/build/src

USER build
WORKDIR /home/build/src
ENTRYPOINT ["/bin/bash", "-c"]
