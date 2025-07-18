FROM ubuntu:noble-20250714

RUN \
  apt update && \
  apt install -y git curl rsync unzip python3-pip && \
  pip3 install shyaml && \
  useradd --create-home --shell /bin/bash build && \
  mkdir -p /home/build/src && \
  chown build:build /home/build/src

USER build
WORKDIR /home/build/src
ENTRYPOINT ["/bin/bash", "-c"]
