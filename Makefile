.PHONY: all clean init config build run rebuild help info

# Configurações
BUILD_DIR := build
BUILD_TYPE ?= Release
# Conan 2 com cmake_layout coloca os arquivos em build/build/Release/generators
CONAN_BUILD_DIR := $(BUILD_DIR)/build/$(BUILD_TYPE)
GENERATORS_DIR := $(CONAN_BUILD_DIR)/generators
EXECUTABLE := $(CONAN_BUILD_DIR)/ffmpeg_demo

# Cores para output
GREEN := \033[0;32m
YELLOW := \033[0;33m
BLUE := \033[0;34m
CYAN := \033[0;36m
MAGENTA := \033[0;35m
NC := \033[0m # No Color

# Target padrão
all: init config build

# Ajuda
help:
	@echo "$(CYAN)╔════════════════════════════════════════════╗$(NC)"
	@echo "$(CYAN)║       FFmpeg Demo - Build System           ║$(NC)"
	@echo "$(CYAN)╚════════════════════════════════════════════╝$(NC)"
	@echo ""
	@echo "$(BLUE)📦 Comandos disponíveis:$(NC)"
	@echo "  $(GREEN)make all$(NC)       - Executa init, config e build"
	@echo "  $(GREEN)make init$(NC)      - Instala dependências com Conan"
	@echo "  $(GREEN)make config$(NC)    - Configura o projeto com CMake"
	@echo "  $(GREEN)make build$(NC)     - Compila o projeto"
	@echo "  $(GREEN)make run$(NC)       - Executa o programa"
	@echo "  $(GREEN)make test$(NC)      - Testa com arquivo de exemplo"
	@echo "  $(GREEN)make rebuild$(NC)   - Limpa e reconstrói tudo"
	@echo "  $(GREEN)make clean$(NC)     - Remove arquivos de build"
	@echo "  $(GREEN)make info$(NC)      - Informações do projeto"
	@echo ""
	@echo "$(YELLOW)⚙️  Variáveis:$(NC)"
	@echo "  BUILD_TYPE=Release|Debug (padrão: Release)"
	@echo ""
	@echo "$(CYAN)🚀 Exemplos de uso:$(NC)"
	@echo "  make all && make run"
	@echo "  make run VIDEO=meu_video.mp4"
	@echo ""
	@echo "$(MAGENTA)⚠️  ATENÇÃO:$(NC)"
	@echo "  FFmpeg é grande! Primeira compilação: ~10-15 min"

# Instala as dependências com Conan
init:
	@echo "$(BLUE)>>> 📦 Instalando dependências com Conan...$(NC)"
	@echo "$(YELLOW)⚠️  IMPORTANTE: FFmpeg é grande e pode demorar para compilar!$(NC)"
	@echo "$(YELLOW)    Primeira compilação: ~10-15 minutos$(NC)"
	@echo "$(YELLOW)    Próximas vezes: instantâneo (usa cache)$(NC)"
	@echo ""
	conan install . --output-folder=$(BUILD_DIR) --build=missing \
		-s build_type=$(BUILD_TYPE) \
		-c tools.system.package_manager:mode=install \
		-c tools.system.package_manager:sudo=True
	@echo "$(GREEN)✓ Dependências instaladas$(NC)"
	@echo "$(YELLOW)ℹ  Arquivos gerados em: $(GENERATORS_DIR)$(NC)"

# Configura o CMake usando as toolchains do Conan
config:
	@if [ ! -f "$(GENERATORS_DIR)/conan_toolchain.cmake" ]; then \
		echo "$(YELLOW)⚠  Toolchain do Conan não encontrado. Execute 'make init' primeiro.$(NC)"; \
		exit 1; \
	fi
	@echo "$(BLUE)>>> ⚙️  Configurando CMake...$(NC)"
	cmake -S . -B $(CONAN_BUILD_DIR) \
		-DCMAKE_TOOLCHAIN_FILE=$(GENERATORS_DIR)/conan_toolchain.cmake \
		-DCMAKE_BUILD_TYPE=$(BUILD_TYPE) \
		-DCMAKE_EXPORT_COMPILE_COMMANDS=ON
	@echo "$(GREEN)✓ CMake configurado$(NC)"

# Compila o projeto
build:
	@if [ ! -f "$(CONAN_BUILD_DIR)/Makefile" ]; then \
		echo "$(YELLOW)⚠  Makefiles do CMake não encontrados. Execute 'make config' primeiro.$(NC)"; \
		exit 1; \
	fi
	@echo "$(BLUE)>>> 🔨 Compilando projeto...$(NC)"
	cmake --build $(CONAN_BUILD_DIR) --config $(BUILD_TYPE) -j$$(nproc)
	@echo "$(GREEN)✓ Compilação concluída$(NC)"
	@echo "$(YELLOW)ℹ  Executável: $(EXECUTABLE)$(NC)"

# Executa o programa
run:
	@if [ ! -f "$(EXECUTABLE)" ]; then \
		echo "$(YELLOW)⚠  Executável não encontrado. Execute 'make build' primeiro.$(NC)"; \
		exit 1; \
	fi
	@echo "$(CYAN)╔════════════════════════════════════════════╗$(NC)"
	@echo "$(CYAN)║       🎬 Iniciando FFmpeg Demo 🎬          ║$(NC)"
	@echo "$(CYAN)╚════════════════════════════════════════════╝$(NC)"
	@echo ""
	@if [ -n "$(VIDEO)" ]; then \
		$(EXECUTABLE) $(VIDEO); \
	else \
		$(EXECUTABLE); \
	fi

# Testa com arquivo (se existir)
test:
	@if [ ! -f "$(EXECUTABLE)" ]; then \
		echo "$(YELLOW)⚠  Execute 'make build' primeiro.$(NC)"; \
		exit 1; \
	fi
	@echo "$(BLUE)>>> 🧪 Testando com arquivos de exemplo...$(NC)"
	@if ls *.mp4 *.mkv *.avi *.mov 2>/dev/null | head -1 | grep -q .; then \
		for video in *.mp4 *.mkv *.avi *.mov 2>/dev/null | head -3; do \
			if [ -f "$$video" ]; then \
				echo "$(CYAN)Testando: $$video$(NC)"; \
				$(EXECUTABLE) "$$video"; \
				echo ""; \
			fi; \
		done; \
	else \
		echo "$(YELLOW)Nenhum arquivo de vídeo encontrado no diretório atual.$(NC)"; \
		echo "$(YELLOW)Coloque um arquivo .mp4, .mkv, .avi ou .mov aqui e tente novamente.$(NC)"; \
		echo ""; \
		$(EXECUTABLE); \
	fi

# Reconstrói tudo do zero
rebuild: clean all
	@echo "$(GREEN)✓ Rebuild completo$(NC)"

# Limpa arquivos de build
clean:
	@echo "$(YELLOW)>>> 🧹 Limpando arquivos de build...$(NC)"
	rm -rf $(BUILD_DIR)
	rm -f CMakeUserPresets.json
	@echo "$(GREEN)✓ Limpeza concluída$(NC)"

# Info sobre o projeto
info:
	@echo "$(CYAN)╔════════════════════════════════════════════╗$(NC)"
	@echo "$(CYAN)║         Informações do Projeto             ║$(NC)"
	@echo "$(CYAN)╚════════════════════════════════════════════╝$(NC)"
	@echo ""
	@echo "$(BLUE)Build Type:$(NC) $(BUILD_TYPE)"
	@echo "$(BLUE)Build Dir:$(NC) $(CONAN_BUILD_DIR)"
	@echo "$(BLUE)Executable:$(NC) $(EXECUTABLE)"
	@echo ""
	@if [ -f "$(EXECUTABLE)" ]; then \
		echo "$(GREEN)✓ Executável compilado$(NC)"; \
		ls -lh $(EXECUTABLE) | awk '{print "  Tamanho: " $$5}'; \
	else \
		echo "$(YELLOW)⚠ Executável não encontrado$(NC)"; \
	fi
	@echo ""
	@echo "$(YELLOW)Arquivos de vídeo no diretório:$(NC)"
	@ls -1 *.mp4 *.mkv *.avi *.mov 2>/dev/null || echo "  (nenhum encontrado)"

