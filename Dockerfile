WORKDIR /app
ADD . .
RUN echo '{ "allow_root": true }' > ~/.bowerrc
RUN npm config set unsafe-perm true
RUN npm config set no-package-lock true
RUN npm install

FROM golang:1.8 AS server
WORKDIR /go/src/github.com/jingweno/jqplay
ADD . .
RUN CGO_ENABLED=0 && go build -a -ldflags '-extldflags "-static"' -o /go/bin/jqplay ./cmd/jqplay 

FROM centos:7
WORKDIR /app
ADD bin bin
COPY --from=server /go/bin/jqplay bin/jqplay
COPY --from=front /app/public public
ENV PORT 80
EXPOSE 80

CMD ["bin/jqplay"]
