--- STEAMODDED HEADER
--- MOD_NAME: Moji's Jokers
--- MOD_ID: MojiJoker
--- MOD_AUTHOR: [Mojimoon]
--- MOD_DESCRIPTION: A collection of custom Jokers by Mojimoon.

----------------------------------------------
------------MOD CODE -------------------------

local MOD_ID = "MojiJoker"

local loc_en = {
    j_color_out_of_space = {
        name = "Color Out of Space",
        text = {
            "Gain {X:mult,C:white}X#1#{} multiplier per each",
            "consecutive hand containing {C:attention}#3#{}",
            "Otherwise reset",
            "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)"
        }
    },
    j_garbage_time = {
        name = "Garbage Time",
        text = {
            "{X:mult,C:white}X#2#{} Mult,",
            "loses {X:mult,C:white}X#1#{} Mult",
            "if more than {C:attention}1{} hands are played",
            "by the end of the round"
        }
    },
    j_new_order = {
        name = "The New Order",
        text = {
            "{X:mult,C:white}X#1#{} Mult when {C:attention}#4#{}",
            "is played and scored",
            "Rank decreases by {C:attention}1{} after each trigger",
            "{C:inactive}(A, K, Q, …, 2, A)",
            "Loses {X:mult,C:white}X#2#{} Mult",
            "if a hand fails to trigger the New Order",
            "{C:inactive}(Currently {X:mult,C:white} X#3# {C:inactive} Mult)"
        }
    }
}

local loc_zh = {
    j_color_out_of_space = {
        name = "星之彩",
        text = {
            "连续打出包含{C:attention}#3#{}的手牌时，",
            "获得{X:mult,C:white}X#1#{}倍率",
            "否则重置倍率",
            "{C:inactive}（当前为{X:mult,C:white} X#2# {C:inactive}倍率）"
        }
    },
    j_garbage_time = {
        name = "垃圾时间",
        text = {
            "{X:mult,C:white}X#2#{}倍率",
            "若回合结束时，所用",
            "出牌次数超过{C:attention}1{}，",
            "失去{X:mult,C:white}X#1#{}倍率"
        }
    },
    j_new_order = {
        name = "新秩序",
        text = {
            "打出{C:attention}#4#{}并计分时，",
            "获得{X:mult,C:white}X#1#{}倍率",
            "每次触发后目标点数{C:attention}-1{}",
            "{C:inactive}（A、K、Q、……、2、A）",
            "若一手牌未触发新秩序，",
            "失去{X:mult,C:white}X#2#{}倍率",
            "{C:inactive}（当前为{X:mult,C:white} X#3# {C:inactive}倍率）"
        }
    }
}

local misc_loc_en = {
    k_timeup = "Time's up!"
}

local misc_loc_zh = {
    k_timeup = "时间到！"
}

local loc_txt = G.SETTINGS.language == "zh_CN" and loc_zh or loc_en
local misc_loc_txt = G.SETTINGS.language == "zh_CN" and misc_loc_zh or misc_loc_en

local jokers = {
    j_color_out_of_space = {
        ability_name = "Color Out of Space",
        slug = "color_out_of_space",
        ability = {extra = {Xmult_add = 0.5, type = 'Flush'}},
        rarity = 2,
        cost = 8,
        unlocked = true, discovered = true, blueprint_compat = true, eternal_compat = true
    },
    j_garbage_time = {
        ability_name = "Garbage Time",
        slug = "garbage_time",
        ability = {Xmult = 3, extra = {Xmult_sub = 0.4}},
        rarity = 2,
        cost = 8,
        unlocked = true, discovered = true, blueprint_compat = true, eternal_compat = true
    },
    j_new_order = {
        ability_name = "The New Order",
        slug = "new_order",
        ability = {extra = {Xmult_add = 0.1, Xmult_sub = 0.1, rank = 14, hand_trigger = 0}},
        rarity = 2,
        cost = 8,
        unlocked = true, discovered = true, blueprint_compat = true, eternal_compat = true
    }
}

local rank_to_str = {
    [2] = "2",
    [3] = "3",
    [4] = "4",
    [5] = "5",
    [6] = "6",
    [7] = "7",
    [8] = "8",
    [9] = "9",
    [10] = "10",
    [11] = "J",
    [12] = "Q",
    [13] = "K",
    [14] = "A"
}

function rank_dec(rank)
    return rank == 2 and 14 or rank - 1
end

