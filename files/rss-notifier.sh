#!/bin/bash

curl -o /tmp/rss-output-source.txt
diff /tmp/rss-output-source.txt /tmp/rss-output-target.txt
EXIT_STATUS=$?
cp /tmp/rss-output-source.txt /tmp/rss-output-target.txt
[ "$EXIT_STATUS" -ne 0 ] && exit 1
exit 0