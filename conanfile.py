from conan import ConanFile
from conan.tools.cmake import cmake_layout


class ExampleRecipe(ConanFile):
    settings = "os", "compiler", "build_type", "arch"
    generators = "CMakeDeps", "CMakeToolchain"

    default_options = {
        "ffmpeg/*:with_xcb": False,
        "ffmpeg/*:with_xlib": False,
        "ffmpeg/*:with_vaapi": False,
        "ffmpeg/*:with_vdpau": False,
    }

    def requirements(self):
        self.requires("ffmpeg/9.0.1")

    def layout(self):
        cmake_layout(self)

