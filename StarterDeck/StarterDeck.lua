--- STEAMODDED HEADER
--- MOD_NAME: Starter Deck
--- MOD_ID: StarterDeck
--- MOD_AUTHOR: [Mojimoon]
--- MOD_DESCRIPTION: Adds a deck that grants a free Mega Buffon Pack at start, but Eternal jokers can appear in buffon packs.

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

local loc_en = {
    ["name"]="Starter Deck",
    ["text"]={
        [1]="Start with a free",
        [2]="{C:attention,T:p_buffoon_mega_1}Mega Buffoon Pack{}",
        [3]="{C:attention}Eternal{} Jokers have a chance",
        [4]="to appear in Buffoon Packs"
    }
}

local loc_zh = {
    ["name"]="新手牌组",
    ["text"]={
        [1]="开局时获得一个",
        [2]="免费的{C:attention,T:p_buffoon_mega_1}超级小丑包{}",
        [3]="小丑包中可能出现",
        [4]="{C:attention}永恒{}小丑"
    }
}

local loc_txt = loc_en
if G.SETTINGS.language == "zh_CN" then
    loc_txt = loc_zh
end

local starter_deck = SMODS.Deck:new(
    "Starter Deck",
    "b_starter_deck",
    {moji_start_tags = {tag = "tag_buffoon"}, buffoon_pack_eternal = 0.3},
    {x = 5, y = 2},
    loc_txt
)
starter_deck:register()

----------------------------------------------
------------MOD CODE END----------------------
