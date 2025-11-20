cmake_minimum_required(VERSION 3.15)
project(FFmpegDemo CXX C)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Encontra o FFmpeg instalado pelo Conan
find_package(ffmpeg REQUIRED CONFIG)

# Cria o executável
add_executable(ffmpeg_demo main.cpp)

# Linka as bibliotecas do FFmpeg
target_link_libraries(ffmpeg_demo PRIVATE ffmpeg::ffmpeg)
