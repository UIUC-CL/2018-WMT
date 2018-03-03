
task marian
	:: remote="https://github.com/marian-nmt/marian"
	:: ref=(Marian: "8c119e7cc6")
	:: build_threads=8
	 > amun="bin/amun"
	 > atools="bin/atools"
	 > extract_lex="bin/extract_lex"
	 > aligner="bin/fast_align"
	 > trainer="bin/marian"
	 > decoder="bin/marian-decoder"
	 > scorer="bin/marian-scorer"
	 > server="bin/marian-server"
	 > vocab="bin/marian-vocab"
{
    # We want to clone marian into the current working dir,
    #   but git refuses to clone into a non-empty directory,
    #   and the current dir contains a few text files
    #   that are automatically created but ducttape.
    #
    # We work around this by cloning into a dir called repo,
    git clone "${remote}" repo
    # 
    #   and then moving the contents of that directory
    #   into the current working directory
    #   (being careful to excluding . and ..)
    mv repo/* repo/.[!.]* .
    #
    #   and then deleting the repo directory.
    rmdir repo
    #
    # Finally, we checkout out the particular revision
    #   specified by the user,
    #   and create a local branch by that same name.
    git checkout -b "${ref}" "${ref}"
    #
    # Marian uses cmake for its build system,
    #   so we follow cmake best practice
    #   and create a directory into which
    #   the results of compiling will be placed,
    mkdir bin
    #
    #   and then cd into that directory.
    cd bin
    #
    # Finally, we invoke cmake,
    #   which causes the creation of the actual
    #   marian Makefile,
    cmake ..
    #
    #   and then invoke make to build marian.
    make -j ${build_threads}
}

