# Simple EC Site API Backend

これは、C言語で実装することを想定したシンプルなECサイトのバックエンドAPIのOpenAPI仕様です。
API定義は管理しやすいように複数のファイルに分割されています。

## OpenAPI仕様ファイル

-   **ルートファイル:** `openapi.yaml`
    -   API全体の基本情報と、他の定義ファイルへの参照が含まれています。
-   **パス定義:** `paths/` ディレクトリ
    -   各リソース（users, products, orders）に関連するAPIエンドポイントの定義が含まれています。
-   **コンポーネント定義:** `components/` ディレクトリ
    -   `schemas/`: APIで使用されるデータモデル（ユーザー、商品、注文など）の定義が含まれています。
    -   `parameters/`: APIエンドポイントで再利用されるパラメータ（ユーザーIDなど）の定義が含まれています。

## Swagger UIでAPI仕様を確認する方法

Swagger UI を使用すると、ブラウザ上でAPIの仕様をインタラクティブに確認したり、実際にAPIを試したりすることができます。
Docker を使用して Swagger UI をローカルで起動するのが簡単です。

### Docker を使用した Swagger UI の起動手順

1.  **Docker Desktop のインストール**:
    もしまだインストールしていない場合は、[Docker Desktop](https://www.docker.com/products/docker-desktop/) を公式サイトからダウンロードしてインストールしてください。

2.  **OpenAPI ファイル群の準備**:
    このプロジェクトのルートディレクトリ（`openapi.yaml` があるディレクトリ）に移動してください。すべての参照ファイル（`paths/` や `components/` 内のファイル）がこのルートディレクトリからの相対パスで解決されるように配置されている必要があります。

3.  **Swagger UI Docker コンテナの起動**:
    ターミナルまたはコマンドプロンプトをプロジェクトのルートディレクトリで開き、以下のコマンドを実行します。

    ```bash
    docker run -p 80:8080 -e SWAGGER_JSON=/spec/openapi.yaml -v $(pwd):/spec swaggerapi/swagger-ui
    ```

    * `-p 80:8080`: ホストマシンのポート80番をコンテナのポート8080番にマッピングします。もしポート80番が使用中の場合は、他のポート（例: `-p 8081:8080`）に変更してください。その場合、ブラウザでアクセスする際のポート番号も変更後のものになります。
    * `-e SWAGGER_JSON=/spec/openapi.yaml`: Swagger UI が読み込むメインの OpenAPI 仕様ファイル（ルートファイル）のパスをコンテナ内で指定します。
    * `-v $(pwd):/spec`: 現在のディレクトリ (`$(pwd)`) をコンテナ内の `/spec` ディレクトリにマウントします。これにより、コンテナ内の Swagger UI がローカルの `openapi.yaml` 及びそこから参照される全てのファイルを読み込めるようになります。
        * Windows の PowerShell を使用している場合は `$(pwd)` の代わりに `${PWD}` を使用してください:
            ```powershell
            docker run -p 80:8080 -e SWAGGER_JSON=/spec/openapi.yaml -v ${PWD}:/spec swaggerapi/swagger-ui
            ```
        * Windows の コマンドプロンプト を使用している場合は `%cd%` を使用してください:
            ```cmd
            docker run -p 80:8080 -e SWAGGER_JSON=/spec/openapi.yaml -v "%cd%":/spec swaggerapi/swagger-ui
            ```

4.  **ブラウザで確認**:
    Docker コンテナが起動したら、ウェブブラウザを開き、以下のURLにアクセスします。

    `http://localhost`
    （もしポートマッピングを `8081:8080` に変更した場合は `http://localhost:8081`）

    Swagger UI が表示され、分割されたファイルが解決された形でAPIドキュメントが閲覧できます。

### Docker コンテナの停止

Swagger UI を終了するには、ターミナルで `Ctrl + C` を押すか、別のターミナルから以下のコマンドを実行してコンテナを停止します。

1.  実行中のコンテナIDを確認します。
    ```bash
    docker ps
    ```
2.  該当するコンテナを停止します。
    ```bash
    docker stop <CONTAINER_ID>
    ```

## C言語でのバックエンド実装について

この OpenAPI 仕様は、APIのインターフェースを定義するものです。
C言語でバックエンドを実装する際には、この仕様に沿ったエンドポイント、リクエスト/レスポンスの形式、データ構造を持つサーバーアプリケーションを開発する必要があります。
C言語でWebサーバーを構築するためのライブラリ（例: libmicrohttpd, Kore, Civetwebなど）やフレームワークを利用することができます。
また、JSONのパース/生成には、`json-c` や `jansson` といったライブラリが役立ちます。

## Ogenについて

このYAMLファイル群は標準的なOpenAPI 3.0の仕様に準拠しており、`$ref` を用いてファイルを分割する一般的な方法を採用しています。これは、`ogen` のようなGo言語向けのツールだけでなく、多くのOpenAPI関連ツール（バリデータ、コードジェネレータ、ドキュメントジェネレータなど）で解釈可能な構成です。C言語用のOpenAPIジェネレータが存在する場合も、このルートの `openapi.yaml` ファイルを入力として利用できる可能性が高いです。
