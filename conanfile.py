
import os, glob

from conans import ConanFile, tools, AutoToolsBuildEnvironment
from conans.errors import ConanException
from conans.model.version import Version


class IlmBaseConan(ConanFile):
    name = "ilmbase"
    description = "IlmBase is a component of OpenEXR. OpenEXR is a high dynamic-range (HDR) image file format developed by Industrial Light & Magic for use in computer imaging applications."
    version = "1.0.3"
    license = "BSD"
    url = "https://github.com/Mikayex/conan-ilmbase.git"
    settings = "os", "compiler", "build_type", "arch"
    options = {"shared": [True, False], "namespace_versioning": [True, False], "fPIC": [True, False]}
    default_options = "shared=False", "namespace_versioning=True", "fPIC=True"
    generators = "cmake"
    exports = "FindIlmBase.cmake"

    def config_options(self):
        if self.settings.os == "Windows":
            self.options.remove("fPIC")

    def configure(self):
        if "fPIC" in self.options.fields and self.options.shared:
            self.options.fPIC = True

    def source(self):
        url = r"https://github.com/downloads/openexr/openexr/ilmbase-{}.tar.gz".format(self.version)
        tools.get(url)

    def build(self):
        yes_no = {True: "enable", False: "disable"}
        args = ["--{}-shared".format(yes_no.get(bool(self.options.shared))),
                "--{}-static".format(yes_no.get(not bool(self.options.shared))),
                "--{}-namespaceversioning".format(yes_no.get(bool(self.options.namespace_versioning))),
                ]

        with tools.chdir("ilmbase-{}".format(self.version)):
            self.run("./bootstrap")
        autotools = AutoToolsBuildEnvironment(self)
        autotools.configure(configure_dir='ilmbase-{}'.format(self.version), args=args)
        autotools.make()
        tools.replace_prefix_in_pc_file("IlmBase.pc", "${package_root_path_ilmbase}")

    def package(self):
        autotools = AutoToolsBuildEnvironment(self)
        autotools.install()
        self.copy("FindIlmBase.cmake", src=".", dst=".")
        self.copy("license*", dst="licenses", src="ilmbase-%s" % self.version, ignore_case=True, keep_path=False)

        for f in glob.glob(os.path.join(self.package_folder, 'lib', '*.la')):
            os.remove(f)

    def package_info(self):
        self.cpp_info.includedirs = [os.path.join('include', 'OpenEXR'), ]
        self.cpp_info.libs = ['Half', 'Iex', 'IexMath', 'IlmThread', 'Imath']

        if self.options.shared and self.settings.os == "Windows":
            self.cpp_info.defines.append("OPENEXR_DLL")

        if not self.settings.os == "Windows":
            self.cpp_info.cppflags = ["-pthread"]
