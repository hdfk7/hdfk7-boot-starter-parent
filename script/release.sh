#!/bin/bash -ile

export module=hdfk7-boot-starter-parent
export version=1.1.0

work=$(pwd)
export target="target"
export staging="${target}/central-staging"
export publishing="${work}/${target}/central-publishing"
export path="${staging}/cn/hdfk7/boot/${module}/${version}"
export pom="${module}-${version}.pom"

mvn clean install
mkdir -p "${path}"
mkdir -p "${publishing}"
cp pom.xml "${path}/${pom}"
cd $path

gpg --armor --output "${pom}.asc" --detach-sig $pom
md5 -q $pom > "${pom}.md5"
shasum -a 1 $pom | awk '{print $1}' > "${pom}.sha1"
shasum -a 256 $pom | awk '{print $1}' > "${pom}.sha256"
shasum -a 512 $pom | awk '{print $1}' > "${pom}.sha512"

cd "${work}/${staging}"
zip -r "${publishing}/central-bundle.zip" "./"
