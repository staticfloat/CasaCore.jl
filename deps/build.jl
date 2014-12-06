using BinDeps
@BinDeps.setup

# OpenBLAS
libblas = library_dependency("libblas",aliases=["libopenblas"])
provides(AptGet,Dict("libopenblas-dev" => libblas))

# CasaCore
libcasa_tables     = library_dependency("libcasa_tables")
libcasa_measures   = library_dependency("libcasa_measures")
casacore_libraries = [libcasa_tables,libcasa_measures]

version = "1.7.0"
url = "ftp://ftp.atnf.csiro.au/pub/software/casacore/casacore-$version.tar.bz2"
provides(Sources, URI(url), casacore_libraries, unpacked_dir="casacore-$version")

depsdir  = BinDeps.depsdir(libcasa_tables)
srcdir   = joinpath(depsdir,"src",   "casacore-$version")
builddir = joinpath(depsdir,"builds","casacore-$version")
prefix   = joinpath(depsdir,"usr")
files    = [joinpath(prefix,"lib",library.name*".so") for library in casacore_libraries]
provides(BuildProcess,
        (@build_steps begin
                GetSources(libcasa_tables)
                GetSources(libcasa_measures)
                CreateDirectory(builddir)
                @build_steps begin
                        ChangeDirectory(builddir)
                        FileRule(files,@build_steps begin
                                `cmake -DMODULE="tables,measures" -DCMAKE_INSTALL_PREFIX="$prefix" -DCMAKE_CXX_FLAGS="-w" $srcdir`
                                `make`
                                `make install`
                        end)
                end
        end),casacore_libraries)

# CasaCore Wrapper
libcasacorewrapper = library_dependency("libcasacorewrapper")

version = "1.7.0"
url = "ftp://ftp.atnf.csiro.au/pub/software/casacore/casacore-$version.tar.bz2"
provides(Sources, URI(url), libcasacorewrapper, unpacked_dir="casacore-$version")

builddir = joinpath(depsdir,"builds","casacorewrapper")
provides(BuildProcess,
        (@build_steps begin
                GetSources(libcasacorewrapper)
                CreateDirectory(builddir)
                @build_steps begin
                        ChangeDirectory(builddir)
                        FileRule(joinpath(prefix,"lib","libcasacorewrapper.so"),@build_steps begin
                                `make`
                                `make install`
                        end)
                end
        end),libcasacorewrapper)

@BinDeps.install Dict(:libcasacorewrapper => :libcasacorewrapper)

