# OSS Bootcamp 課題1
## 課題内容
課題はServerspecによるテストが失敗するインフラコードをテストが通るように修正することです。

このリポジトリ内にあるplaybooks以下はAnsibleのplaybookに関連するファイルが格納されています。
プロビジョニング対象に対して以下のことを行なうplaybookです。

- サーバに必要な各種設定（ユーザやグループの作成等）
   - playbooks/roles/common以下のファイルで設定しています。

- Nginxのインストール/設定
   - playbooks/roles/web以下のファイルで設定しています。
   - NginxはOSSのWebサーバで次世代のApachとして広く利用されています。
     - 詳細は [こちら](https://nginx.org/en/)を御覧ください。
     - 今回のケースではリバースプロキシとして使用する想定になっています。

- Tomcatのインストール/設定
   - playbooks/roles/app以下のファイルで設定しています。
   - TomcatはOSSのアプリケーションサーバでJavaのアプリケーションと連携して広く利用されています。
     - 詳細は[こちら](http://tomcat.apache.org/)を御覧ください。

- MySQLのインストール/設定
   - playbooks/roles/db以下のファイルで設定しています。
   - MySQLは言わずと知れたLAMPの一角を担うDBMSです。
     - 詳細は[こちら](https://www.mysql.com/jp/)を御覧ください。

上記の内容でプロビジョニングすることができますが、Serverspecによるテストを実行すると失敗します。
つまり、意図している設定値になっていない箇所がいくつかある、ということです。例えば tomcatを7000番ポートで
起動する設計になっていたにも関わらずplaybookには8080番ポートで起動する設定になっているため、テストが失敗する
等です。
今回の課題は失敗したテストの内容を見て、テストが通るようにplaybookの記述を修正してください。

## ディレクトリ構成

```

./
|-- README.md  # 説明
|-- playbooks  # Ansible のplaybook に関連するファイルが格納されているディレクトリ
|   |-- development.yml # 開発環境にデプロイする用の設定ファイル ＊今回の課題では使用しない
|   |-- group_vars      # playbookで使用する変数が定義されたファイル
|   |   `-- all
|   |-- inventory       # インベントリファイル
|   |-- roles           # 4つのロール（common, app, web, db）に分けてplaybookを作成する
|   |   |-- app         # Tomcatのインストール設定を行なう
|   |   |   |-- files
|   |   |   |   `-- tomcat-initscript.sh
|   |   |   |-- handlers
|   |   |   |   `-- main.yml
|   |   |   |-- tasks
|   |   |   |   `-- main.yml
|   |   |   `-- templates
|   |   |       |-- server.xml
|   |   |       `-- tomcat-users.xml
|   |   |-- common      # サーバの設定に必要な設定を行なう
|   |   |   |-- files
|   |   |   |   `-- authorized_keys_for_oracle
|   |   |   |-- tasks
|   |   |   |   `-- main.yml
|   |   |   `-- templates
|   |   |       |-- bash_profile
|   |   |       |-- sudoers
|   |   |       `-- yum_conf
|   |   |-- db          # MySQLのインストールおよび設定を行なう
|   |   |   |-- handlers
|   |   |   |   `-- main.yml
|   |   |   |-- tasks
|   |   |   |   `-- main.yml
|   |   |   `-- templates
|   |   |       `-- mysql_conf
|   |   `-- web         # Nginxのインストールおよび設定を行なう
|   |       |-- handlers
|   |       |   `-- main.yml
|   |       |-- tasks
|   |       |   `-- main.yml
|   |       `-- templates
|   |           `-- tomcat_nginx_conf
|   |-- test.retry
|   `-- test.yml # Serverspec テスト用にtest_docker_container という名前のコンテナに対してテストを行なう設定をするファイル
`-- test
    |-- Rakefile
    |-- build.sh # テスト対象のコンテナの起動 + rake spec を行なうシェルスクリプト
    `-- spec
        |-- localhost
        |   |-- app_spec.rb    # app ロールのplaybookをテストするspecファイル
        |   |-- common_spec.rb # common ロールのplaybookをテストするspecファイル
        |   |-- db_spec.rb     # db ロールのplaybookをテストするspecファイル
        |   `-- web_spec.rb    # web ロールのplaybookをテストするspecファイル
        `-- spec_helper.rb

```

## テスト実行方法

test/build.sh を実行します。
Ansible の PlaybookをテストするためにDockerコンテナ(CentOS 6.9ベース)を起動して
コンテナに対してプロビジョニングし、Serverspecでそのコンテナに対してテストを実行しています。
そのため単純にrake spec を実行するとDockerコンテナが起動していない場合エラーになります。
test/build.sh ではDockerコンテナをデーモンで起動して、コンテナに対してAnsible でプロビジョニングを行った後で
rake specを実行するようになっています。
そのため、test/build.shを使用すると簡単にテストを実行できます。


## jenkinsのビルド設定

jenkinsにはすでにdockerを起動する設定が書かれているため、
JenkinsでCIするためには、Serverspecのビルドと test/build.shの実行を
Jenkinsのビルドスクリプトに記述すること。

## 課題への取り組み方の流れ 例

#### 1. ローカルPC(VM)へGit Clone

```
git clone http://devops01.jp.oracle.com/gitlab/htamakos/devops_task1.git
```

#### 2. テストを実行する

```
$ sh test/build.sh
```

#### 3. テストの失敗内容を確認

#### 4. インフラコード(playbooksディレクトリ以下)を確認・修正

1. ブランチを作成
2. ファイルを修正

#### 5. テストを実行して成功することを確認

```
$ sh test/build.sh
```

#### 6. コミットしてpushする

```
$ git commit -am "FIX: xxxxxx"
$ git push origin fix-xxxxx-branch
```

#### 7. Gitlab上でMerge Request を作成する
