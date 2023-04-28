--[[
    NOTE:
    - JUST EDIT THE CONFIG.LUA! -- JUST EDIT THE CONFIG.LUA! -- JUST EDIT THE CONFIG.LUA! -- JUST EDIT THE CONFIG.LUA!
    - JUST EDIT THE CONFIG.LUA! -- JUST EDIT THE CONFIG.LUA! -- JUST EDIT THE CONFIG.LUA! -- JUST EDIT THE CONFIG.LUA!
    =============================================================================================================
    - DO NOT EDIT THESE! -- DO NOT EDIT THESE! -- DO NOT EDIT THESE! -- DO NOT EDIT THESE! -- DO NOT EDIT THESE!
    - DO NOT EDIT THESE! -- DO NOT EDIT THESE! -- DO NOT EDIT THESE! -- DO NOT EDIT THESE! -- DO NOT EDIT THESE!
    =============================================================================================================
    - I WILL NOT HELP YOU FIX ANYTHING IF YOU MESS WITH AND BREAK THIS FILE -- YOU HAVE BEEN WARNED
    - I WILL NOT HELP YOU FIX ANYTHING IF YOU MESS WITH AND BREAK THIS FILE -- YOU HAVE BEEN WARNED
]]


--[[ HANDLE NIL VALUES ON ALL WEBHOOK URLS]]
if S_CONFIG.DiscordServerLogs == nil and S_CONFIG.DiscordKillingLogs == nil and S_CONFIG.DiscordWebhookChat == nil then

    local Content = LoadResourceFile(GetCurrentResourceName(), 'settings.lua')
    
    Content = load(Content)

    Content()
end

--[[ CHECK FOR AND HANDLE SERVER LOGS WEBHOOK ERRORS ]]
if S_CONFIG.DiscordServerLogs == 'WEBHOOK_LINK_HERE' then

    print('[FiveM2Discord]: Please add/update your "Server Logs" webhook')

else

    PerformHttpRequest(S_CONFIG.DiscordServerLogs, function(Error, Content, Head)

        if Content == '{"code": 50027, "message": "Invalid Webhook Token"}' then

            print('[FiveM2Discord]: Server Logs Webhook or Token is non existent. You may want to generate a new one')
        end
    end)
end

-- [[ CHECK FOR AND HANDLE KILL LOGS WEBHOOK ERRORS]]
if S_CONFIG.DiscordKillingLogs == 'WEBHOOK_LINK_HERE' then

    print('[FiveM2Discord]: Please add/update your "Kill Logs" webhook')

else

    PerformHttpRequest(S_CONFIG.DiscordKillingLogs, function(Error, Content, Head)

        if Content == '{"code": 50027, "message": "Invalid Webhook Token"}' then

            print('[FiveM2Discord]: Kill Logs Webhook or Token is non existent. You may want to generate a new one')
        end
    end)
end

--[[ CHECK FOR AND HANDLE DISCORD WEBHOOK CHAT LOG ERRORS]]
if S_CONFIG.DiscordWebhookChat == 'WEBHOOK_LINK_HERE' then

    print('[FiveM2Discord]: Please add/update your "Webhook Chat" webhook')

else

    PerformHttpRequest(S_CONFIG.DiscordWebhookChat, function(Error, Content, Head)

        if Content == '{"code": 50027, "message": "Invalid Webhook Token"}' then

            print('[FiveM2Discord]: Webhook for Chat Logs is non existent. You may want to generate a new one')
        end
    end)
end

if CONFIGURATION.Messages.UseEmbeds then
    
    local startUp = {
        {
            color = 0x0099FF,
            author = {
                name = 'SYSTEM Startup',
                icon_url = CONFIGURATION.Messages.EmbedImage,
                url  = 'https://github.com/toxic-development/FiveM2Discord' -- Best you dont change this and give credit where its due
            },
            description = 'Resource start up successful!',
            thumbnail = {
                url = CONFIGURATION.Messages.EmbedImage
            },
            footer = {
                text = '© 2023 FiveM2Discord | Made by: Toxic Dev',  -- Best you dont change this and give credit where its due
                icon_url = CONFIGURATION.Messages.EmbedImage
            }
        }
    }

  PerformHttpRequest(S_CONFIG.DiscordServerLogs, function(err, text, headers) end, 'POST', json.encode({username = CONFIGURATION.System.SystemName, avatar_url = CONFIGURATION.System.SystemAvatar, embeds = startUp}), { ['Content-Type'] = 'application/json' })

