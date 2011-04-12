#!/bin/bash
# set -eux
set -eu

HTTPDIR='/srv/www/htdocs'
HTTPURL=$EG_URL
PUBLICDIR='/tmp/public'
group='users'
SSH='ssh://$HOST_SF'

echo HTTPDIR=$HTTPDIR
echo HTTPURL=$HTTPURL
echo PUBLICDIR=$PUBLICDIR
echo group=$group
echo SSH=$SSH

# args: MYREPO
init_repo()
{
  MYREPO=$1
  #init repo
  cd $MYREPO
  git init
  touch hello
  git add hello
  git commit -a -m "hello"
  cd -
  echo "Use this command to test it: cd $MYREPO && git status"
}

# args: MYREPO PUBLICREPO
publicize_repo()
{
  MYREPO=$1
  PUBLICREPO=$2
  PUBLICDIR=$3
  # Setting up a public repository
  # Assume your personal repository is in the directory ~/proj. We first create a new clone of the repository and tell git daemon that it is meant to be public:
  cd $PUBLICDIR
  git clone --bare $MYREPO $PUBLICREPO
  touch $PUBLICREPO/git-daemon-export-ok
  cd -
  echo "Use this command to test it: git clone $PUBLICDIR/$PUBLICREPO"
}

# args: PUBLICREPO HTTPREPO PUBLICDIR HTTPDIR HTTPURL
export_repo_via_http()
{
  PUBLICREPO=$1
  HTTPREPO=$2
  PUBLICDIR=$3
  HTTPDIR=$4
  HTTPURL=$5
  # Exporting a git repository via http
  # The git protocol gives better performance and reliability, but on a host with a web server set up, http exports may be simpler to set up.
  # All you need to do is place the newly created bare git repository in a directory that is exported by the web server, and make some adjustments to give web clients some extra information they need:
#   sudo mkdir $HTTPDIR/$HTTPREPO
#   chmod 755 $HTTPDIR/$HTTPREPO
  sudo cp -r $PUBLICDIR/$PUBLICREPO $HTTPDIR/$HTTPREPO.git
  cd $HTTPDIR/$HTTPREPO.git
  sudo git --bare update-server-info
  sudo chmod a+x hooks/post-update
#   sudo mv hooks/post-update.sample hooks/post-update
  cd -
  echo "Use this command to test it: git clone $HTTPURL/$HTTPREPO.git"
}

# args: MYREPO SHAREDREPO
share_repo()
{
  MYREPO=$1
  SHAREDREPO=$2
  # Setting Up a Shared Repository
  # We assume you have already created a git repository for your project, possibly created from scratch or from a tarball (see gittutorial(7)), or imported from an already existing CVS repository (see the next section).
  # Assume your existing repo is at /home/alice/myproject. Create a new "bare" repository (a repository without a working tree) and fetch your project into it:
  cd $SHAREDREPO.git
  git --bare init --shared
  git --bare fetch $MYREPO master:master
  chgrp -R $group $SHAREDREPO.git
  cd -
  echo "Use this command to test it: su jcool -c 'cd && git clone $SHAREDREPO.git && cd $(basename $SHAREDREPO) && touch bye && git add bye && git commit -a -m bye && git push'"
}

# args: SRC DST
create_public_shared_http_repo()
{
  SRC=$1
  DST=$2
  sudo mkdir -p $HTTPDIR/$DST.git
  cd $HTTPDIR/$DST.git
  sudo git --bare init --shared
  sudo git --bare fetch $SRC master:master
  sudo chgrp -R $group $HTTPDIR/$DST.git
  sudo touch git-daemon-export-ok
  sudo git --bare update-server-info
  sudo chmod a+x hooks/post-update
  cd -

  echo "Use this command to test http checkout: git clone $HTTPURL/$DST.git"
  echo "Use this command to test ssh checkout and push: su jcool -c 'cd && git clone $SSH/$HTTPDIR/$DST.git && cd $(basename $HTTPDIR/$DST) && touch bye && git add bye && git commit -a -m bye && git push'"
}

