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
            "Otherwise, reset multiplier",
            "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)"
        }
    },
    j_garbage_time = {
        name = "Garbage Time",
        text = {
            "{X:mult,C:white}X#1#{} Mult on {C:attention}first hand{}",
            "of round, lose {X:mult,C:white}X#2#{} Mult",
            "if blind is not defeated in one hand",
            "{C:inactive}(Currently {X:mult,C:white} X#3# {C:inactive} Mult)"
        }
    },
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
            "每回合{C:attention}第一次{}出牌时{X:mult,C:white}X#1#{}倍率",
            "若未在一次出牌内击败盲注，",
            "失去{X:mult,C:white}X#2#{}倍率",
            "{C:inactive}（当前为{X:mult,C:white} X#3# {C:inactive}倍率）"
        }
    },
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
        ability = {extra = {Xmult = 1, Xmult_inc = 0.5, type = 'Flush'}},
        rarity = 2,
        cost = 8,
        unlocked = true, discovered = true, blueprint_compat = true, eternal_compat = true
    },
    j_garbage_time = {
        ability_name = "Garbage Time",
        slug = "garbage_time",
        ability = {extra = {Xmult_base = 4, Xmult_dec = 0.5, Xmult = 4}},
        rarity = 2,
        cost = 8,
        unlocked = true, discovered = true, blueprint_compat = true, eternal_compat = true
    }
}

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

    SMODS.Jokers.j_color_out_of_space.calculate = function(self, context)
        if context.before and not context.blueprint then
            if next(context.poker_hands[self.ability.extra.type]) then
                self.ability.extra.Xmult = self.ability.extra.Xmult + self.ability.extra.Xmult_inc
            else
                self.ability.extra.Xmult = 1
                return {
                    card = self,
                    message = localize('k_reset')
                }
            end
        end
        if SMODS.end_calculate_context(context) then
            if next(context.poker_hands['Flush']) and self.ability.extra.Xmult > 1 then
                return {
                    message = localize{type='variable',key='a_xmult',vars={self.ability.extra.Xmult}},
                    colour = G.C.RED,
                    Xmult_mod = self.ability.extra.Xmult
                }
            end
        end
    end

    SMODS.Jokers.j_garbage_time.calculate = function(self, context)
        if SMODS.end_calculate_context(context) then
            if G.GAME.current_round.hands_played == 0 then
                return {
                    message = localize{type='variable',key='a_xmult',vars={self.ability.extra.Xmult}},
                    colour = G.C.RED,
                    Xmult_mod = self.ability.extra.Xmult
                }
            end
        end
        -- if context.after and not context.blueprint then
        --     if G.GAME.current_round.hands_played == 0 and G.GAME.chips < G.GAME.blind.chips then
        if context.before and not context.blueprint then
            if G.GAME.current_round.hands_played == 1 then
                local newMult = self.ability.extra.Xmult - self.ability.extra.Xmult_dec
                if newMult <= 1 then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            play_sound('tarot1')
                            self.T.r = -0.2
                            self:juice_up(0.3, 0.4)
                            self.states.drag.is = true
                            self.children.center.pinch.x = true
                            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
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
                    self.ability.extra.Xmult = newMult
                    return {
                        message = localize{type='variable',key='a_xmult_minus',vars={self.ability.extra.Xmult_dec}},
                        colour = G.C.RED
                    }
                end
            end
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
                self.ability.extra.Xmult_inc,
                self.ability.extra.Xmult,
                localize(self.ability.extra.type, 'poker_hands')
            }
        elseif self.ability.name == 'Garbage Time' then
            loc_vars = {
                self.ability.extra.Xmult_base,
                self.ability.extra.Xmult_dec,
                self.ability.extra.Xmult
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
