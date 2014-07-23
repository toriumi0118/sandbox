FROM centos
MAINTAINER Yusuke Nomura <yunomu@gmail.com>

RUN yum update -y
RUN yum install -y tar bzip2 gcc wget gmp gmp-devel freeglut freeglut-devel perl zlib-devel

RUN wget http://www.haskell.org/ghc/dist/7.6.3/ghc-7.6.3-x86_64-unknown-linux.tar.bz2
RUN tar xvjf ghc-7.6.3-x86_64-unknown-linux.tar.bz2
RUN cd ghc-7.6.3 && ./configure && make install

RUN wget http://www.haskell.org/platform/download/2013.2.0.0/haskell-platform-2013.2.0.0.tar.gz
RUN tar xvzf haskell-platform-2013.2.0.0.tar.gz
RUN cd haskell-platform-2013.2.0.0 && ./configure && make && make install

RUN rm -rf ghc-7.6.3-x86_64-unknown-linux.tar.bz2 ghc-7.6.3 haskell-platform-2013.2.0.0.tar.gz haskell-platform-2013.2.0.0

RUN cabal update

RUN cabal install cabal-install

ENV PATH /.cabal/bin:$PATH