else

    PerformHttpRequest(S_CONFIG.DiscordServerLogs, function(err, text, headers) end, 'POST', json.encode({username = CONFIGURATION.System.SystemName, avatar_url = CONFIGURATION.System.SystemAvatar, '**[Discord2FiveM]:** Start up successful'}), { ['Content-Type'] = 'application/json' })
end


AddEventHandler('playerConnecting', function()

    TriggerEvent('FiveM2Discord:SendWebhookLogs', S_CONFIG.DiscordServerLogs, CONFIGURATION.System.SystemName, '```css\n' .. GetPlayerName(source) .. ' connecting\n```', CONFIGURATION.System.SystemAvatar, false)
end)

AddEventHandler('playerDropped', function(Reason)

    TriggerEvent('FiveM2Discord:SendWebhookLogs', S_CONFIG.DiscordServerLogs, CONFIGURATION.System.SystemName, '```fix\n' .. GetPlayerName(source) .. ' left (' .. Reason .. ')\n```', CONFIGURATION.System.SystemAvatar, false)
end)

--[[KILLING LOGS HANDLER]]
RegisterServerEvent('FiveM2Discord:playerDied')
AddEventHandler('FiveM2Discord:playerDied', function(Message, Weapon)

    local date = os.date('*t')

    if date.day < 10 then date.day = '0' .. tostring(date.day) end
    if date.month < 10 then date.month = '0' .. tostring(date.month) end
	if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
	if date.min < 10 then date.min = '0' .. tostring(date.min) end
	if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end

    if Weapon then

        Message = Message .. ' [' .. Weapon .. ']'
    end

    TriggerEvent('FiveM2Discord:SendWebhookLogs', S_CONFIG.DiscordKillingLogs, CONFIGURATION.System.SystemName, Message .. ' `' .. date.day .. '.' .. date.month .. '.' .. date.year .. ' - ' .. date.hour .. ':' .. date.min .. ':' .. date.sec .. '`', CONFIGURATION.System.SystemAvatar, false)
end)

--[[CHAT HANDLER BOIII]]
AddEventHandler('chatMessage', function(Source, Name, Message)

    local Webhook = S_CONFIG.DiscordWebhookChat; TTS = false

    -- Remove color codes from the name and Message
    for i = 0, 9 do

        Message = Message:gsub('%^' .. i, '')
		Name = Name:gsub('%^' .. i, '')
    end

    -- Split the message into multiple strings
    MessageSplitted = stringsplit(Message, ' ')

    -- Check if the message contains a blacklisted command
    if not IsCommand(MessageSplitted, 'Blacklisted') then
        -- Check if the command has its own Webhook
        if IsCommand(MessageSplitted, 'HavingOwnWebhook') then

            Webhook = GetOwnWebhook(MessageSplitted)
        end

        -- Check if the message contains a special command
        if IsCommand(MessageSplitted, 'Special') then

            MessageSplitted = ReplaceSpecialCommand(MessageSplitted)
        end

        -- Check if the message contains a command that belongs to a tts channel
        if IsCommand(MessageSplitted, 'TTS') then

            TTS = true
        end

        -- Combine the message to one string again
        Message = ''

        for Key, Value in ipairs(MessageSplitted) do

            Message = Message .. Value .. ' '
        end

        -- Adding the username if needed
        Message = Message:gsub('USERNAME_NEEDED_HERE', GetPlayerName(Source))

        -- Adding the userid if needed
        Message = Message:gsub('USERID_NEEDED_HERE', Source)

        -- Shortens the name if needed
        if Name:len() > 23 then

            Name = Name:sub(1, 23)
        end

        -- Get the steam avatar if available
        local AvatarURL = CONFIGURATION.System.UserAvatar

        if GetIDFromSource('steam', Source) then

            PerformHttpRequest('http://steamcommunity.com/profiles/' .. tonumber(GetIDFromSource('steam', Source), 16) .. '/?xml=1', function(Error, Content, Head)

                local SteamProfileSplitted = stringsplit(Content, '\n')

                for i, Line in ipairs(SteamProfileSplitted) do

                    if Line:find('<avatarFull>') then

                        AvatarURL = Line:gsub('	<avatarFull><!%[CDATA%[', ''):gsub(']]></avatarFull>', '')

                        TriggerEvent('FiveM2Discord:SendWebhookLogs', Webhook, Name .. ' [ID: ' .. Source .. ']', Message, AvatarURL, false, Source, TTS)
                        break
                    end
                end
            end)
        else

            -- Use the default avatar if steam not available
            TriggerEvent('FiveM2Discord:SendWebhookLogs', Webhook, Name .. ' [ID: ' .. Source .. ']', Message, AvatarURL, false, Source, TTS)
        end
    end
end)

