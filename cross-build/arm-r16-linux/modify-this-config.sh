# This is the template of `myconfig.sh`, and the later
# will be included in every script.

# You must set TINA_DIR for r16 tina dirctory.
# It is the ONLY line you have to modify in the whole compiling process. 
TINA_DIR=/home/projects/r16/tinav2.5

#
# The URL prefix of remote repository.

# Use this if you want to visit GitHub via HTTPS
REPO_URL=https://gitlab.fmsoft.cn/VincentWei

# Use this one if you can visit GitHub via SSH
# REPO_URL=git@github.com:VincentWei

# Use this one if you are a developer of MiniGUI
# REPO_URL=git4os@gitlab.fmsoft.cn:VincentWei

#
# The branch name; MiniGUI 5.0 is in preview stage, and the code is
# located in dev-4-1 branch
BRANCH_NAME=rel-5-0

#
# Global configuration options for MiniGUI Core and components.
# GOPTS="--enable-develmode"
GOPTS=

#
# extra options for configuring MiniGUI Core.
# MGOPTS="--with-targetname=external"
MGOPTS=

#
# The jobs number for building source.
NRJOBS=`getconf _NPROCESSORS_ONLN`
