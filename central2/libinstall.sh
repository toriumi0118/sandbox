#!/bin/sh

cabal sandbox init

if [ ! -e lib ]; then
    mkdir lib
fi

if [ ! -e lib/haskell-relational-record ]; then
	cd lib
    git clone git@github.com:khibino/haskell-relational-record.git
	cd -
else
    cd lib/haskell-relational-record
    git pull
	cd -
fi
cabal sandbox add-source \
    lib/haskell-relational-record/names-th \
    lib/haskell-relational-record/sql-words \
    lib/haskell-relational-record/persistable-record \
    lib/haskell-relational-record/relational-query \
    lib/haskell-relational-record/relational-schemas \
    lib/haskell-relational-record/HDBC-session \
    lib/haskell-relational-record/relational-query-HDBC


cd lib
if [ ! -e hdbc-mysql ]; then
	git clone git@github.com:bos/hdbc-mysql.git
fi
cd -
cabal sandbox add-source lib/hdbc-mysql

if [ ! -e lib/haskell-relational-record-driver-mysql ]; then
	cd lib
	git clone git@github.com:yunomu/haskell-relational-record-driver-mysql.git
	cd -
fi
cabal sandbox add-source lib/haskell-relational-record-driver-mysql
