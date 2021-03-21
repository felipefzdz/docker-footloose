FROM docker:20.10-dind
WORKDIR /footloose
RUN apk add --no-cache --update openssh-keygen \
    && wget https://github.com/weaveworks/footloose/releases/download/0.6.3/footloose-0.6.3-linux-x86_64 -O footloose \
    && chmod +x footloose \
    && mv footloose /usr/local/bin/

ENTRYPOINT ["footloose"]

