#!/bin/sh
START="$1"
END="$2"
i="$START"

while [ $i -ge $END ]; do
      wget http://torrents.thepiratebay.org/$i/$i.torrent --header="host: torrents.thepiratebay.org"
      sleep 0.3
      i=$[$i - 1];
done
