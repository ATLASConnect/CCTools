#!/bin/sh

# The CCTOOLS we are to use
cctoolsVer="4.2.0rc2"
#cctoolsVer="4.1.4rc5"
#cctoolsVer="4.1.3"

# Override the default it given
[[ ! -z $1 ]] && cctoolsVer=$1


# Where all our needed files should live
buildHome="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Create a temporary working area
tmpHome=$(mktemp -d)

# Stop now if we dont have a workspace
[[ -z ${tmpHome} ]] && exit 255


# Transfer to the working location
pushd ${tmpHome} > /dev/null

# Fetch both 32 and 64 bit releases
#wget --quiet http://www3.nd.edu/~ccl/software/files/cctools-${cctoolsVer}-x86_64-redhat6.tar.gz
#wget --quiet http://www3.nd.edu/~ccl/software/files/cctools-${cctoolsVer}-i686-redhat6.tar.gz
wget --quiet http://ccl.cse.nd.edu/software/files/cctools-${cctoolsVer}-x86_64-redhat6.tar.gz
wget --quiet http://ccl.cse.nd.edu/software/files/cctools-${cctoolsVer}-i686-redhat6.tar.gz

# Unpack both releases
tar xzf cctools-${cctoolsVer}-x86_64-redhat6.tar.gz
tar xzf cctools-${cctoolsVer}-i686-redhat6.tar.gz

# Create the workspace for our special CCTOOLS
mkdir cctools

# Move the 64 versions we want into our workspace
mv cctools-${cctoolsVer}-x86_64-redhat6/bin     cctools/bin
mv cctools-${cctoolsVer}-x86_64-redhat6/include cctools/include
mv cctools-${cctoolsVer}-x86_64-redhat6/lib     cctools/lib

# Put a copy of the libchirp_client.so into the lib64 area
cp cctools/lib/libchirp_client.so               cctools/lib/lib64

# Move the 32 bit parrot helper into a 32 bit lib area
mkdir cctools/lib/lib
mv cctools-${cctoolsVer}-i686-redhat6/lib/libparrot_helper.so      cctools/lib/lib


# Build our cctools tarball
tar czf cctools-${cctoolsVer}.tar.gz            cctools

# Move it our download area
rm -rf /home/www/parrot/cctools-${cctoolsVer}.tar.gz
mv cctools-${cctoolsVer}.tar.gz                 /home/www/parrot/cctools-${cctoolsVer}.tar.gz

# Return home
popd > /dev/null

# Cleanup our workspace
rm -rf ${tmpHome}
