Mas antes confirma que o x265 de desenvolvimento está instalado:
```{bash }
pkg-config --modversion x265
```
Se não retornar a versão:
```{bash }
sudo apt install libx265-dev
```
Aí sim o conan vai achar o x265 via pkg-config. Depois limpa
o build do ffmpeg do cache e roda de novo:
```{bash }
conan remove "ffmpeg/8.0:*" --confirm
make init
```


## Antes verificamos se existe x265

```{bash }
$ pkg-config --modversion x265
Package x265 was not found in the pkg-config search path.
Perhaps you should add the directory containing `x265.pc'
to the PKG_CONFIG_PATH environment variable
Package 'x265' not found

```

ivan*:  /home/ivan/git/nativium-projeto/nativium main
```{bash }
$ PKG_CONFIG_PATH=/usr/lib/x86_64-linux-gnu/pkgconfig
```

ivan*:  /home/ivan/git/nativium-projeto/nativium main
```{bash }
$ pkg-config --modversion x265
Package x265 was not found in the pkg-config search path.
Perhaps you should add the directory containing `x265.pc'
to the PKG_CONFIG_PATH environment variable
Package 'x265' not found
```

ivan*:  /home/ivan/git/nativium-projeto/nativium main
```{bash }
$ export PKG_CONFIG_PATH=/usr/lib/x86_64-linux-gnu/pkgconfig
```

ivan*:  /home/ivan/git/nativium-projeto/nativium main
```{bash }
$ pkg-config --modversion x265
3.5
```

