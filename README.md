# SenkoSan（仙狐さん）
TVアニメ「世話やきキツネの仙狐さん」（とその原作）に登場するキャラクターを再現した、MinecraftのスキンMod「[Figura](https://www.curseforge.com/minecraft/mc-mods/figura)」向けスキン「SenkoSan（仙狐さん）」です。

**このREADMEには本来、大量の画像（約67MB）を添付していますが、通信量の軽減のため、必要最低限以外の画像は添付されおりません。全ての画像を確認したい方は[README（完全版）](./.github/workflows/README_full.md)をご覧ください。**

対応Figuraバージョン：[0.1.0-rc.10](https://www.curseforge.com/minecraft/mc-mods/figura/files/4073363)

![メイン](README_images/メイン.jpg)

## 特徴
- 耳と尻尾のモデルが生えています。
  - 尻尾はプレイヤーの動きに合わせて揺れます。

  - 耳は**Xキー**、尻尾は**Zキー**で動かすことができます。

- 現在のHPや満腹度に応じてキャラクターの耳が垂れさがったり、表情が変わったりします。

- 時々瞬きします。
- [アクションホイール](#アクションホイール13)で様々なアニメーションを実行できます。

- [アクションホイール](#アクションホイール23)で座ることができます。
  - 座らないと実行できないアニメーションがあります。

- 就寝時は狐のような寝姿になります（第2話）。
  - 暗闇デバフを受けている時はまた別の寝姿（？）になります。

- 複数の衣装チェンジができます。どのような衣装があるかは[衣装カタログ](衣装一覧.md)をご覧ください。

- あなたの表示名をキャラクターの名前に変更できます。
  - 他のプレイヤーがこの名前を見えるようにするには、**他のプレイヤーもFiguraを導入し、他のプレイヤー側であなたに対する信頼設定を十分上げる必要があります**。
  - 0.1.0-rc10では、一時的にプレイヤーリストのアバター表示が無効になっています。
    > added a new setting to toggle whether UI elements should render the avatar portrait instead of the vanilla skin, (default OFF)

    > currently locked as of the portrait rendering is VERY glitchy

- 水に触れると濡れてしまいます。
  - 水から上がると身震いして体に付いた水滴を飛ばします（[設定](#アバター設定)でオフにできます）。

  - 尻尾は水にぬれるとしなびてしまいます（第5話）。

- 雨が降っていると傘をさします。
  - 傘をさしている場合は雨で濡れることはありません。
  - オフハンドにアイテムを持っている時やアニメーションを再生した時は雨でも傘をしまいます（この場合はもちろん濡れます）。
  - 傘を開閉する音は[設定](#アバター設定)でオフにできます。

- 暗視が付与されていると頭上に狐火が出現します。
  - 濡れている場合は消えてしまいます。

- 特定のGUIが開いている間は眼鏡をかけます（第4話）。

- ウォーデンが付近いる（≒暗闇デバフを受けている）と、怯えて震えます。

  - 怯えている時は、エモートを拒否拒否するようになります。

## アクションホイール（1/3）
Figuraには、アクションホイールキー（デフォルトは「B」キー）を押すことで、エモートなどを実行できるリングメニューが実装されています。このアバターにもいくつかのアクションが用意されています。

![アクションホイール1](README_images/アクションホイール1.jpg)

### アクション1-1. にっこり（うやん♪）
他のアクションの最後で行うにっこりを単体で行います。左クリックでにっこりするだけ、右クリックで効果音とパーティクルも再生されます。

### アクション1-2. ブルブル
水から上がった際のブルブルを手動で実行できます。

### アクション1-3. お掃除
左クリックで箒掃除、右クリックで拭き掃除を行います。箒掃除にはレアパターンが存在します（レアパターンのアニメーションは第4話）。

### アクション1-4. 散髪
プレイヤーの髪を整えてくれます（第9話、スキンはプレイヤーのスキンになります）。少し切り過ぎますが...

### アクション1-5. きつねジャンプ
キツネのように雪に飛び込みます（第10話）。雪が十分に積もっており、十分なスペースが必要です。

## アクションホイール（2/3）
![アクションホイール2](README_images/アクションホイール2.jpg)

### アクション2-1. おすわり
その場に座ります。もう一度アクション実行で立ち上がります。座っている時に動いたり、ジャンプしたり、スニークしたりすると自動で立ち上がります。

### アクション2-2. 尻尾モフモフ
プレイヤーが仙狐さんの尻尾をモフモフします（第1話、スキンはプレイヤーのスキンになります）。このアクションを実行するには先に座って下さい。ただし、変装服や防具表示状態でチェストプレートを着用している場合は実行できません。

### アクション2-3. 耳かき
膝枕でプレイヤーの耳を掃除してくれます（第2話、スキンはプレイヤーのスキンになります）。このアクションを実行するには先に座って下さい。

### アクション2-4. お茶
ほうじ茶を飲んで一息つきます（第6話）。このアクションを実行するには先に座って下さい。

### アクション2-5. マッサージ
プレイヤーの肩をほぐしてくれます（第7話、スキンはプレイヤーのスキンになります）。このアクションを実行するには先に座って下さい。

## アクションホイール（3/3）
![アクションホイール3](README_images/アクションホイール3.jpg)

### アクション3-1. 仙狐さんセリフ集
仙狐さんがアニメ内で使用していたフレーズを7つ選びました。クリックすると、チャットでセリフを発言します。**このセリフは通常のチャットと同様に送信され、Figuraを使用していないプレイヤーにも表示されます。**この機能を使用するにはFigura設定の**Chat Messages**が有効でないと機能しません。一度アクションホイールを閉じると、セリフ集を閉じることができます。

### アクション3-2. アバター設定
アバター各種設定を行う画面に遷移します。詳しくは[アバター設定](#アバター設定)をご覧下さい。

## アバター設定
[アクション3-2](#アクション3-2-仙狐さん設定)を実行するとこの画面が表示されます。一度アクションホイールを閉じると、設定画面を閉じることができます。

![設定画面](README_images/設定ページ.jpg)

### アクション1. 衣装変更
仙狐さんの[衣装](衣装一覧.md)を変更します。スクロールで衣装を変更し、アクションホイールを閉じると確定します。

### アクション2. 名前変更
プレイヤーの表示名を変更します。スクロールで表示名を選択し、アクションホイールを閉じると確定します。。ただし、他のプレイヤーが変更された名前を見るには、**そのプレイヤーもFiguraを導入し、他のプレイヤー側であなたに対する信頼設定を十分上げる必要があります**。

### アクション3. 自動ブルブルの切り替え
濡れている際に自動的に[ブルブル](#アクション1-2-ブルブル)を実行するかどうかを設定できます。

### アクション4. 防具の表示の切り替え
防具を表示するかどうかを設定できます。一部の[衣装](衣装一覧.md)は防具と干渉しないように、防具装備中は非表示になります。

### アクション5. 一人称視点での狐火の表示の切り替え
一人称視点で狐火のパーティクルを表示するかどうかを設定できます。上を向いた際に、頭上の狐火が煩わしいと感じる場合はオフにして下さい。

### アクション6. 傘の開閉音の切り替え
傘の開閉音を再生するかどうかを設定できます。傘の開閉音が煩わしいと感じる場合はオフにして下さい。

## 使用方法
1. マインクラフト1.19.2に[Fabric](https://fabricmc.net/)をインストールし、[Fabric API](https://www.curseforge.com/minecraft/mc-mods/fabric-api)と[Figura 0.1.0-rc.10+1.19.2](https://www.curseforge.com/minecraft/mc-mods/figura/files/4073363)を追加します。各Modの依存関係にご注意ください。
2. ページ上部の緑色のボタン「**Code**」から「**Download ZIP**」からこのレポジトリのファイルをダウンロードします。（または、このレポジトリをクローンします。）
3. 圧縮ファイルの場合は展開します。
   - 以下のファイル、フォルダはアバターの動作には不要なので削除しても構いません。
     - [.github](.github/)
     - [README_images](README_images/)
     - [.gitignore](.gitignore)
     - [CONTRIBUTING.md](CONTRIBUTING.md)
     - [README.md](README.md)
     - [衣装一覧.md](衣装一覧.md)
4. ``<マインクラフトのゲームフォルダ>/figura/avatars/``にアバターのデータを配置します。
   - フォルダはFiguraを追加したマインクラフトを一度起動すると自動的に生成されます。ない場合は手動で作成しても構いません。
5. ゲームメニューからFiguraメニュー（Δマーク）を開き、画面左のアバターリストから「仙狐さん」を選択します。
6. 必要に応じて[権限設定](#推奨設定)をして下さい。
7. アバターをサーバーにアップロードすると、他のFiguraプレイヤーもあなたのアバターを見ることができます。

## 推奨設定
### 信用度設定（Trust）
**Trusted**以上推奨

| 項目 | 推奨設定 | 備考 |
| - | - | - |
| Vanilla Model Change | **有効！！** | これが有効でないと、バニラのプレイヤーモデルが消えません！！ |
| Nameplate Change | 有効 | |
| Custom Player Heads | 有効 | |

### Figura設定（Settings）

| 項目 | 推奨設定 | 備考 |
| - | - | - |
| Chat customizations | "Script" または "Script + Badges" | |
| Entity customizations | "Script" または "Script + Badges" | |
| Tablist customizations | "Script" または "Script + Badges" | |
| Print Output | "Chat" | |
| First Person Hands | 無効 | |
| Chat Messages | 有効 | セリフ集からチャット発言するのに必要です。また、**安全のため、他のアバターに切り替える際は無効にして下さい。** |

### マインクラフト設定
| 項目 | 推奨設定 | 備考 |
| - | - | - |
| キー設定 | ZキーやXキーにキー割り当てを行わない | |
| 言語設定 | 日本語 | 日本語以外の言語では英語表示になります。また、英語への翻訳は正確でない可能性があります。 |

## 注意事項
- このアバターは[Figuraコミュニティー](https://discord.gg/ekHGHcH8Af)に寄せられたリクエストの延長線上のアバターです。
- このアバターを使用して発生した、いかなる損害の責任も負いかねます。
- 原作漫画を読むつもりはありません。
- 不具合がありましたら、[Issues](https://github.com/Gakuto1112/SenkoSan/issues)までご連絡下さい。

## リンク集
- [Figura（CurseForge）](https://www.curseforge.com/minecraft/mc-mods/figura)
- [Figura（Modrinth）](https://modrinth.com/mod/figura)
- [TVアニメ「世話やきキツネの仙狐さん」オフィシャルサイト](http://senkosan.com/)
- [Amazon.co.jp_ 世話やきキツネの仙狐さんを観る _ Prime Video](https://www.amazon.co.jp/gp/video/detail/B07QJG9NP7)