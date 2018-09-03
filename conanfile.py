from conans import ConanFile, CMake, tools
import os


class IlmBaseConan(ConanFile):
    name = "IlmBase"
    description = "IlmBase is a component of OpenEXR. OpenEXR is a high dynamic-range (HDR) image file format developed by Industrial Light & Magic for use in computer imaging applications."
    version = "2.3.0"
    license = "BSD"
    url = "https://github.com/Mikayex/conan-ilmbase.git"
    settings = "os", "compiler", "build_type", "arch"
    options = {"shared": [True, False], "namespace_versioning": [True, False], "fPIC": [True, False]}
    default_options = "shared=False", "namespace_versioning=True", "fPIC=False"
    generators = "cmake"
    exports = "FindIlmBase.cmake"

    def config_options(self):
        if self.settings.os == "Windows":
            self.options.remove("fPIC")

    def configure(self):
        if "fPIC" in self.options.fields and self.options.shared:
            self.options.fPIC = True

    def source(self):
        url = "https://github.com/openexr/openexr/releases/download/v{version}/ilmbase-{version}.tar.gz"
        tools.get(url.format(version=self.version))
        tools.replace_in_file("ilmbase-%s/CMakeLists.txt" % self.version, "PROJECT ( ilmbase )",
                              """PROJECT ( ilmbase )
include(${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)
conan_basic_setup()""")

    def _configure_cmake(self):
        cmake = CMake(self)
        cmake.definitions["ENABLE_TESTS"] = False
        cmake.definitions["NAMESPACE_VERSIONING"] = self.options.namespace_versioning
        if "fPIC" in self.options.fields:
            cmake.definitions["CMAKE_POSITION_INDEPENDENT_CODE"] = self.options.fPIC

        src_dir = "ilmbase-%s" % self.version
        cmake.configure(source_dir=src_dir)
        return cmake

    def build(self):
        cmake = self._configure_cmake()
        cmake.build()

    def package(self):
        cmake = self._configure_cmake()
        cmake.install()
        self.copy("FindIlmBase.cmake", src=".", dst=".")
        self.copy("license*", dst="licenses", src="ilmbase-%s" % self.version, ignore_case=True, keep_path=False)

    def package_info(self):
        parsed_version = self.version.split('.')
        version_suffix = "-%s_%s" % (parsed_version[0], parsed_version[1]) if self.options.namespace_versioning else ""

        if self.options.shared and self.settings.os == "Windows":
            self.cpp_info.defines.append("OPENEXR_DLL")
        self.cpp_info.includedirs = ['include', 'include/OpenEXR']
        self.cpp_info.libs = ["Imath" + version_suffix, "IexMath" + version_suffix, "Half", "Iex" + version_suffix,
                              "IlmThread" + version_suffix]

        if not self.settings.os == "Windows":
            self.cpp_info.cppflags = ["-pthread"]
