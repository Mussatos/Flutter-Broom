FROM ubuntu:24.04

WORKDIR '/usr/src/broom'

RUN sudo apt-get update -y && sudo apt-get upgrade -y;

RUN sudo snap install flutter --classic

COPY . .
