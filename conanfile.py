from conan import ConanFile
from conan.tools.cmake import cmake_layout


class ExampleRecipe(ConanFile):
    settings = "os", "compiler", "build_type", "arch"
    generators = "CMakeDeps", "CMakeToolchain"
    default_options = {
        "libx265/*:shared": True,
    }

    def requirements(self):
        self.requires("ffmpeg/8.0")

    def layout(self):
        cmake_layout(self)
