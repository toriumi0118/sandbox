#!/bin/sh

cabal sandbox init

if [ ! -e lib ]; then
    mkdir lib
fi
cd lib

if [ ! -e haskell-relational-record ]; then
    git clone git@github.com:khibino/haskell-relational-record.git
else
    cd haskell-relational-record
    git pull
fi
cd -
cabal sandbox add-source \
    lib/haskell-relational-record/names-th \
    lib/haskell-relational-record/sql-words \
    lib/haskell-relational-record/persistable-record \
    lib/haskell-relational-record/relational-query \
    lib/haskell-relational-record/relational-schemas \
    lib/haskell-relational-record/HDBC-session \
    lib/haskell-relational-record/relational-query-HDBC
