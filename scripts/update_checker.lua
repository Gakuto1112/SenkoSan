---@alias UpdateChecker.CheckerStatus
---| "INIT" # 初期状態
---| "CHECKING" # アップデート確認中
---| "LATEST" # アップデート確認済み：最新版
---| "UPDATE_AVAILABLE" # アップデート確認済み：アップデートあり
---| "ERROR_INVALID_JSON" # エラー：予期しないJSONデータ
---| "ERROR_INVALID_JSON_SYNTAX" # エラー：不正なJSON構文
---| "ERROR_REQUEST_FAILED" # リクエストに失敗
---| "ERROR_NETWORK_ERR" # ネットワークエラー
---| "ERROR_NOT_ALLOWED" # ネットワーキングAPIが不許可

---@class (exact) UpdateChecker アバターのアップデートの確認を管理するクラス
---@field package AVATAR_VERSION string 現在のアバターバージョン
---@field package AVATAR_NAME string アップデート情報に出すアバター名
---@field package BRANCH_NAME string このブランチ名（キャラクター名）
---@field package CONFIG_NAME string キャッシュ目的のコンフィグファイルの名前
---@field package REPOSITORY_NAME string アップデートを確認する対象のGitHubレポジトリ名（<GitHubユーザ名>/<レポジトリ名>）
---@field package latestVersion? string リモート上にある最新のアバターバージョン
---@field package checkerStatus UpdateChecker.CheckerStatus アップデートチェッカーの状態
---@field package lastCheckTime integer 最後に更新を確認した時間（UNIX時間）
---@field package requestStatus integer 送信したリクエストのステータスコード
---@field package responseHandler Future.HttpResponse|nil httpレスポンスのハンドラ
---@field package textAnimationCount integer 新しいバージョン表示のテキストのアニメーションのカウンター
---@field package isActionWheelOpenedPrev boolean 前ティックにアクションホイールを開けていたかどうか
---@field package updateAction Action|nil 更新確認アクションのインスタンス
---@field package currentTime integer アクションホイールを開けた瞬間の時間（UNIX時間）
---@field package localeData {[string]: {[string]: string}} メッセージ等のロケールデータ
---@field package init fun(self: UpdateChecker) 初期化関数
---@field package getLocale fun(self: UpdateChecker, key: string): string 翻訳キーに対する訳文を返す。設定言語が存在しない場合は英語の文が返される。また、指定したキーの訳が無い場合は英語->キーそのままが返される。
---@field package compareVersions fun(version1: string, version2: string): string|nil 2つのバージョン文字列を比較し、新しい方を返す
---@field package showNewUpdateMessage fun(self: UpdateChecker) 新アバターバージョンのお知らせを表示する
---@field package checkUpdate fun(self: UpdateChecker) アバターアップデートの確認を行う
---@field public getUpdateAction fun(self: UpdateChecker): Action アップデート確認用のアクションを生成する

