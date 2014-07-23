FROM centos:haskell

ENV LANG en_US.UTF-8

RUN cabal update

RUN cabal install -j mighttpd2

ENTRYPOINT ["mighty", "/var/mighty/conf", "/var/mighty/route"]