-- [[ TRIGGER THE EVENT THAT SENDS MESSAGES TO DISCORD]]
RegisterServerEvent('FiveM2Discord:SendWebhookLogs')
AddEventHandler('FiveM2Discord:SendWebhookLogs', function(WebHook, Name, Message, Image, External, Source, TTS)

    if Message == nil or Message == '' then

        return nil
    end

    if TTS == nil or TTS == '' then

        TTS = false
    end

    if External then

        if WebHook:lower() == 'chat' then

            WebHook = S_CONFIG.DiscordWebhookChat

        elseif WebHook:lower() == 'system' then

            WebHook = S_CONFIG.DiscordServerLogs

        elseif WebHook:lower() == 'kill' then

            WebHook = S_CONFIG.DiscordKillingLogs

        elseif not WebHook:find('discordapp.com/api/webhooks') then

            print('[FiveM2Discord]: SendWebhookLogs event called without a specified webhook type')

            return nil
        end

        if Image:lower() == 'steam' then

            Image = CONFIGURATION.System.UserAvatar

            if GetIDFromSource('steam', Source) then

                PerformHttpRequest('http://steamcommunity.com/profiles/' .. tonumber(GetIDFromSource('steam', Source), 16) .. '/?xml=1', function(Error, Content, Head)

                    local SteamProfileSplitted = stringsplit(Content, '\n')

                    for i, Line in ipairs(SteamProfileSplitted) do

                        if Line:find('<avatarFull>') then

                            Image = Line:gsub('	<avatarFull><!%[CDATA%[', ''):gsub(']]></avatarFull>', '')

                            return PerformHttpRequest(WebHook, function(Error, Content, Head) end, 'POST', json.encode({username = Name, content = Message, avatar_url = Image, tts = TTS}), {['Content-Type'] = 'application/json'})
                        end
                    end
                end)
            end

        elseif Image:lower() == 'user' then

            Image = CONFIGURATION.System.UserAvatar
        else

            Image = CONFIGURATION.System.SystemAvatar
        end
    end

    if CONFIGURATION.Messages.UseEmbeds then

        local embed = {
            {
                color = 0x0099FF,
                title = 'Server Logs',
                author = {
                    name = 'Discord2FiveM',
                    icon_url = CONFIGURATION.Messages.EmbedImage,
                    url  = 'https://github.com/toxic-development/FiveM2Discord' -- Best you dont change this and give credit where its due
                },
                desription = Message,
                thumbnail = {
                    url = Image
                },
                footer = {
                    text = '© 2023 FiveM2Discord | Made by: Toxic Dev',  -- Best you dont change this and give credit where its due
                    icon_url = CONFIGURATION.Messages.EmbedImage
                }
            }
        }

        PerformHttpRequest(WebHook, function(Error, Content, Head) end, 'POST', json.encode({username = Name, embeds = embed, avatar_url = Image, tts = TTS}), {['Content-Type'] = 'application/json'})

    else
        
        PerformHttpRequest(WebHook, function(Error, Content, Head) end, 'POST', json.encode({username = Name, content = Message, avatar_url = Image, tts = TTS}), {['Content-Type'] = 'application/json'})
    end
end)

