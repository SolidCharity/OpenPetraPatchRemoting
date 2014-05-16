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
    mv \~openpetracore/openpetraorg/trunkhosted before

Now download the current remoting branch:

    wget -O remoting.tar.gz \
      http://bazaar.launchpad.net/~christian-k/openpetraorg/20140211_replace_net_remoting/tarball/2426
    tar xzf remoting.tar.gz
    mv \~christian-k/openpetraorg/20140211_replace_net_remoting patched

Now clone this repository:

    git clone git clone https://github.com/solidcharity/OpenPetraPatchRemoting.git

Now run:

    ./OpenPetraPatchRemoting/diff.sh OpenPetraPatchRemoting before patched

Apply the patch:
----------------

Get the latest version from trunk:

    git clone https://github.com/openpetra/openpetra.git
    # possibly go back to a certain revision
    git branch release2014_05 6e76e79b70e92ab783b47b60b946cd59d2b30596
    git checkout release2014_05

Get this repository:

    git clone https://github.com/solidcharity/OpenPetraPatchRemoting.git

Now run:

    ./OpenPetraPatchRemoting/patch.sh openpetra OpenPetraPatchRemoting

If there are conflicts, and the patch fails, you can fix the patch and reset the openpetra directory:

    git reset --hard
    git clean -f -d

To find problems and fixing them one by one:

    cd openpetra
    for f in ../OpenPetraPatchRemoting/patch/*; do echo $f; patch -p1 --dry-run < $f || break; done

You can fix a file in the working directory like this example:

    # apply part of the patch that is working
    patch -p1 < ../OpenPetraPatchRemoting/patch/csharp_ICT_Petra_Server_lib_MCommon_Main.cs.patch
    # see the .rej file: csharp/ICT/Petra/Server/lib/MCommon/Main.cs.rej
    # now manually fix the file
    vi csharp/ICT/Petra/Server/lib/MCommon/Main.cs
    # recreate the patch file
    git diff csharp/ICT/Petra/Server/lib/MCommon/Main.cs > ../OpenPetraPatchRemoting/patch/csharp_ICT_Petra_Server_lib_MCommon_Main.cs.patch
    # reset the file in the working directory
    git checkout csharp/ICT/Petra/Server/lib/MCommon/Main.cs


To verify the patch:
--------------------
Apply the patch to trunk where the patch is based on, as described above.

Then run:

    diff -uNr -x .bzr -x .git openpetra remoting

There should not be any difference.