function SMODS.INIT.MojiJoker()
    for k, v in pairs(misc_loc_txt) do
        G.localization.misc.dictionary[k] = v
    end

    init_localization()

    for k, v in pairs(jokers) do
        local joker = SMODS.Joker:new(
            v.ability_name,
            v.slug,
            v.ability,
            {x = 0, y = 0},
            loc_txt[k],
            v.rarity,
            v.cost,
            v.unlocked, v.discovered, v.blueprint_compat, v.eternal_compat
        )
        joker:register()
        local sprite = SMODS.Sprite:new(
            "j_" .. v.slug,
            SMODS.findModByID(MOD_ID).path,
            "j_" .. v.slug .. ".png",
            71, 95, "asset_atli"
        )
        sprite:register()
    end

    -- Color Out of Space
    SMODS.Jokers.j_color_out_of_space.calculate = function(self, context)
        if context.before and not context.blueprint then
            if next(context.poker_hands[self.ability.extra.type]) then
                self.ability.x_mult = self.ability.x_mult + self.ability.extra.Xmult_add
                return {
                    extra = {focus = self, message = localize('k_upgrade_ex'), colour = G.C.MULT},
                    card = self
                }
            else
                self.ability.x_mult = 1
                return {
                    card = self,
                    message = localize('k_reset')
                }
            end
        end
    end

    -- Garbage Time
    SMODS.Jokers.j_garbage_time.calculate = function(self, context)
        if context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            if G.GAME.current_round.hands_played > 1 then
                local newMult = self.ability.x_mult - self.ability.extra.Xmult_sub
                if newMult <= 1 then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            play_sound('tarot1')
                            self.T.r = -0.2
                            self:juice_up(0.3, 0.4)
                            self.states.drag.is = true
                            self.children.center.pinch.x = true
                            G.E_MANAGER:add_event(Event({hand_trigger = 'after', delay = 0.3, blockable = false,
                                func = function()
                                        G.jokers:remove_card(self)
                                        self:remove()
                                        self = nil
                                    return true; end})) 
                            return true
                        end
                    }))
                    return {
                        message = localize('k_timeup'),
                        colour = G.C.FILTER
                    }
                else
                    self.ability.x_mult = newMult
                    return {
                        message = localize{type='variable',key='a_xmult_minus',vars={self.ability.extra.Xmult_sub}},
                        colour = G.C.RED
                    }
                end
            end
        end
    end

    -- The New Order
    SMODS.Jokers.j_new_order.calculate = function(self, context)
        if context.individual and not context.blueprint then
            if context.cardarea == G.play then
                if context.other_card:get_id() == self.ability.extra.rank then
                    self.ability.x_mult = self.ability.x_mult + self.ability.extra.Xmult_add
                    self.ability.extra.rank = rank_dec(self.ability.extra.rank)
                    self.ability.extra.hand_trigger = self.ability.extra.hand_trigger + 1
                    return {
                        extra = {focus = self, message = localize('k_upgrade_ex'), colour = G.C.MULT},
                        card = self
                    }
                end
            end
        end
        if context.after and not context.blueprint then
            if self.ability.extra.hand_trigger == 0 then
                self.ability.x_mult = self.ability.x_mult - self.ability.extra.Xmult_sub
                if self.ability.x_mult < 1 then
                    self.ability.x_mult = 1
                end
                return {
                    message = localize{type='variable',key='a_xmult_minus',vars={self.ability.extra.Xmult_sub}},
                    colour = G.C.RED
                }
            end
            self.ability.extra.hand_trigger = 0
        end
    end
end

-- Copied and modifed from LushMod
local generate_UIBox_ability_tableref = Card.generate_UIBox_ability_table
function Card.generate_UIBox_ability_table(self)
    local card_type, hide_desc = self.ability.set or "None", nil
    local loc_vars = nil
    local main_start, main_end = nil, nil
    local no_badge = nil

    if self.config.center.unlocked == false and not self.bypass_lock then
    elseif card_type == 'Undiscovered' and not self.bypass_discovery_ui then
    elseif self.debuff then
    elseif card_type == 'Default' or card_type == 'Enhanced' then
    elseif self.ability.set == 'Joker' then
        local customJoker = true
        if self.ability.name == 'Color Out of Space' then
            loc_vars = {
                self.ability.extra.Xmult_add,
                self.ability.x_mult,
                localize(self.ability.extra.type, 'poker_hands')
            }
        elseif self.ability.name == 'Garbage Time' then
            loc_vars = {
                self.ability.extra.Xmult_sub,
                self.ability.x_mult
            }
        elseif self.ability.name == 'The New Order' then
            loc_vars = {
                self.ability.extra.Xmult_add,
                self.ability.extra.Xmult_sub,
                self.ability.x_mult,
                rank_to_str[self.ability.extra.rank]
            }
        else
            customJoker = false
        end

        if customJoker then
            local badges = {}
            if (card_type ~= 'Locked' and card_type ~= 'Undiscovered' and card_type ~= 'Default') or self.debuff then
                badges.card_type = card_type
            end
            if self.ability.set == 'Joker' and self.bypass_discovery_ui and (not no_badge) then
                badges.force_rarity = true
            end
            if self.edition then
                if self.edition.type == 'negative' and self.ability.consumeable then
                    badges[#badges + 1] = 'negative_consumable'
                else
                    badges[#badges + 1] = (self.edition.type == 'holo' and 'holographic' or self.edition.type)
                end
            end
            if self.seal then
                badges[#badges + 1] = string.lower(self.seal) .. '_seal'
            end
            if self.ability.eternal then
                badges[#badges + 1] = 'eternal'
            end
            if self.pinned then
                badges[#badges + 1] = 'pinned_left'
            end

            if self.sticker then
                loc_vars = loc_vars or {};
                loc_vars.sticker = self.sticker
            end

            return generate_card_ui(self.config.center, nil, loc_vars, card_type, badges, hide_desc, main_start,
                main_end)
        end
    end
    return generate_UIBox_ability_tableref(self)
end

----------------------------------------------
------------MOD CODE END----------------------
