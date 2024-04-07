--- STEAMODDED HEADER
--- MOD_NAME: MojiDeck
--- MOD_ID: MojiDeck
--- MOD_AUTHOR: [Mojimoon]
--- MOD_DESCRIPTION: A collection of custom decks by Mojimoon.

local mod_id = "MojiDeck"

local loc_en = {
    b_starter = {
        ["name"]="Starter Deck",
        ["text"]={
            [1]="Start with a free",
            [2]="{C:attention,T:p_buffoon_mega_1}Mega Buffoon Pack{}",
            [3]="{C:attention}Eternal{} Jokers have a chance",
            [4]="to appear in Buffoon Packs"
        }
    },
    b_black_painted = {
        ["name"]="Black Painted Deck",
        ["text"]={
            [1]="{C:attention}+2{} hand size",
            [2]="{C:red}-1{} hand every round"
        }
    },
    b_merchant = {
        ["name"]="Merchant Deck",
        ["text"]={
            [1]="Start run with the {C:attention}Overstock{}",
            [2]="and {C:attention}Clearance Sale{} vouchers"
        }
    },
    b_intangible = {
        ["name"]="Intangible Deck",
        ["text"]={
            [1]="After defeating each",
            [2]="{C:attention}Boss Blind{}, create a",
            [3]="random {C:dark_edition}negative{} Joker",
            [4]="{C:red}-2{} Joker slots",
        }
    }
}

local loc_zh = {
    b_starter = {
        ["name"]="新手牌组",
        ["text"]={
            [1]="开局时获得一个",
            [2]="免费的{C:attention,T:p_buffoon_mega_1}超级小丑包{}",
            [3]="小丑包中可能出现",
            [4]="{C:attention}永恒{}小丑"
        }
    },
    b_black_painted = {
        ["name"]="黑彩牌组",
        ["text"]={
            [1]="手牌上限{C:attention}+2{}",
            [2]="每回合出牌次数{C:red}-1{}"
        }
    },
    b_merchant = {
        ["name"]="商人牌组",
        ["text"]={
            [1]="开局时拥有{C:attention,T:v_overstock_norm}库存过剩{}",
            [2]="和{C:attention,T:v_clearance_sale}清仓特卖{}优惠券"
        }
    },
    b_intangible = {
        ["name"]="无形牌组",
        ["text"]={
            [1]="每次击败{C:attention}Boss盲注{}后，",
            [2]="生成一张随机的",
            [3]="{C:dark_edition}负片{}小丑牌",
            [4]="小丑牌槽位{C:red}-2{}"
        }
    }
}

local loc_txt = loc_en
if G.SETTINGS.language == "zh_CN" then
    loc_txt = loc_zh
end

local Back_trigger_effect_ref = Back.trigger_effect
function Back.trigger_effect(self, args)
    if self.name == "Intangible Deck" and args.context == "eval" and G.GAME.last_blind and G.GAME.last_blind.boss then
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            play_sound('timpani')
            local card = create_card('Joker', G.jokers, nil, nil, nil, nil, nil, 'intangible')
            card:set_edition({negative = true}, true)
            card:add_to_deck()
            G.jokers:emplace(card)
            return true end }))
    end

    return Back_trigger_effect_ref(self, args)
end

local Back_apply_to_run_ref = Back.apply_to_run
function Back.apply_to_run(arg_56_0)
    Back_apply_to_run_ref(arg_56_0)

    if arg_56_0.effect.config.moji_start_tags then
        G.E_MANAGER:add_event(Event({
            func = function()
                for _, _tag in pairs(arg_56_0.effect.config.moji_start_tags) do
                    add_tag(Tag(_tag))
                    play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                    play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                end
            return true
            end
        }))
    end

    if arg_56_0.effect.config.buffoon_pack_eternal then
        G.GAME.starting_params.buffoon_pack_eternal = arg_56_0.effect.config.buffoon_pack_eternal
    end
end

local CardArea_emplace_ref = CardArea.emplace
function CardArea:emplace(card, location, stay_flipped)
    CardArea_emplace_ref(self, card, location, stay_flipped)

    if self == G.pack_cards and G.GAME.starting_params.buffoon_pack_eternal then
        for i = 1, #self.cards do
            if self.cards[i].ability.set == 'Joker' and pseudorandom('buffoon_pack_eternal') < G.GAME.starting_params.buffoon_pack_eternal then
                self.cards[i]:set_eternal(true)
            end
        end
    end
end

local b_starter = SMODS.Deck:new(
    "Starter Deck",
    "b_starter",
    {moji_start_tags = {tag = "tag_buffoon"}, buffoon_pack_eternal = 0.5},
    {x = 5, y = 2},
    loc_txt.b_starter
)
b_starter:register()

local b_black_painted = SMODS.Deck:new(
    "Black Painted Deck",
    "b_black_painted",
    {hand_size = 2, hands = -1},
    {x = 1, y = 3},
    loc_txt.b_black_painted
)
b_black_painted:register()

local b_merchant = SMODS.Deck:new(
    "Merchant Deck",
    "b_merchant",
    {vouchers = {"v_overstock_norm", "v_clearance_sale"}},
    {x = 3, y = 3},
    loc_txt.b_merchant
)
b_merchant:register()

local b_intangible = SMODS.Deck:new(
    "Intangible Deck",
    "b_intangible",
    {joker_slot = -2},
    {x = 3, y = 0},
    loc_txt.b_intangible
)
b_intangible:register()

----------------------------------------------
------------MOD CODE END----------------------
