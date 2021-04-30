# This is the template of `myconfig.sh`, and the later
# will be included in every script.

# PLEASE COPY THIS FILE TO `myconfig.sh`,
# AND CHANGE THE FOLLOWING GLOBAL VARIABLES FOR YOUR CUSTOMIZATION.

#
# The URL prefix of remote repository.

# Use this if you want to visit the repos on gitlab.fmsoft.cn via HTTPS
REPO_URL=https://gitlab.fmsoft.cn/VincentWei

# Use this one if you are a developer of MiniGUI
# REPO_URL=git4os@gitlab.fmsoft.cn:VincentWei

# Use this if you want to visit GitHub via HTTPS
# REPO_URL=https://github.com/VincentWei

# Use this one if you can visit GitHub via SSH
# REPO_URL=git@github.com:VincentWei

#
# The branch name
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

