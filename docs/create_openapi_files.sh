#!/bin/bash

# メインディレクトリ作成 (存在していてもエラーにならないように -p オプションを使用)
mkdir -p components/parameters
mkdir -p components/schemas
mkdir -p paths

# --- ルートファイル: openapi.yaml ---
cat <<'EOF' > openapi.yaml
openapi: 3.0.0
info:
  title: Simple EC Site API (Split)
  version: "1.0.0"
  description: A simple API for an e-commerce site backend, with definitions split into multiple files.
servers:
  - url: http://localhost:8080/api/v1
    description: Development server

# Path definitions are grouped by resource and referenced from external files
paths:
  /users:
    $ref: './paths/users.yaml#/paths/~1users' # Points to the /users path definition in users.yaml
  /users/{userId}:
    $ref: './paths/users.yaml#/paths/~1users~1{userId}' # Points to the /users/{userId} path definition in users.yaml
  /products:
    $ref: './paths/products.yaml#/paths/~1products'
  /products/{productId}:
    $ref: './paths/products.yaml#/paths/~1products~1{productId}'
  /orders:
    $ref: './paths/orders.yaml#/paths/~1orders'
  /orders/{orderId}:
    $ref: './paths/orders.yaml#/paths/~1orders~1{orderId}'

components:
  schemas:
    User:
      $ref: './components/schemas/User.yaml'
    UserCreationRequest:
      $ref: './components/schemas/UserCreationRequest.yaml'
    Product:
      $ref: './components/schemas/Product.yaml'
    ProductCreationRequest:
      $ref: './components/schemas/ProductCreationRequest.yaml'
    Order:
      $ref: './components/schemas/Order.yaml'
    OrderCreationRequest:
      $ref: './components/schemas/OrderCreationRequest.yaml'
    OrderItem:
      $ref: './components/schemas/OrderItem.yaml'
    OrderItemCreationRequest:
      $ref: './components/schemas/OrderItemCreationRequest.yaml'
    Error:
      $ref: './components/schemas/Error.yaml'
  parameters:
    UserIdParam:
      $ref: './components/parameters/UserIdParam.yaml'
    ProductIdParam:
      $ref: './components/parameters/ProductIdParam.yaml'
    OrderIdParam:
      $ref: './components/parameters/OrderIdParam.yaml'
EOF

# --- components/parameters ---
cat <<'EOF' > components/parameters/OrderIdParam.yaml
# components/parameters/OrderIdParam.yaml
name: orderId
in: path
required: true
description: 注文のID
schema:
  type: integer
  format: int64
EOF

cat <<'EOF' > components/parameters/ProductIdParam.yaml
# components/parameters/ProductIdParam.yaml
name: productId
in: path
required: true
description: 商品のID
schema:
  type: integer
  format: int64
EOF

cat <<'EOF' > components/parameters/UserIdParam.yaml
# components/parameters/UserIdParam.yaml
name: userId
in: path
required: true
description: ユーザーのID
schema:
  type: integer
  format: int64
EOF

# --- components/schemas ---
cat <<'EOF' > components/schemas/Error.yaml
# components/schemas/Error.yaml
type: object
properties:
  code:
    type: integer
    format: int32
    description: エラーコード
    example: 404
  message:
    type: string
    description: エラーメッセージ
    example: "指定されたリソースは見つかりませんでした。"
required:
  - code
  - message
EOF

cat <<'EOF' > components/schemas/Order.yaml
# components/schemas/Order.yaml
type: object
properties:
  id:
    type: integer
    format: int64
    description: 注文ID
    readOnly: true
    example: 201
  user_id:
    type: integer
    format: int64
    description: ユーザーID (注文者)
    example: 1
  total_amount:
    type: integer
    format: int32
    description: 合計金額 (円)
    example: 35000
  status:
    type: string
    description: 注文ステータス
    enum: ["pending", "processing", "shipped", "delivered", "cancelled"]
    example: "pending"
  shipping_address:
    type: string
    description: 配送先住所
    example: "東京都千代田区丸の内1-1-1"
  order_items:
    type: array
    items:
      $ref: './OrderItem.yaml' # Relative path within the same directory
  ordered_at:
    type: string
    format: date-time
    description: 注文日時
    readOnly: true
  updated_at:
    type: string
    format: date-time
    description: 更新日時
    readOnly: true
