name = "openvdb_ax"

version = "0.1.0"

authors = [
    "DNEG"
]

description = \
    """
    OpenVDB AX is an open source C++ library that provides a powerful and easy way of interacting with OpenVDB
    point and volume data. This exposes an expression language to allow fast, custom manipulation of point attributes
    and voxel values using a collection of mathematical functions. Expressions are quickly JIT-compiled and to offer
    great performance that in many cases rival custom C++ operators. It is developed and maintained by DNEG, providing
    a flexible and portable way to work with OpenVDB data.
    """

requires = [
    "blosc-1.5+",
    "boost-1.61",
    "cmake-3+",
    "gcc-6+",
    "ilmbase-2.2.1+<2.4",
    "llvm-5+<9",
    "python-2.7+<3",
    "tbb-2017.U6+",
    "openvdb-5+"
]

variants = [
    ["platform-linux"]
]

tools = [
    "vdb_print",
    "vdb_render",
    "vdb_view"
]

build_system = "cmake"

with scope("config") as config:
    config.build_thread_count = "logical_cores"

uuid = "openvdb_ax-{version}".format(version=str(version))

def commands():
    env.PATH.prepend("{root}/bin")
    env.LD_LIBRARY_PATH.prepend("{root}/lib")
    env.PYTHONPATH.prepend("{root}/lib/python" + str(env.REZ_PYTHON_MAJOR_VERSION) + "." + str(env.REZ_PYTHON_MINOR_VERSION))

    # Helper environment variables.
    env.OPENVDB_AX_BINARY_PATH.set("{root}/bin")
    env.OPENVDB_AX_INCLUDE_PATH.set("{root}/include")
    env.OPENVDB_AX_LIBRARY_PATH.set("{root}/lib")
