#!/bin/bash

set -ouex pipefail

echo "Defining variables"

DEFAULT_FOLDER=/tmp/dnf

COPR_REPOS_FILE=/tmp/dnf/copr_repos
RPM_INSTALL_LIST_FILE=/tmp/dnf/repo_rpm_install
DISTANT_RPM_INSTALL_LIST_FILE=/tmp/dnf/distant_rpm_install
RPM_UNINSTALL_LIST_FILE=/tmp/dnf/rpm_uninstall

GIT_COPR_REPOS_FILE=/ctx/files/dnf/copr_repos
GIT_RPM_INSTALL_LIST_FILE=/ctx/files/dnf/packages_install
GIT_DISTANT_RPM_INSTALL_LIST_FILE=/ctx/files/dnf/non-repo_packages
GIT_RPM_UNINSTALL_LIST_FILE=/ctx/files/dnf/packages_remove



# ================================================================================

echo 'Copying gitfiles to tmp'

mkdir ${DEFAULT_FOLDER}

cp $GIT_COPR_REPOS_FILE $COPR_REPOS_FILE
cp $GIT_RPM_INSTALL_LIST_FILE $RPM_INSTALL_LIST_FILE
cp $GIT_DISTANT_RPM_INSTALL_LIST_FILE $DISTANT_RPM_INSTALL_LIST_FILE
cp $GIT_RPM_UNINSTALL_LIST_FILE $RPM_UNINSTALL_LIST_FILE

# ================================================================================

echo "Setting dnf variables"

COPR_REPOS=$(< $COPR_REPOS_FILE)
PACKAGE_REMOVE=$(< $RPM_UNINSTALL_LIST_FILE)
REPO_PACKAGES_INSTALL=$(< $RPM_INSTALL_LIST_FILE)
DISTANT_PACKAGES_INSTALL=$(< $DISTANT_RPM_INSTALL_LIST_FILE)

# ================================================================================

echo "Enabling COPR repos"

    for repo in $COPR_REPOS; do
        dnf5 copr enable $repo -y
    done

echo "Removing packages"

    dnf5 remove -y $PACKAGE_REMOVE

echo "Installing packages"

    dnf5 install --skip-broken --skip-unavailable -y $REPO_PACKAGES_INSTALL
    dnf5 install --skip-broken --skip-unavailable -y $DISTANT_PACKAGES_INSTALL

echo "Disabling COPR repos"

    for repo in $COPR_REPOS; do
        dnf5 copr disable $repo -y
    done