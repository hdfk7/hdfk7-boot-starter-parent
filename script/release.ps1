$module = "hdfk7-boot-starter-parent"
$version = "1.1.1"

$work = Get-Location
$target = "target"
$staging = "$target/central-staging"
$publishing = "$work/$target/central-publishing"
$path = "$staging/cn/hdfk7/boot/$module/$version"
$pom = "$module-$version.pom"

mvn clean install
New-Item -ItemType Directory -Force -Path $path
New-Item -ItemType Directory -Force -Path $publishing
Copy-Item "pom.xml" "$path/$pom"
Set-Location $path

gpg --armor --output "$pom.asc" --detach-sig $pom
Get-FileHash $pom -Algorithm MD5 | ForEach-Object { $_.Hash } | Set-Content "$pom.md5"
Get-FileHash $pom -Algorithm SHA1 | ForEach-Object { $_.Hash } | Set-Content "$pom.sha1"
Get-FileHash $pom -Algorithm SHA256 | ForEach-Object { $_.Hash } | Set-Content "$pom.sha256"
Get-FileHash $pom -Algorithm SHA512 | ForEach-Object { $_.Hash } | Set-Content "$pom.sha512"

Set-Location "$work/$staging"
Compress-Archive -Path "./*" -DestinationPath "$publishing/central-bundle.zip"

Set-Location "$work"
