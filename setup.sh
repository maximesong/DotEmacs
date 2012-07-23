#!/bin/bash

function git_update() {
    repository=$1
    dir=$PLUGIN_DIR/`perl -e 'print ((split "/", $ARGV[0])[-1])' $repository`
    if [ -d $dir ]; then
	cd $dir
	git pull origin master
    else
	cd $PLUGIN_DIR
	git clone $repository
    fi
}

function file_update() {
    url=$1
    filename=`perl -e 'print ((split "/", $ARGV[0])[-1])' $url`
    if [ -f $filename ]; then
	read -p ">> File $filename already exists.
>> Download and OVERWRITE it anyway?(y/n)" ANSWER
	if [ $ANSWER == 'y' ]; then
	    wget $url -O $filename
	fi
    else
	wget $url -O $filename
    fi
}

ROOT_DIR=$PWD
PLUGIN_DIR=$ROOT_DIR/plugins
MISC_DIR=$PLUGIN_DIR/misc

mkdir -p $PLUGIN_DIR
cp $ROOT_DIR/subdirs.el $PLUGIN_DIR
cd $PLUGIN_DIR
mkdir -p $MISC_DIR

git_update "git://github.com/m2ym/auto-complete"
git_update "git://github.com/capitaomorte/yasnippet"
git_update "https://github.com/m2ym/popup-el"
git_update "https://github.com/m2ym/fuzzy-el"
git_update "https://github.com/jochu/clojure-mode"

cd $MISC_DIR
file_update "http://users.skynet.be/ppareit/projects/graphviz-dot-mode/graphviz-dot-mode.el"

if [ -d ~/.emacs.d/ ]; then
    mv ~/.emacs.d/ ~/.emacs.d.old/
fi

mkdir ~/.emacs.d
cp -r $PLUGIN_DIR $ROOT_DIR/dot.el ~/.emacs.d/
