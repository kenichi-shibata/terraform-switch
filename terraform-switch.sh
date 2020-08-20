#!/usr/bin/env bash

tfdownload() {
    local system=$(uname -s | tr 'A-Z' 'a-z')
    local version=${1:-0.12.18}
    mkdir -p ${HOME}/.terraform
    pushd /tmp
    #set -e
    wget -c "https://releases.hashicorp.com/terraform/${version}/terraform_${version}_${system}_amd64.zip"
    unzip "terraform_${version}_${system}_amd64.zip"
    mv terraform "${HOME}/.terraform/terraform-${version}"
    #set +e
    popd
}

tfactivate() {
    activate() {
      ln -sf "${HOME}/.terraform/terraform-${version}" ${HOME}/bin/terraform
      command -V terraform
      terraform --version
    }
    local version=${1:-0.12.18}
    if [ -x "${HOME}/.terraform/terraform-${version}" ]; then
      activate
    else
      tfdownload ${version}
      activate
    fi
}
tfactivate_hyphenate() {
    activate() {
      mkdir -p ${HOME}/bin/
      ln -sf "${HOME}/.terraform/terraform-${version}" ${HOME}/bin/terraform-${version}
      echo ${HOME}/bin/terraform-${version}
      ${HOME}/bin/terraform-${version} --version
    }
    local version=${1:-0.12.18}
    if [ -x "${HOME}/.terraform/terraform-${version}" ]; then
      activate
    else
      tfdownload ${version}
      activate
    fi
}

tfversions() {
  ls -1t "${HOME}/.terraform/" 2>&1 | sed -e "s/^terraform-//" | sort -n
}

#tfactivate_main $1
tfactivate_hyphenate $1