required:
  - user_id
  - total_amount
  - status
  - shipping_address
  - order_items
EOF

cat <<'EOF' > components/schemas/OrderCreationRequest.yaml
# components/schemas/OrderCreationRequest.yaml
type: object
description: 注文作成リクエスト
properties:
  user_id:
    type: integer
    format: int64
    description: ユーザーID (注文者)
    example: 1
  shipping_address:
    type: string
    description: 配送先住所
    example: "東京都千代田区丸の内1-1-1"
  order_items:
    type: array
    items:
      $ref: './OrderItemCreationRequest.yaml' # Relative path
    minItems: 1
required:
  - user_id
  - shipping_address
  - order_items
EOF

cat <<'EOF' > components/schemas/OrderItem.yaml
# components/schemas/OrderItem.yaml
type: object
properties:
  id:
    type: integer
    format: int64
    description: 注文明細ID
    readOnly: true
    example: 301
  order_id:
    type: integer
    format: int64
    description: 注文ID
    example: 201
  product_id:
    type: integer
    format: int64
    description: 商品ID
    example: 101
  quantity:
    type: integer
    format: int32
    description: 数量
    minimum: 1
    example: 2
  price_at_purchase:
    type: integer
    format: int32
    description: 購入時単価 (円)
    example: 15000
required:
  - order_id
  - product_id
  - quantity
  - price_at_purchase
EOF

cat <<'EOF' > components/schemas/OrderItemCreationRequest.yaml
# components/schemas/OrderItemCreationRequest.yaml
type: object
description: 注文明細作成リクエスト (注文作成時に使用)
properties:
  product_id:
    type: integer
    format: int64
    description: 商品ID
    example: 101
  quantity:
    type: integer
    format: int32
    description: 数量
    minimum: 1
    example: 2
required:
  - product_id
  - quantity
EOF

cat <<'EOF' > components/schemas/Product.yaml
# components/schemas/Product.yaml
type: object
properties:
  id:
    type: integer
    format: int64
    description: 商品ID
    readOnly: true
    example: 101
  name:
    type: string
    description: 商品名
    example: "高機能ワイヤレスイヤホン"
  description:
    type: string
    description: 商品説明
    example: "ノイズキャンセリング機能付きの最新モデルです。"
  price:
    type: integer
    format: int32
    description: 価格 (円)
    example: 15000
  stock:
    type: integer
    format: int32
    description: 在庫数
    example: 100
  image_url:
    type: string
    format: url
    nullable: true
    description: 商品画像URL
    example: "https://example.com/images/earphone.jpg"
  created_at:
    type: string
    format: date-time
    description: 作成日時
    readOnly: true
  updated_at:
    type: string
    format: date-time
    description: 更新日時
    readOnly: true
required:
  - name
  - price
  - stock
EOF

cat <<'EOF' > components/schemas/ProductCreationRequest.yaml
# components/schemas/ProductCreationRequest.yaml
type: object
description: 商品作成リクエスト
properties:
  name:
    type: string
    description: 商品名
    example: "高機能ワイヤレスイヤホン"
  description:
    type: string
    description: 商品説明
    example: "ノイズキャンセリング機能付きの最新モデルです。"
  price:
    type: integer
    format: int32
    description: 価格 (円)
    example: 15000
  stock:
    type: integer
    format: int32
    description: 在庫数
    example: 100
  image_url:
    type: string
    format: url
    nullable: true
    description: 商品画像URL
    example: "https://example.com/images/earphone.jpg"
required:
  - name
  - price
  - stock
EOF

cat <<'EOF' > components/schemas/User.yaml
# components/schemas/User.yaml
type: object
properties:
  id:
    type: integer
    format: int64
    description: ユーザーID
    readOnly: true
    example: 1
  username:
    type: string
    description: ユーザー名
    example: "yamada_taro"
  email:
    type: string
    format: email
    description: メールアドレス
    example: "yamada_taro@example.com"
  password_hash:
    type: string
    description: ハッシュ化されたパスワード (レスポンスには通常含めません)
  created_at:
    type: string
    format: date-time
    description: 作成日時
    readOnly: true
    example: "2024-05-08T10:00:00Z"
  updated_at:
    type: string
    format: date-time
    description: 更新日時
    readOnly: true
    example: "2024-05-08T10:00:00Z"
