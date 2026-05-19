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


