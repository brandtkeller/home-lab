# Figure out what version of gpg your running
gpg --version | head -n 1
# Centos 7 and older AmazonLinux tend to run gpg 2.0.x
# Centos 8, Ubuntu 20, and Debian 11 tend run gpg 2.2.x
# Centos 9 and Mac tend to run gpg 2.3.x

# Generate a GPG master key
# Note:
# By default, gpg 2.3.x generated keys, will generate errors when
# consumed by clients running gpg 2.0.x - 2.2.x
# gpg 2.3.x users must use the following multiline keygen command for
# compatibility with sops and older clients using gpg 2.0.x - 2.2.x
# gpg 2.2.x users should also user the following key gen multiline command
# gpg 2.0.x users substitute --full-generate-key for --gen-key
#
# Using this multiline command to generate the key makes it work in all cases.
gpg --batch --full-generate-key --rfc4880 --digest-algo sha512 --cert-digest-algo sha512 <<EOF
    %no-protection
    # %no-protection: means the private key won't be password protected
    # (no password is a fluxcd requirement, it might also be true for argo & sops)
    Key-Type: RSA
    Key-Length: 4096
    Subkey-Type: RSA
    Subkey-Length: 4096
    Expire-Date: 0
    Name-Real: bigbang-dev-environment
    Name-Comment: bigbang-dev-environment
EOF

# The following command will store the GPG Key's Fingerprint in the $fp variable
# (The following command has been verified to work consistently between multiple versions of gpg: 2.0.x, 2.2.x, 2.3.x)
export fp=$(gpg --list-keys --fingerprint | grep "dev-environment" -B 1 | grep -v "dev-environment" | tr -d ' ' | tr -d 'Keyfingerprint=')
echo $fp

# The above command will make a key that doesn't expire
# You can optionally run the following if you need the key to expire after 1 year.
gpg --quick-set-expire ${fp} 1y

# cd to the location of the .sops.yaml, then run the following to set the encryption key
# sed: stream editor is like a cli version of find and replace
# This ensures your secrets are only decryptable by your key

## On linux
sed -i "s/pgp: FALSE_KEY_HERE/pgp: ${fp}/" .sops.yaml

## On MacOS
sed -i "" "s/pgp: FALSE_KEY_HERE/pgp: ${fp}/" .sops.yaml

# Save encrypted secrets into Git
# Configuration changes must be stored in Git to take affect
git add .sops.yaml
git commit -m "chore: update default encryption key"
git push --set-upstream origin template-demo


gpg --export-secret-key --armor ${fp} | kubectl create secret generic sops-gpg -n flux-system --from-file=devkey.asc=/dev/stdin