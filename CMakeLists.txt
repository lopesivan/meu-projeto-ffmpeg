cmake_minimum_required(VERSION 3.15)
project(FFmpegDemo CXX C)

# #  FIXME: 💩   > Leia NOTE.md
set(CMAKE_SKIP_BUILD_RPATH FALSE)
set(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE)
set(CMAKE_INSTALL_RPATH "/usr/lib/x86_64-linux-gnu")
set(CMAKE_INSTALL_RPATH_USE_LINK_PATH FALSE)
#
#  FIXME: 💩   > Leia NOTE3.md
#  set(CMAKE_SKIP_BUILD_RPATH FALSE)
#  set(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE)
#  set(CMAKE_INSTALL_RPATH "/home/linuxbrew/.linuxbrew/lib")
#  set(CMAKE_INSTALL_RPATH_USE_LINK_PATH FALSE)

# ----------------------------------------
# Opções de build para debug
# ----------------------------------------
set(CMAKE_VERBOSE_MAKEFILE ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
# --

# Encontra o FFmpeg instalado pelo Conan
find_package(ffmpeg REQUIRED CONFIG)

# Cria o executável
add_executable(ffmpeg_demo main.cpp)

# Linka as bibliotecas do FFmpeg
target_link_libraries(ffmpeg_demo PRIVATE ffmpeg::ffmpeg)
