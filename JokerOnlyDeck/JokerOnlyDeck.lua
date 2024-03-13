--- STEAMODDED HEADER
--- MOD_NAME: Joker Only Deck
--- MOD_ID: JokerOnlyDeck
--- MOD_AUTHOR: [Mojimoon]
--- MOD_DESCRIPTION: Adds a deck that filters out all consumables and vouchers, leaving only the jokers.

----------------------------------------------
------------MOD CODE -------------------------

local Backapply_to_runRef = Back.apply_to_run
function Back.apply_to_run(arg_56_0)
	Backapply_to_runRef(arg_56_0)

    if arg_56_0.effect.config.moji_ban_sets then
        G.E_MANAGER:add_event(Event({
            func = function()
                for k, v in ipairs(arg_56_0.effect.config.moji_ban_sets) do
                    for cardid, card in ipairs(G.P_CENTERS) do
                        if card.set == v.set then
                            G.GAME.banned_keys[cardid] = true
                        end
                    end
                end
                return true
            end
        }))
    end

    if arg_56_0.effect.config.moji_ban_keys then
        G.E_MANAGER:add_event(Event({
            func = function()
                for k, v in ipairs(arg_56_0.effect.config.moji_ban_keys) do
                    G.GAME.banned_keys[v.id] = true
                end
                return true
            end
        }))
    end

    if arg_56_0.effect.config.moji_ban_boosters then
        G.E_MANAGER:add_event(Event({
            func = function()
                for k, v in ipairs(arg_56_0.effect.config.moji_ban_boosters) do
                    for cardid, card in ipairs(G.P_CENTERS) do
                        if card.set == "Booster" and card.kind == v.kind then
                            G.GAME.banned_keys[cardid] = true
                        end
                    end
                end
                return true
            end
        }))
    end
end

local loc_en = {
    ["name"]="Joker Only Deck",
    ["text"]={
        [1]="All {C:tarot}Consumables{} and {C:attention}Vouchers{}",
        [2]="are banned, together with related",
        [3]="Jokers, Tags and Booster Packs"
    }
}

local loc_zh = {
    ["name"]="仅小丑牌组",
    ["text"]={
        [1]="所有{C:tarot}消耗牌{}和{C:attention}优惠券{}",
        [2]="以及相关的小丑牌、标签和补充包",
        [3]="都被禁用"
    }
}

local loc_txt = loc_en
if G.SETTINGS.language == "zh_CN" then
    loc_txt = loc_zh
end

local jokeronly = SMODS.Deck:new(
    "Joker Only Deck",
    "b_jokeronly",
    {
        moji_ban_sets = {
            {set = "Planet"},
            {set = "Tarot"},
            {set = "Spectral"},
            {set = "Voucher"}
        },
        moji_ban_keys = {
            -- Planet Card
            {id = 'j_8_ball'},
            {id = 'j_constellation'},
            {id = 'j_satellite'},
            {id = 'j_astronomer'},
            -- Tarot Card
            {id = 'j_superposition'},
            {id = 'j_vagabond'},
            {id = 'j_hallucination'},
            {id = 'j_fortune_teller'},
            {id = 'j_cartomancer'},
            -- Spectral Card
            {id = 'j_sixth_sense'},
            {id = 'j_seance'},
            -- Tags
            {id = 'tag_voucher'},
            {id = 'tag_charm'},
            {id = 'tag_meteor'},
            {id = 'tag_ethereal'},
            {id = 'tag_orbital'}
        },
        moji_ban_boosters = {
            {kind = "Celestial"},
            {kind = "Arcana"},
            {kind = "Spectral"}
        }
    },
    {x = 5, y = 2},
    loc_txt
)
jokeronly:register()

----------------------------------------------
------------MOD CODE END----------------------