#!/bin/bash

URL="http://www.baidupcs.com/file/DotEmacs/plugins.zip?fid=4130003383-250528-4219421743&time=1354673830&sign=FPDTAE-DCb740ccc5511e5e8fedcff06b081203-%2FjJS7%2F4Wq4mhcsOY2yPL4WnF1yo%3D&expires=8h&digest=2f55fd3f4fc3c4acfc9baca1b168869a&sh=1&response-cache-control=private"
DEST=plugins.zip

wget $URL -O $DEST
unzip $DEST 
