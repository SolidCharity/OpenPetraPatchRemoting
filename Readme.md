Remoting Patch
==============

This is quite a big change to OpenPetra, it replaces the .Net remoting with Web Services that operate over http/https.

Since this is a big change, it is still not integrated into OpenPetra trunk.

This repository contains the patches needed, and will be updated irregularly to match recent versions of OpenPetra trunk.

Create a patch:
---------------

First download the trunk that the current remoting branch was derived from:

    wget -O trunk.tar.gz \
      http://bazaar.launchpad.net/~openpetracore/openpetraorg/trunkhosted/tarball/2514
    tar xzf trunk.tar.gz
    mv \~openpetracore/openpetraorg/trunkhosted trunk

Now download the current remoting branch:

    wget -O remoting.tar.gz \
      http://bazaar.launchpad.net/~christian-k/openpetraorg/20140211_replace_net_remoting/tarball/2426
    tar xzf remoting.tar.gz
    mv \~christian-k/openpetraorg/20140211_replace_net_remoting remoting

Now clone this repository:

    git clone git clone https://github.com/solidcharity/OpenPetraPatchRemoting.git

Now run:

    ./OpenPetraPatchRemoting/diff.sh OpenPetraPatchRemoting

Apply the patch:
----------------

Get the latest version from trunk:

    git clone https://github.com/openpetra/openpetra.git

Get this repository:

    git clone https://github.com/solidcharity/OpenPetraPatchRemoting.git

Now run:

    ./OpenPetraPatchRemoting/patch.sh openpetra OpenPetraPatchRemoting

To verify the patch:
--------------------
Apply the patch to trunk where the patch is based on, as described above.

Then run:

    diff -uNr -x .bzr -x .git openpetra remoting

There should not be any difference.

