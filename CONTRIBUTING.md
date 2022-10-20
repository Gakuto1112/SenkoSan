# コントリビュートする際は
このレポジトリに対してコントリビュートする際の注意事項です。

## READMEについて
- このレポジトリの[README.md](./README.md)は[README_full.md](./.github/workflows/README_full.md)を基にして、[Github Actions](https://github.co.jp/features/actions)によって自動生成されます。よって、READMEを編集する際は、 **README.mdではなく、README_full.mdを編集して下さい。** メインブランチにマージされた際に、自動的にREADME.mdに反映されます。
- Github ActionsによってREADMEが以下のように編集されます。
  - 画像タグ（``![画像の説明](画像のパス)``）が削除されます。ただし、直前の行に ``<!-- REQUIRED_IMAGE -->``とコメントすると削除されなくなります。
    ```
    <!-- REQUIRED_IMAGE -->
    ![画像の説明](画像のパス)
    ```
  - ``<!-- REMOVE_LINE -->``とコメントした行が削除されます。削除される画像に対する説明文などにお使いください。...というか、コメントをした行は全て削除されます。
    ```
    - この説明文は、下の画像がないと成り立ちません。<!-- REMOVE_LINE -->
    ```
  - ``<!-- SIMPLE_MESSAGE -->``とコメントした行に、「[簡易版READMEのメッセージ](/.github/workflows/simple_message.md)」が挿入されます。
- READMEを簡易版と完全版に分けた理由は、大きな画像をダウンロードせずにREADMEを読めるようにしたためです。画像を挿入する際は、必要最低限以外の画像には``<!-- REQUIRED_IMAGE -->``を使用しないようにして下さい。

## simple_message.mdについて
- [simple_message.md](/.github/workflows/simple_message.md)は、GitHub Actionsによってこのファイルの内容が``<!-- SIMPLE_MESSAGE -->``に挿入されます。
- ``<!-- FILE_SIZE -->``とコメントした場所に[README_images](./README_images)内のファイルのサイズの合計値が挿入されます。
