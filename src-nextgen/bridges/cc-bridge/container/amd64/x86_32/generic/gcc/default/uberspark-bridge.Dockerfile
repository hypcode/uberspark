FROM amd64/ubuntu:16.04
LABEL maintainer="Amit Vasudevan <amitvasudevan@acm.org>, Matt McCormack <matthew.mccormack@live.com>" author="Matt McCormack <matthew.mccormack@live.com>"

RUN apt-get update &&\
    apt-get -yqq install gcc gcc-multilib binutils &&\
    apt-get clean && rm -rf /var/lib/apt/lists/* &&\
