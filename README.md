# CI/CD Pipeline for webinar-202407

このリポジトリには以下のリソースをデプロイするための Terraform コードが含まれています。

- 本番環境(prod)と開発環境(dev)の VCL サービス

ディレクトリレイアウトは以下の通りです。

```
├──📄 .gitignore
├──📄 README.md
├──📂 .github
│   ├──📂 actions
│   │   └──📂 get-pr-info
│   │       └──📄 action.yml
│   └──📂 workflows
│       ├──📄 cleanup.yml
│       ├──📄 run-terraform.yml
│       └──📄 test-module.yml
├──📂 envs
│   ├──📂 dev
│   │   ├──📄 backend.tf
│   │   ├──📄 main.tf
│   │   ├──📄 outputs.tf
│   │   └──📄 variables.tf
│   └──📂 prod
│       ├──📄 backend.tf
│       ├──📄 main.tf
│       ├──📄 outputs.tf
│       └──📄 variables.tf
└──📂 modules
    ├──📂 helpers
    │   ├──📂 http
    │   │   ├──📄 main.tf
    │   │   ├──📄 output.tf
    │   │   └──📄 variables.tf
    │   └──📂 sleep
    │       ├──📄 main.tf
    │       └──📄 variables.tf
    └──📂 vcl_service
        ├──📄 main.tf
        ├──📄 output.tf
        ├──📄 provider.tf
        ├──📄 variables.tf
        ├──📄 tests
        │   └──📄 main.tftest.hcl
        └──📂 vcl
            └──📄 main.vcl
```

## 環境変数

ワークフローを実行するために必用な環境変数です。各変数がリポジトリからアクセス可能な Secret として登録されている必用があります。

| Var Name              | Description                                                                                 |
| --------------------- | ------------------------------------------------------------------------------------------- |
| AWS_ACCESS_KEY_ID     |                                                                                             |
| AWS_SECRET_ACCESS_KEY |                                                                                             |
| BACKEND_BUCKET        | S3 bucket の名前, リモートバックエンドの Output 変数 `bucket` の値をセットする              |
| BACKEND_DYNAMO_DB     | DynamoDB table の名前, リモートバックエンドの Output 変数 `dynamodb_table` の値をセットする |
| BACKEND_ROLE_ARN      | Role ARN, リモートバックエンドの Output 変数 `role_arn` の値をセットする                    |
| FASTLY_API_KEY        | [Fastly API token](https://docs.fastly.com/en/guides/using-api-tokens?_fsi=fmEGPI4g)        |

## リモートバックエンド

この例では State ファイルを格納するリモートバックエンドとして S3 を使用しています。

以下のコードは Terraform Module を使ってバックエンドのコンポーネントとなる S3 bucket と DynamoDB table をデプロイするためのものです。リモートバックエンドはこのリポジトリで管理する Fastly サービス・証明書とは別にデプロイします。

```
provider "aws" {
    region = "ap-northeast-1"
}

module "s3backend" {
  source  = "terraform-in-action/s3backend/aws"
  version = "0.1.10"
}

output "config" {
  value = module.s3backend
}
```

> [!NOTE]
> 使用している Terraform Module は `Terraform in Action` という書籍で紹介されていたものです。
> https://registry.terraform.io/modules/terraform-in-action/s3backend/aws/latest

### S3 バックエンドデプロイ時のアウトプットの例

`bucket`, `dynamodb_table`, `role_arn` の値をそれぞれ対応する環境変数にセットします。

```
s3backend_config = {
    bucket         = "s3backend-XXXXX-state-bucket"
    dynamodb_table = "s3backend-XXXXX-state-lock"
    region         = "ap-northeast-1"
    role_arn       = "arn:aws:iam::YYYYY:role/s3backend-XXXXX-tf-assume-role"
}
```