UpdateChecker = {
    ---メッセージ等のロケールデータ
    ---@type {[string]: {[string]: string}}
    localeData = {
        en_us = {
            cheking = "Checking for updates...";
            latest = "No avatar update available";
            update_available = "New avatar update is available: ";
            error_not_allowed = "Failed to check for updates - Networking API not allowed";
            error_network_err = "Failed to check for updates - Network error";
            error_request_failed = "Failed to check for updates - Request failure ";
            error_invalid_json_syntax = "Failed to check for updates - Json parsing failure";
            error_invalid_json = "Failed to check for updates - Unexpected Request";
            action_title_1 = "Check for new avatar updates ";
            action_title_2 = "(Left-click)";
            action_title_3 = "Copy URL for the latest avatar ";
            action_title_4 = "(Right-click)";
            msg_networking_api = "To enable update checking, you need to allow Figura's Networking and put \"api.github.com\" in the Network Filter from Figura settings!";
            msg_ongoing = "Checking for updates is ongoing. Please DO NOT click repeatedly!";
            msg_copied = "Copied the link to the latest avatar to your clipboard. Please open the link in your browser.";
            msg_cannot_check_latest = "Cannot get the link because cannot check the latest avatar.";
        };

        ja_jp = {
            cheking = "アップデートを確認中...";
            latest = "最新のアバターを使用中です";
            update_available = "アバターのアップデートが利用可能です：";
            error_not_allowed = "アップデート確認失敗 - ネットワーキング機能が不許可";
            error_network_err = "アップデート確認失敗 - ネットワークエラー";
            error_request_failed = "アップデート確認失敗 - リクエスト失敗 ";
            error_invalid_json_syntax = "アップデート確認失敗 - リクエスト解析失敗";
            error_invalid_json = "アップデート確認失敗 - 予期しないリクエスト";
            action_title_1 = "あばたーのあっぷでーとの確認";
            action_title_2 = "（左くりっく）";
            action_title_3 = "最新あばたーのばーじょんのりんくをこぴー";
            action_title_4 = "（右くりっく）";
            msg_networking_api = "あっぷでーとの確認機能を有効にするにはFiguraの設定から、FiguraのNetworkingの使用を許可して、\"api.github.com\"を許可りすとに入れる必要があるのじゃ！";
            msg_ongoing = "今あっぷでーとの確認中をしているところなのじゃ！お主もせっかちじゃのう～";
            msg_copied = "最新のあばたーへのりんくをこぴーしたのじゃ。お主ぶらうざで開くのじゃ！";
            msg_cannot_check_latest = "あばたーの最新ばーじょんを確認できぬから、りんくを取得できないのじゃ...。すまぬのう...。";
        };
    };

    ---コンストラクタ
    ---@return UpdateChecker
    new = function ()
        ---@type UpdateChecker
        ---@diagnostic disable-next-line: missing-fields
        local instance = {}
        setmetatable(instance, {__index = UpdateChecker})

        instance.AVATAR_VERSION = "v1.26.0_dev"
        instance.AVATAR_NAME = "SenkoSan"
        instance.BRANCH_NAME = "Sora"
        instance.CONFIG_NAME = "update_cache_senkosan"
        instance.REPOSITORY_NAME = "Gakuto1112/SenkoSan"
        instance.latestVersion = nil
        instance.checkerStatus = "INIT"
        instance.lastCheckTime = 0
        instance.requestStatus = 0
        instance.responseHandler = nil
        instance.textAnimationCount = 0
        instance.isActionWheelOpenedPrev = false
        instance.updateAction = nil
        instance.currentTime = 0

        return instance
    end;

    ---初期化関数
    ---@param self UpdateChecker
    init = function (self)
        if host:isHost() then
            events.TICK:register(function ()
                local isActionWheelOpened = action_wheel:isEnabled()
                if isActionWheelOpened then
                    local textTask = models.script_update_chacker:getTask("version_info_l3")
                    if self.checkerStatus == "UPDATE_AVAILABLE" then
                        if math.floor(self.textAnimationCount / 20) % 2 == 0 then
                            ---@cast textTask TextTask
                            textTask:setText("§6§n"..self:getLocale("update_available")..self.latestVersion)
                        else
                            ---@cast textTask TextTask
                            textTask:setText("§n"..self:getLocale("update_available")..self.latestVersion)
                        end
                        self.textAnimationCount = self.textAnimationCount + 1
                    elseif self.checkerStatus == "ERROR_REQUEST_FAILED" then
                        ---@cast textTask TextTask
                        textTask:setText(self:getLocale("error_request_failed").."("..self.requestStatus..")")
                    else
                        ---@cast textTask TextTask
                        textTask:setText(self:getLocale(self.checkerStatus:lower()))
                    end

                    if self.updateAction ~= nil then
                        local actionTitle = ""
                        if self.checkerStatus == "CHECKING" then
                            actionTitle = actionTitle.."§7"..self:getLocale("action_title_1")..self:getLocale("action_title_2").."\n"
                            self.updateAction:setColor(0.16, 0.16, 0.16)
                            self.updateAction:setHoverColor(1, 0.33, 0.33)
                        else
                            actionTitle = actionTitle..self:getLocale("action_title_1").."§b"..self:getLocale("action_title_2").."\n"
                            self.updateAction:setColor(0.78, 0.78, 0.78)
                            self.updateAction:setHoverColor(1, 1, 1)
                        end
                        if self.latestVersion ~= nil and self.currentTime < self.lastCheckTime + 86400000 then
                            actionTitle = actionTitle.."§r"..self:getLocale("action_title_3").."§b"..self:getLocale("action_title_4")
                        else
                            actionTitle = actionTitle.."§7"..self:getLocale("action_title_3")..self:getLocale("action_title_4")
                        end
                        self.updateAction:setTitle(actionTitle)
                    end
                end
                if isActionWheelOpened ~= self.isActionWheelOpenedPrev then
                    models.script_update_chacker:setVisible(isActionWheelOpened)
                    if isActionWheelOpened then
                        self.currentTime = client:getSystemTime()
                    else
                        self.textAnimationCount = 0
                    end
                    self.isActionWheelOpenedPrev = isActionWheelOpened
                end
            end)

            --キャッシュの読み込み
            local configName = config:getName()
            config:setName(self.CONFIG_NAME)
            ---@diagnostic disable-next-line: assign-type-mismatch
            self.latestVersion = config:load("latestVersion")
            local lastCheckTime = config:load("lastUpdateCheckTime")
            ---@cast lastCheckTime number|nil
            if lastCheckTime ~= nil then
                self.lastCheckTime = lastCheckTime
            end
            config:setName(configName)

            --バージョン情報の表示
            ---@diagnostic disable-next-line: discard-returns
            models:newPart("script_update_chacker", "Gui"):setVisible(false):setPos(-1.5, -1, 0):setScale(0.5)
            for i = 1, 3 do
                models.script_update_chacker:newText("version_info_l"..i):setPos(0, (i - 1) * -9, 0):setShadow(true)
            end
            ---@diagnostic disable-next-line: undefined-field
            models.script_update_chacker:getTask("version_info_l1"):setText(self.AVATAR_NAME)
            ---@diagnostic disable-next-line: undefined-field
            models.script_update_chacker:getTask("version_info_l2"):setText(self.BRANCH_NAME:len() >= 1 and self.AVATAR_VERSION.." - "..self.BRANCH_NAME or self.AVATAR_VERSION)

            --自動の更新確認
            if client:getSystemTime() >= self.lastCheckTime + 86400000 then
                self:checkUpdate()
            else
                local newerVersion = self.compareVersions(self.latestVersion, self.AVATAR_VERSION)
                if newerVersion ~= nil and newerVersion ~= self.AVATAR_VERSION then
                    self:showNewUpdateMessage()
                    self.checkerStatus = "UPDATE_AVAILABLE"
                else
                    self.checkerStatus = "LATEST"
                end
            end
        end
    end;

    ---翻訳キーに対する訳文を返す。設定言語が存在しない場合は英語の文が返される。また、指定したキーの訳が無い場合は英語->キーそのままが返される。
	---@param self UpdateChecker
	---@param key string 翻訳キー
	---@return string translatedString 翻訳キーに対する翻訳データ。設定言語での翻訳が存在しない場合は英文が返される。英文すら存在しない場合は翻訳キーがそのまま返される。
    getLocale = function (self, key)
		local activeLanguage = client:getActiveLang()
		return (self.localeData[activeLanguage] ~= nil and self.localeData[activeLanguage][key] ~= nil) and self.localeData[activeLanguage][key] or (self.localeData.en_us[key] and self.localeData.en_us[key] or key)
    end;

    ---2つのバージョン文字列を比較し、新しい方を返す。
    ---@param version1 string 比較するバージョン文字列1
    ---@param version2 string 比較するバージョン文字列2
    ---@return string|nil newerVersion 新しい方のバージョン文字列。比較不可能だった場合はnilを返す。
    compareVersions = function (version1, version2)
        local major1, minor1, patch1 = version1:match("^v(%d+)%.(%d+)%.(%d+)")
        local major2, minor2, patch2 = version2:match("^v(%d+)%.(%d+)%.(%d+)")
        major1 = tonumber(major1)
        minor1 = tonumber(minor1)
        patch1 = tonumber(patch1)
        major2 = tonumber(major2)
        minor2 = tonumber(minor2)
        patch2 = tonumber(patch2)
        if major1 ~= nil and minor1 ~= nil and patch1 ~= nil and major2 ~= nil and minor2 ~= nil and patch2 ~= nil then
            return (major1 > major2 or (major1 == major2 and minor1 > minor2) or (major1 == major2 and minor1 == minor2 and patch1 > patch2)) and version1 or version2
        end
    end;

    ---新アバターバージョンのお知らせを表示する。
    ---@param self UpdateChecker
    showNewUpdateMessage = function (self)
        print(self:getLocale("update_available")..self.latestVersion)
        sounds:playSound("minecraft:entity.experience_orb.pickup", player:getPos(), 1, 1)
    end;

    ---アバターアップデートの確認を行う。
    ---@param self UpdateChecker
    checkUpdate = function (self)
        if host:isHost() and self.checkerStatus ~= "CHECKING" then
            self.checkerStatus = "CHECKING"
            if net:isNetworkingAllowed() and net:isLinkAllowed("https://api.github.com") then
                local request = net.http:request("https://api.github.com/repos/"..self.REPOSITORY_NAME.."/tags")
                self.responseHandler = request:send()
                events.TICK:register(function ()
                    if self.responseHandler:isDone() then
                        local response = self.responseHandler:getValue()
                        if response ~= nil then
                            local stats = response:getResponseCode()
                            if math.floor(stats / 100) == 2 then
                                local stream = response:getData()
                                local buffer = data:createBuffer()
                                buffer:readFromStream(stream)
                                buffer:setPosition(0)
                                local jsonData = buffer:readByteArray()
                                if json.isSerializable(jsonData) then
                                    local parseData = parseJson(jsonData)
                                    if parseData[1] ~= nil and parseData[1].name ~= nil then
                                        local newerVersion = self.compareVersions(parseData[1].name, self.AVATAR_VERSION)
                                        if newerVersion ~= nil then
                                            if newerVersion ~= self.AVATAR_VERSION then
                                                --新しいバージョンがある
                                                self.latestVersion = parseData[1].name
                                                self.checkerStatus = "UPDATE_AVAILABLE"
                                                self:showNewUpdateMessage()
                                            else
                                                --現在は最新
                                                self.latestVersion = parseData[1].name
                                                self.checkerStatus = "LATEST"
                                            end
                                            self.lastCheckTime = client:getSystemTime()
                                            local configName = config:getName()
                                            config:setName(self.CONFIG_NAME)
                                            config:save("lastUpdateCheckTime", self.lastCheckTime)
                                            config:save("latestVersion", parseData[1].name)
                                            config:setName(configName)
                                        else
                                            --予期しないJSONデータ
                                            self.checkerStatus = "ERROR_INVALID_JSON"
                                        end
                                    else
                                        --予期しないJSONデータ
                                        self.checkerStatus = "ERROR_INVALID_JSON"
                                    end
                                else
                                    --JSON解析エラー
                                    self.checkerStatus = "ERROR_INVALID_JSON_SYNTAX"
                                end
                                stream:close()
                                buffer:close()
                            else
                                --ステータスコードが200番台以外
                                self.checkerStatus = "ERROR_REQUEST_FAILED"
                                self.requestStatus = stats
                            end
                        else
                            --ネットワークエラー
                            self.checkerStatus = "ERROR_NETWORK_ERR"
                        end
                        events.TICK:remove("update_checker_http_tick")
                    end
                end, "update_checker_http_tick")
            else
                ---ネットワーキングAPIが不許可
                self.checkerStatus = "ERROR_NOT_ALLOWED"
            end
        end
    end;

    ---アップデート確認用のアクションを生成する。
    ---@param self UpdateChecker
    ---@return Action updateAction アップデート確認用アクションのインスタンス。これをアクションホイールに設定する。
    getUpdateAction = function (self)
        self.updateAction = action_wheel:newAction()
        self.updateAction:setItem("minecraft:compass"):setOnLeftClick(function ()
            if not self.checkerStatus ~= "CHECKING" then
                self:checkUpdate()
            else
                print(self:getLocale("ongoing"))
                sounds:playSound("minecraft:block.note_block.bass", player:getPos(), 1, 0.5)
            end
            if not net:isNetworkingAllowed() or not net:isLinkAllowed("https://api.github.com") then
                print(self:getLocale("msg_networking_api"))
                sounds:playSound("minecraft:block.note_block.bass", player:getPos(), 1, 0.5)
            end
        end):onRightClick(function ()
            if self.latestVersion ~= nil and self.currentTime < self.lastCheckTime + 86400000 then
                host:setClipboard("https://api.github.com/repos/"..self.REPOSITORY_NAME.."/releases/tag/"..self.latestVersion)
                print(self:getLocale("msg_copied"))
            else
                print(self:getLocale("msg_cannot_check_latest"))
                sounds:playSound("minecraft:block.note_block.bass", player:getPos(), 1, 0.5)
            end
        end)
        return self.updateAction
    end;
}

---@type UpdateChecker
local instance = UpdateChecker.new()
instance:init()

return instance