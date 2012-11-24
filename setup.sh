#!/bin/bash

function git_update() {
    repository=`perl -e 'print $ARGV[0] =~ s/.git$//r' $1`
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
	read -p "
## File $filename already exists.
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

echo '(defun my-add-subdirs-to-load-path (dir)
  (let ((default-directory (concat dir "/")))
    (setq load-path (cons dir load-path))
    (normal-top-level-add-subdirs-to-load-path)))
(my-add-subdirs-to-load-path "~/.emacs.d/plugins")' > $PLUGIN_DIR/subdirs.el

cd $PLUGIN_DIR
mkdir -p $MISC_DIR

git_update "https://github.com/auto-complete/popup-el"
git_update "https://github.com/auto-complete/fuzzy-el"
git_update "git://github.com/auto-complete/auto-complete"
git_update "git://github.com/capitaomorte/yasnippet"
git_update "https://github.com/jochu/clojure-mode"
git_update "https://github.com/brianc/jade-mode.git"
git_update "https://github.com/defunkt/coffee-mode.git"
git_update "git://jblevins.org/git/markdown-mode.git"
git_update "https://github.com/myfreeweb/less-mode.git"

cd $MISC_DIR
file_update "http://users.skynet.be/ppareit/projects/graphviz-dot-mode/graphviz-dot-mode.el"

if [ ! -f "~/.emacs" ]; then
	cat > ~/.emacs << EOF
(load-file "~/.emacs.d/dot.el")
(load-file "~/.emacs.d/func.el")
EOF
fi

if [ -d ~/.emacs.d/ ]; then
	read -p "
## Directory ~/.emacs.d/ already exists.
### What should I do?(a for abort, o for overwrite, b for backup and overwrite)
>>" ANSWER
	if [ $ANSWER == 'o' ]; then
	    rm -rf ~/.emacs.d
	elif [ $ANSWER == 'b' ]; then
	    backupDir=~/.emacs.d.`date +%Y_%m_%d_%k%M`
	    rm -rf $backupDir
	    mv ~/.emacs.d $backupDir
	else
	    exit
	fi
fi

mkdir ~/.emacs.d
cp -r $PLUGIN_DIR $ROOT_DIR/dot.el $ROOT_DIR/func.el ~/.emacs.d/

echo
echo "Setup of DotEmacs complete. Enjoy it."
