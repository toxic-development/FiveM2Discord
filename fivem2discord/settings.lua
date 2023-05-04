--[[
    Note:
    - This settings file can be intimidating and difficult to setup
    - If you need help do not hesitate to contact me by making a github issue or joining here: https://narc.live/join
]]

CONFIGURATION = {
    System = {
        SystemAvatar = 'https://wiki.fivem.net/w/images/d/db/FiveM-Wiki.png', -- Change this to a link of your choice!
        UserAvatar = 'https://i.imgur.com/KIcqSYs.png', -- Change this to a link of your choice!
        SystemName = 'SYSTEM', -- Change this to a name of your choice!
        UpdateCheck = true, -- Allow the resource to check for updates on startup!
    },
    Messages = {
        UseEmbeds = false, -- Send the messages to discord as an embed
        EmbedImage = 'https://cdn.discordapp.com/attachments/653733403841134600/1101375870955966514/FiveM.png' -- You can change this
    },
    --[[
        Special Command Formating:
        - *YOUR_TEXT*			--> Make Text Italics in Discord
		- **YOUR_TEXT**			--> Make Text Bold in Discord
	    - ***YOUR_TEXT***			--> Make Text Italics & Bold in Discord
		- __YOUR_TEXT__			--> Underline Text in Discord
	    - __*YOUR_TEXT*__			--> Underline Text and make it Italics in Discord
	    - __**YOUR_TEXT**__			--> Underline Text and make it Bold in Discord
	    - __***YOUR_TEXT***__		--> Underline Text and make it Italics & Bold in Discord
		- ~~YOUR_TEXT~~			--> Strikethrough Text in Discord
        - Use 'USERNAME_NEEDED_HERE' without the quotes if you need a Users Name in a special command
        - Use 'USERID_NEEDED_HERE' without the quotes if you need a Users ID in a special command
        -========================================================================================
        - These special commands will be printed differently in discord, depending on what you set it to
    ]]
    SpecialCommands = {
        {'/ooc', '**[OOC]:**'},
		{'/me', '**[ME]:**'},
		{'/fix', '**[FIX]:**'},
		{'/dv', '**[DV]:**'},
		{'/do', '**[DO]:**'},
		{'/twt', '**[TWEET]:**'},
		{'/news', '**[WEAZEL NEWS]:**'},
		{'/ad', '**[ADVERTISEMENT]:**'},
		{'/repair', '**[MECHANIC]:**'},
		{'/dispatch', '**[DISPATCH]:**'},
		{'/911', '**[911]: (CALLER ID: [ USERNAME_NEEDED_HERE | USERID_NEEDED_HERE ])**'},
    },
    --[[
        Note:
        - These blacklisted commands will not be printed to any discord channel
    ]]
    BlacklistedCommands = {
        '/jail',
        '/unjail'
    },
    --[[
        Note:
        - These commands will use a webhook seperate from the ones listed above
        - This is generally used if you for example want to send 911 commands to a "dispatch" channel
    ]]
    OwnWebhookCommands = {
        {'/911', 'YOUR_WEBHOOK_HERE'},
		{'/dispatch', 'YOUR_WEBHOOK_HERE'},
		{'/me', 'YOUR_WEBHOOK_HERE'},
		{'/fix', 'YOUR_WEBHOOK_HERE'},
		{'/dv', 'YOUR_WEBHOOK_HERE'},
		{'/twt', 'YOUR_WEBHOOK_HERE'},
		{'/do', 'YOUR_WEBHOOK_HERE'},
		{'/news', 'YOUR_WEBHOOK_HERE'},
		{'/ad', 'YOUR_WEBHOOK_HERE'},
		{'/repair', 'YOUR_WEBHOOK_HERE'},
    },
    --[[
        Note:
        - These commands will be sent as text to speech messages
    ]]
    TextToSpeechCommands = {
        '/whatever',
        '/whatever2'
    }
}