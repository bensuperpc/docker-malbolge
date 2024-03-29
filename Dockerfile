ARG DOCKER_IMAGE=alpine:latest
FROM $DOCKER_IMAGE AS builder

RUN apk add --no-cache gcc make musl-dev git \
	&& git clone --recurse-submodules https://github.com/bensuperpc/malbolge.git
WORKDIR /malbolge
#--CPU=x86_64
RUN make install

RUN apk del gcc make musl-dev git

ARG DOCKER_IMAGE=alpine:latest
FROM $DOCKER_IMAGE AS runtime

LABEL author="Bensuperpc <bensuperpc@gmail.com>"
LABEL mantainer="Bensuperpc <bensuperpc@gmail.com>"

ARG VERSION="1.0.0"
ENV VERSION=$VERSION

RUN apk add --no-cache make

COPY --from=builder /usr/local/bin /usr/local/bin

ENV PATH="/usr/local/bin:${PATH}"

WORKDIR /usr/src/myapp

CMD ["", "-h"]

LABEL org.label-schema.schema-version="1.0" \
	  org.label-schema.build-date=$BUILD_DATE \
	  org.label-schema.name="bensuperpc/docker-malbolge" \
	  org.label-schema.description="build malbolge compiler" \
	  org.label-schema.version=$VERSION \
	  org.label-schema.vendor="Bensuperpc" \
	  org.label-schema.url="http://bensuperpc.com/" \
	  org.label-schema.vcs-url="https://github.com/Bensuperpc/docker-malbolge" \
	  org.label-schema.vcs-ref=$VCS_REF \
	  org.label-schema.docker.cmd="docker build -t bensuperpc/malbolge -f Dockerfile ."