--[[
    Note:
    - These are needed functions
    - They check for webhook types and command options (blacklisted etc)
]]
function IsCommand(String, Type)

    if Type == 'Blacklisted' then

        for i, BlacklistedCommand in ipairs(CONFIGURATION.BlacklistedCommands) do

            if String[1]:lower() == BlacklistedCommand:lower() then

                return true
            end
        end

    elseif Type == 'Special' then

        for i, SpecialCommand in ipairs(CONFIGURATION.SpecialCommands) do

            if String[1]:lower() == SpecialCommand[1]:lower() then

                return true
            end
        end

    elseif Type == 'HavingOwnWebhook' then

        for i, OwnWebhookCommand in ipairs(CONFIGURATION.OwnWebhookCommands) do

            if String[1]:lower() == OwnWebhookCommand[1]:lower() then

                return true
            end
        end

    elseif Type == 'TTS' then

        for i, TTSCommand in ipairs(CONFIGURATION.TextToSpeechCommands) do

            if String[1]:lower() == TTSCommand:lower() then

                return true
            end
        end
    end

    return false
end

function ReplaceSpecialCommand(String)

    for i, SpecialCommand in ipairs(CONFIGURATION.SpecialCommands) do

        if String[1]:lower() == SpecialCommand[1]:lower() then

            String[1] = SpecialCommand[2]
        end
    end

    return String
end

function GetOwnWebhook(String)

    for i, OwnWebhookCommand in ipairs(CONFIGURATION.OwnWebhookCommands) do

        if String[1]:lower() == OwnWebhookCommand[1]:lower() then

            if OwnWebhookCommand[2] == 'WEBHOOK_LINE_HERE' then

                print('[FiveM2Discord]: Please enter a webhook link for the command: ' .. String[1])

                return S_CONFIG.DiscordWebhookChat

            else

                return OwnWebhookCommand[2]

            end
        end
    end
end

function stringsplit(input, seperator)

    if seperator == nil then

        seperator = '%s'
    end

    local t={}; i=1

    for str in string.gmatch(input, '([^'..seperator..']+)') do

        t[i] = str

        i = i + 1
    end

    return t
end

function GetIDFromSource(Type, ID)

    local IDs = GetPlayerIdentifiers(ID)

    for k, CurrentID in pairs(IDs) do

        local ID = stringsplit(CurrentID, ':')

        if (ID[1]:lower() == string.lower(Type)) then

            return ID[2]:lower()
        end
    end

    return nil
end

--[[
    NOTE: 
    - This is what controls the version check on startup
    its probably best you dont touch this. If you want to
    disable the version checks just set the `UpdateCheck`
    setting in the `settings.lua` file to false
]]
if CONFIGURATION.System.UpdateCheck then

    function GetCurrentVersion()
        
        return GetResourceMetadata(GetCurrentResourceName(), 'version')
    end

    local CurrentVersion = '0.0.3'
    local GithubResourceName = 'fivem2discord'

    PerformHttpRequest('https://raw.githubusercontent.com/NARC-FiveM/Versions/master/' .. GithubResourceName .. '/VERSION.txt', function(Error, NewestVersion, Header)
        
        PerformHttpRequest('https://raw.githubusercontent.com/NARC-FiveM/Versions/master/' .. GithubResourceName .. '/CHANGES', function(Error, Changes, Header)
        
            print('\n')
            print('##############')
            print('Version Check for: ' .. GetCurrentResourceName())
            print('##############')
            print('Current Version: ' .. CurrentVersion)
            print('Newest Version: ' .. NewestVersion)
            print('##############')

        if (tonumber(NewestVersion) ~= tonumber(CurrentVersion)) then
                    
            print('Error: You are using an outdated version')
            print('Please check our github for the newest release')
            print('Github: https://github.com/NARC-FiveM/Resources/discord-logs')
            print('##############')
            print('Change Log: \n' .. Changes)
            print('##############')
                      
        else
        
            print('Success: You are up to date and good to go')
            print('##############')
        end
    end)
  end)
end