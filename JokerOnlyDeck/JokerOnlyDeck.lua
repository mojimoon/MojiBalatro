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
                for _, _set in ipairs(arg_56_0.effect.config.moji_ban_sets) do
                    for k, v in ipairs(G.P_CENTER_POOLS[_set.set]) do
                        G.GAME.banned_keys[v.key] = true
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
                for k, v in ipairs(G.P_CENTER_POOLS['Booster']) do
                    for _, _type in ipairs(arg_56_0.effect.config.moji_ban_boosters) do
                        if _type.kind == v.kind then
                            G.GAME.banned_keys[v.key] = true
                        end
                    end
                end
                return true
            end
        }))
    end

    if arg_56_0.effect.config.moji_joker_only then
        G.GAME.starting_params.moji_joker_only = arg_56_0.effect.config.moji_joker_only
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.tarot_rate = 0
                G.GAME.planet_rate = 0
                return true
            end
        }))
    end
end

local Gameupdate_shopRef = Game.update_shop
function Game:update_shop(dt)
    if G.GAME.starting_params.moji_joker_only then
        G.load_shop_vouchers = nil
        G.GAME.current_round.voucher = nil
    end

    Gameupdate_shopRef(self, dt)
end

local loc_en = {
    ["name"]="Joker Only Deck",
    ["text"]={
        [1]="All {C:tarot}Consumables{} and {C:attention}Vouchers{}",
        [2]="are banned, together with",
        [3]="related Jokers, Tags",
        [4]="and Booster Packs"
    }
}

local loc_zh = {
    ["name"]="仅小丑牌组",
    ["text"]={
        [1]="所有{C:tarot}消耗牌{}和{C:attention}优惠券{}",
        [2]="及相关的小丑牌、标签",
        [3]="和补充包都被禁用"
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
        },
        moji_joker_only = true,
        consumable_slot = -2
    },
    {x = 5, y = 2},
    loc_txt
)
jokeronly:register()

----------------------------------------------
------------MOD CODE END----------------------
