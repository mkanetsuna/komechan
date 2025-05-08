# backend/README.md

## Simple EC Site Backend (C Language)

This is the backend a simple e-commerce site, implemented in C language following Clean Architecture principles.

### Directory Structure

はい、承知いたしました。「フェーズ0: プロジェクトのセットアップと最初の縦スライス」を実行し、その成果物をリポジトリルート直下の backend ディレクトリ配下に作成します。

ここでは、特定のWebフレームワークライブラリに強く依存しない形で、基本的な構造とHTTPリクエストを受けてレスポンスを返すまでの流れを示すシンプルな実装を行います。実際の運用では、選定したWebサーバーライブラリ（libmicrohttpd, CivetWebなど）のAPIに合わせて server.c の部分を具体的に実装する必要があります。

以下のファイル群を backend ディレクトリ配下に作成します。

1. ディレクトリ構造の作成
まず、以下のコマンドで必要なディレクトリを作成します（これらは後述のファイルを作成する際に自動的に作成される場合もあります）。

Bash

mkdir -p backend/src/application/usecases
mkdir -p backend/src/domain/entities
mkdir -p backend/src/infrastructure/database
mkdir -p backend/src/infrastructure/web
mkdir -p backend/src/interfaces/controllers
mkdir -p backend/src/interfaces/repositories
mkdir -p backend/src/utils
mkdir -p backend/tests/unit
mkdir -p backend/tests/integration
mkdir -p backend/bin # コンパイル後の実行ファイル格納用
2. backend/Makefile
シンプルなMakefileです。GCCを使用する例です。

Makefile

# backend/Makefile
CC = gcc
CFLAGS = -Wall -Wextra -std=c11 -Isrc
LDFLAGS =
TARGET_DIR = bin
TARGET = $(TARGET_DIR)/backend_server
SRC_DIRS = src src/infrastructure/web src/interfaces/controllers src/utils
SOURCES = $(wildcard $(addsuffix /*.c, $(SRC_DIRS)))
OBJECTS = $(SOURCES:.c=.o)

# Default target
all: $(TARGET)

# Linking
$(TARGET): $(OBJECTS)
	@mkdir -p $(TARGET_DIR)
	$(CC) $(OBJECTS) -o $@ $(LDFLAGS)
	@echo "Build successful! Executable: $(TARGET)"

# Compilation
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# Clean
clean:
	rm -f $(OBJECTS) $(TARGET)
	@echo "Cleaned build files."

# Run (simple run, assumes server listens on 8080)
run: all
	@echo "Starting server..."
	./$(TARGET)

.PHONY: all clean run
3. backend/README.md
プロジェクトの基本的な説明を記述します。

Markdown

# backend/README.md

## Simple EC Site Backend (C Language - Phase 0)

This is the backend a simple e-commerce site, implemented in C language following Clean Architecture principles (starting with Phase 0).

This initial phase sets up the project structure and a basic HTTP server capable of responding to a `/ping` request.

### Directory Structure

backend/
├── Makefile                # For compiling the project
├── README.md               # This file
├── bin/                    # Compiled binaries (e.g., backend_server)
├── src/                    # Source code
│   ├── application/        # Use cases layer
│   ├── domain/             # Entities layer
│   ├── infrastructure/     # Frameworks & Drivers layer (DB, Web server implementation)
│   │   └── web/
│   │       ├── server.h
│   │       └── server.c
│   ├── interfaces/         # Interface Adapters layer (Controllers, Presenters, Repository Interfaces)
│   │   └── controllers/
│   │       ├── ping_controller.h
│   │       └── ping_controller.c
│   ├── main.c              # Application entry point
│   └── utils/              # Common utilities
│       └── error_handler.h
└── tests/                  # Test code (unit, integration)