# args: SRC DST
create_shared_repo()
{
  SRC=$1
  DST=$2
  sudo mkdir -p $DST.git
  cd $DST.git
  sudo git --bare init --shared
  sudo git --bare fetch $SRC master:master
  sudo chgrp -R $group $DST.git
  cd -

  echo "Use this command to test it: su jcool -c 'cd && git clone $DST.git && cd $(basename $DST) && touch bye && git add bye && git commit -a -m bye && git push'"
}

# args: SRC DST
create_public_http_repo_from_shared_repo()
{
  SRC=$1
  DST=$2
  sudo mkdir -p $HTTPDIR/$DST.git
  cd $HTTPDIR/$DST.git
  sudo git --bare init
  sudo git --bare fetch $SRC master:master
  sudo chgrp -R $group $HTTPDIR/$DST.git
  sudo touch git-daemon-export-ok
  sudo git --bare update-server-info
  sudo chmod a+x hooks/post-update
  cd -

#   cd $SRC
#   sudo chmod a+x hooks/post-update
#   sudo sed -i.bak '$a\cd '$HTTPDIR'/'$DST'.git && git --bare fetch '$SRC' master:master' hooks/post-update
#   cd -

  echo "Use this command to test http checkout: git clone $HTTPURL/$DST.git"
  echo "Use this command to test ssh checkout and push (push should fail): su jcool -c 'cd && git clone $SSH/$HTTPDIR/$DST.git && cd $(basename $HTTPDIR/$DST .git) && touch bye && git add bye && git commit -a -m bye && git push'"
  echo "Use this command to modify the shared repository: git clone $SSH/$SRC && cd $(basename $SRC .git) && touch bye && git add bye && git commit -a -m bye && git push"

  echo "SRC= $SRC"
  echo "SRC SSH= $SSH/$SRC"
  echo "HTTP= $HTTPURL/$DST.git"
  echo "SSH= $SSH/$HTTPDIR/$DST.git"
  echo "DST= $HTTPDIR/$DST.git"
  echo "Add the following line to root crontab:"
  echo "cd $HTTPDIR/$DST.git && git --bare fetch $SRC master:master && git-update-server-info"
  echo "or run this command manually:"
  echo "cd $HTTPDIR/$DST.git && sudo git --bare fetch $SRC master:master && sudo git-update-server-info"

#   cd $PUBLICDIR
#   git clone --bare $MYREPO $PUBLICREPO
#   touch $PUBLICREPO/git-daemon-export-ok
#   cd -
#   echo "Use this command to test it: git clone $PUBLICDIR/$PUBLICREPO"
# 
#   sudo cp -r $PUBLICDIR/$PUBLICREPO $HTTPDIR/$HTTPREPO.git
#   cd $HTTPDIR/$HTTPREPO.git
#   sudo git --bare update-server-info
#   sudo chmod a+x hooks/post-update
#   cd -
#   echo "Use this command to test it: git clone $HTTPURL/$HTTPREPO.git"
}

test_functions()
{
  MYREPO=$(mktemp -d)
  PUBLICREPO=$RANDOM
  SHAREDREPO=$(mktemp -d)
  HTTPREPO=$RANDOM
  
  echo MYREPO=$MYREPO
  echo PUBLICREPO=$PUBLICREPO
  echo SHAREDREPO=$SHAREDREPO
  echo HTTPREPO=$HTTPREPO
  
  init_repo $MYREPO
  
  publicize_repo $MYREPO $PUBLICREPO $PUBLICDIR
  
  export_repo_via_http $PUBLICREPO $HTTPREPO $PUBLICDIR $HTTPDIR $HTTPURL
  
  share_repo $MYREPO $SHAREDREPO
}

test_functions_2()
{
  MYREPO=$(mktemp -d)
  PUBLICREPO=$RANDOM
  SHAREDREPO=/tmp/$RANDOM
  HTTPREPO=$RANDOM
  HTTPREPO2=$RANDOM
  
  echo MYREPO=$MYREPO
  echo PUBLICREPO=$PUBLICREPO
  echo SHAREDREPO=$SHAREDREPO
  echo HTTPREPO=$HTTPREPO
  echo HTTPREPO2=$HTTPREPO2
  
  init_repo $MYREPO
  
  create_shared_repo $MYREPO $SHAREDREPO
  
  create_public_shared_http_repo $MYREPO $HTTPREPO

  create_public_http_repo_from_shared_repo  $SHAREDREPO.git $HTTPREPO2
}
