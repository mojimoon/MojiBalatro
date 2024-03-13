--- STEAMODDED HEADER
--- MOD_NAME: Negative Poker (Beta)
--- MOD_ID: NegativePoker
--- MOD_AUTHOR: [Mojimoon]
--- MOD_DESCRIPTION: Allow playing cards to have Negative edition, giving +1 hand size when held in hand. Adds a new deck, Negative Deck, which has a 1/6 chance to draw a negative card, but -1 discard

----------------------------------------------
------------MOD CODE -------------------------

--- Before you start
--- This mod is currently in beta
--- Bug reports: Github @Mojimoon
--- 注意
--- 本 Mod 目前处于测试阶段
--- 报告问题：Github @Mojimoon

--- Known issues
--- Negative shader will not correctly apply before you first draw a Negative card
--- 在你第一次抽到负片牌之前，负片 shader 不会正确应用

--- Implemented features
--- Negative playing cards
--- Negative Deck
--- 已实现功能
--- 负片游戏牌
--- 负片牌组

--- Future development
--- Negative playing cards badge：+1 hand size when in hand
--- Adding Negative cards to Standard Booster Pack
--- Adding Spectral cards to create Negative cards
--- Adding negative Shader to the Negative Deck
--- 负片游戏牌的提示文本：在手中时手牌上限 +1
--- 使负片牌可以在标准补充包中出现
--- 加入可以生成负片牌的幻灵牌
--- 给负片牌组添加负片 shader

local Card_set_edition_ref = Card.set_edition
function Card:set_edition(edition, immediate, silent)
    self.edition = nil
    if not edition then return end
    if (self.ability.set == 'Joker' or self.ability.set == 'Edition' or self.ability.consumeable or self.ability.set == 'Voucher' or self.ability.set == 'Booster') then
        Card_set_edition_ref(self, edition, immediate, silent)
    elseif not edition.negative then
        Card_set_edition_ref(self, edition, immediate, silent)
    else
        self.edition = {}
        self.edition.negative = true
        self.edition.type = 'negative'

        if self.edition and not silent then
            G.CONTROLLER.locks.edition = true
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = not immediate and 0.2 or 0,
                blockable = not immediate,
                func = function()
                    self:juice_up(1, 0.5)
                    play_sound('negative', 1.5, 0.4)
                    return true
                end
                }))
                G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    G.CONTROLLER.locks.edition = false
                    return true
                end
                }))
            end
        self:set_cost()
    end
end

local draw_card_ref = draw_card
function draw_card(from, to, percent, dir, sort, card, delay, mute, stay_flipped, vol, discarded_only)
    -- Play and discard
    if card and from == G.hand and (to == G.play or to == G.discard) then
        if card.edition and card.edition.negative then
            if not G.GAME.round_resets.temp_handsize then
                G.GAME.round_resets.temp_handsize = 0
            end
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.hand.config.real_card_limit = (G.hand.config.real_card_limit or G.hand.config.card_limit) - 1
                    G.hand.config.card_limit = math.max(0, G.hand.config.real_card_limit)
                    return true
                end
            }))
            G.GAME.round_resets.temp_handsize = G.GAME.round_resets.temp_handsize - 1
        end
    end

    draw_card_ref(from, to, percent, dir, sort, card, delay, mute, stay_flipped, vol, discarded_only)
end

function CardArea:draw_card_from(area, stay_flipped, discarded_only)
    if area:is(CardArea) then
        if #self.cards < self.config.card_limit or self == G.deck or self == G.hand then
            local card = area:remove_card(nil, discarded_only)
            if card then
                if area == G.discard then
                    card.T.r = 0
                end
                if self == G.hand and card.edition and card.edition.negative then
                    if not G.GAME.round_resets.temp_handsize then
                        G.GAME.round_resets.temp_handsize = 0
                    end
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.hand.config.real_card_limit = (G.hand.config.real_card_limit or G.hand.config.card_limit) + 1
                            G.hand.config.card_limit = math.max(0, G.hand.config.real_card_limit)
                            return true
                        end
                    }))
                    G.GAME.round_resets.temp_handsize = G.GAME.round_resets.temp_handsize + 1
                    G.E_MANAGER:add_event(Event({trigger = 'immediate', delay = 0.05, func = function()
                        self:draw_card_from(area, stay_flipped, discarded_only)
                        return true
                    end }))
                end
                local stay_flipped = G.GAME and G.GAME.blind and G.GAME.blind:stay_flipped(self, card)
                if (self == G.hand) and G.GAME.modifiers.flipped_cards then
                    if pseudorandom(pseudoseed('flipped_card')) < 1/G.GAME.modifiers.flipped_cards then
                        stay_flipped = true
                    end
                end
                self:emplace(card, nil, stay_flipped)
                return true
            end
        end
    end
end

local Backapply_to_runRef = Back.apply_to_run
function Back.apply_to_run(arg_56_0)
	Backapply_to_runRef(arg_56_0)

    if arg_56_0.effect.config.negative_poker then
        G.E_MANAGER:add_event(Event({
            func = function()
            for iter_57_0 = #G.playing_cards, 1, -1 do
                if pseudorandom('negative') < arg_56_0.effect.config.negative_poker then
                    G.playing_cards[iter_57_0]:set_edition({negative = true}, true, true)
                end
            end
            return true
        end }))
    end
end

local loc_en = {
    ["name"]="Negative Deck",
    ["text"]={
        [1]="Start run with a deck in which",
        [2]="each card has an {C:green}1 in 6{}",
        [3]="chance to be {C:dark_edition}Negative{}",
        [4]="{C:blue}-1{} discard every round"
    }
}

local loc_zh = {
    ["name"]="负片牌组",
    ["text"]={
        [1]="开局时牌组中的每张牌有",
        [2]="{C:green}1/6{}的几率是{C:dark_edition}负片{}",
        [3]="每回合{C:blue}-1{}次弃牌"
    }
}


local loc_txt = loc_en
if G.SETTINGS.language == "zh_CN" then
    loc_txt = loc_zh
end

local negative_deck = SMODS.Deck:new(
    "Negative Deck",
    "b_negative",
    {negative_poker = 1.0/6.0, discards = -1},
    {x = 3, y = 2},
    loc_txt
)

negative_deck:register()

----------------------------------------------
------------MOD CODE END----------------------