required:
  - username
  - email
EOF

cat <<'EOF' > components/schemas/UserCreationRequest.yaml
# components/schemas/UserCreationRequest.yaml
type: object
description: ユーザー作成リクエスト
properties:
  username:
    type: string
    description: ユーザー名
    example: "yamada_taro"
  email:
    type: string
    format: email
    description: メールアドレス
    example: "yamada_taro@example.com"
  password:
    type: string
    format: password
    description: パスワード
    example: "securePassword123"
required:
  - username
  - email
  - password
EOF

# --- paths ---
cat <<'EOF' > paths/orders.yaml
# paths/orders.yaml
# Contains path definitions related to orders.

paths:
  /orders:
    post:
      summary: 新規注文作成
      tags:
        - Order
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '../components/schemas/OrderCreationRequest.yaml'
      responses:
        '201':
          description: 注文作成成功
          content:
            application/json:
              schema:
                $ref: '../components/schemas/Order.yaml'
        '400':
          description: 不正なリクエスト (在庫不足など)
          content:
            application/json:
              schema:
                $ref: '../components/schemas/Error.yaml'
  /orders/{orderId}:
    get:
      summary: 注文詳細取得
      tags:
        - Order
      parameters:
        - $ref: '../components/parameters/OrderIdParam.yaml'
      responses:
        '200':
          description: 注文詳細取得成功
          content:
            application/json:
              schema:
                $ref: '../components/schemas/Order.yaml'
        '404':
          description: 注文が見つかりません
          content:
            application/json:
              schema:
                $ref: '../components/schemas/Error.yaml'
EOF

cat <<'EOF' > paths/products.yaml
# paths/products.yaml
# Contains path definitions related to products.

paths:
  /products:
    get:
      summary: 商品一覧取得
      tags:
        - Product
      responses:
        '200':
          description: 商品一覧取得成功
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '../components/schemas/Product.yaml'
    post:
      summary: 新規商品登録
      tags:
        - Product
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '../components/schemas/ProductCreationRequest.yaml'
      responses:
        '201':
          description: 商品登録成功
          content:
            application/json:
              schema:
                $ref: '../components/schemas/Product.yaml'
        '400':
          description: 不正なリクエスト
          content:
            application/json:
              schema:
                $ref: '../components/schemas/Error.yaml'
  /products/{productId}:
    get:
      summary: 商品詳細取得
      tags:
        - Product
      parameters:
        - $ref: '../components/parameters/ProductIdParam.yaml'
      responses:
        '200':
          description: 商品詳細取得成功
          content:
            application/json:
              schema:
                $ref: '../components/schemas/Product.yaml'
        '404':
          description: 商品が見つかりません
          content:
            application/json:
              schema:
                $ref: '../components/schemas/Error.yaml'
EOF

cat <<'EOF' > paths/users.yaml
# paths/users.yaml
# Contains path definitions related to users.
# Referenced from the root openapi.yaml file.

paths: # This top-level 'paths' key is important for the $ref in the root file
  /users:
    post:
      summary: 新規ユーザー作成
      tags:
        - User
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '../components/schemas/UserCreationRequest.yaml' # Relative path to the schema
      responses:
        '201':
          description: ユーザー作成成功
          content:
            application/json:
              schema:
                $ref: '../components/schemas/User.yaml'
        '400':
          description: 不正なリクエスト
          content:
            application/json:
              schema:
                $ref: '../components/schemas/Error.yaml'
  /users/{userId}:
    get:
      summary: ユーザー情報取得
      tags:
        - User
      parameters:
        - $ref: '../components/parameters/UserIdParam.yaml' # Relative path to the parameter
      responses:
        '200':
          description: ユーザー情報取得成功
          content:
            application/json:
              schema:
                $ref: '../components/schemas/User.yaml'
        '404':
          description: ユーザーが見つかりません
          content:
            application/json:
              schema:
                $ref: '../components/schemas/Error.yaml'
EOF

# --- README.md ---
cat <<'EOF' > README.md
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
EOF

echo "すべてのファイルが作成されました。"
echo "ディレクトリ構造:"
ls -R