#!/bin/sh
# Import errata to spacewalk

ERRATA_FILE=errata.latest.xml
ERRATA_URL=https://github.com/stevemeier/cefs/raw/master/errata-import.pl

RHSA_FILE=com.redhat.rhsa-all.xml
RHSA_URL=https://cefs.b-cdn.net/errata.latest.xml

UPDATED=0

cd "$(dirname "$0")"

for FILE in ERRATA RHSA; do
        GETFILE=${FILE}_FILE
        GETURL=${FILE}_URL

        if test -e "${!GETFILE}"
        then
                zflag="-z ${!GETFILE}"
        else
                zflag=
        fi
        curl -s -o ${!GETFILE} $zflag ${!GETURL}
done

export SPACEWALK_USER=errata
export SPACEWALK_PASS=3rr4t41mp0rt
./errata-import.pl --server localhost --errata ${ERRATA_FILE} --rhsa-oval ${RHSA_FILE} --publish >> ./errata-import.log
