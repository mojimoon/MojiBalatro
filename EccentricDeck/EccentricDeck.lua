--- STEAMODDED HEADER
--- MOD_NAME: Eccentric Deck
--- MOD_ID: EccentricDeck
--- MOD_AUTHOR: [Mojimoon]
--- MOD_DESCRIPTION: Adds a deck that yields more eccentric results than the vanilla Erratic Deck.

----------------------------------------------
------------MOD CODE -------------------------

function weighted_random_select(table)
    if #table == 0 then
        return 0
    end
    local total_weight = 0
    for i = 1, #table do
        total_weight = total_weight + table[i].weight
    end
    local random_weight = math.random(1, total_weight)
    local current_weight = 0
    for i = 1, #table do
        current_weight = current_weight + table[i].weight
        if random_weight <= current_weight then
            return i
        end
    end
end

local Backapply_to_runRef = Back.apply_to_run
function Back.apply_to_run(arg_56_0)
	Backapply_to_runRef(arg_56_0)

    if arg_56_0.effect.config.eccentric then
        G.E_MANAGER:add_event(Event({
            func = function()
                local m_list = {
                    {value = G.P_CENTERS.m_stone, weight = 1},
                    {value = G.P_CENTERS.m_steel, weight = 1},
                    {value = G.P_CENTERS.m_glass, weight = 1},
                    {value = G.P_CENTERS.m_gold, weight = 1},
                    {value = G.P_CENTERS.m_bonus, weight = 1},
                    {value = G.P_CENTERS.m_mult, weight = 1},
                    {value = G.P_CENTERS.m_wild, weight = 1},
                    {value = G.P_CENTERS.m_lucky, weight = 1},
                    {value = "NOTHING", weight = 22}
                }
                local e_list = {
                    {value = {foil = true}, weight = 2},
                    {value = {holo = true}, weight = 1},
                    {value = {polychrome = true}, weight = 1},
                    {value = "NOTHING", weight = 26}
                }
                local r_list = {
                    {value = "A", weight = 4},
                    {value = "K", weight = 4},
                    {value = "Q", weight = 4},
                    {value = "J", weight = 4},
                    {value = "T", weight = 4},
                    {value = "9", weight = 4},
                    {value = "8", weight = 4},
                    {value = "7", weight = 4},
                    {value = "6", weight = 4},
                    {value = "5", weight = 4},
                    {value = "4", weight = 4},
                    {value = "3", weight = 4},
                    {value = "2", weight = 4}
                }
                local s_list = {
                    {value = "C", weight = 13},
                    {value = "D", weight = 13},
                    {value = "H", weight = 13},
                    {value = "S", weight = 13}
                }
                local g_list = {
                    {value = "Red", weight = 1},
                    {value = "Blue", weight = 1},
                    {value = "Gold", weight = 1},
                    {value = "Purple", weight = 1},
                    {value = "NOTHING", weight = 26}
                }

                for iter_57_0 = #G.playing_cards, 1, -1 do
                    local random_m = m_list[weighted_random_select(m_list)]
                    local random_e = e_list[weighted_random_select(e_list)]
                    local random_r = r_list[weighted_random_select(r_list)]
                    local random_s = s_list[weighted_random_select(s_list)]
                    local random_g = g_list[weighted_random_select(g_list)]
                    random_m.weight = random_m.weight + 1
                    random_e.weight = random_e.weight + 1
                    random_r.weight = random_r.weight + 2
                    random_s.weight = random_s.weight + 2
                    random_g.weight = random_g.weight + 1

                    G.playing_cards[iter_57_0]:set_base(G.P_CARDS[random_s.value .. "_" .. random_r.value])
                    if random_m.value ~= "NOTHING" then
                        G.playing_cards[iter_57_0]:set_ability(random_m.value)
                    end
                    if random_e.value ~= "NOTHING" then
                        G.playing_cards[iter_57_0]:set_edition(random_e.value, true, true)
                    end
                    if random_g.value ~= "NOTHING" then
                        G.playing_cards[iter_57_0]:set_seal(random_g.value, true, true)
                    end
                end
                return true
            end
        }))
    end
end

local loc_en = {
    ["name"]="Eccentric Deck",
    ["text"]={
        [1]="All {C:attention}Ranks{} and {C:attention}Suits{} in deck",
        [2]="with {C:tarot}Enhancements{}, {C:planet}Editions{},",
        [3]="and {C:spectral}Seals{} of some cards",
        [4]="are random, but biased",
        [5]="towards the same kind"
    }
}

local loc_zh = {
    ["name"]="怪奇牌组",
    ["text"]={
        [1]="牌组中所有牌的{C:attention}点数{}、{C:attention}花色",
        [2]="和部分牌的{C:tarot}增强{}、{C:planet}版本{}",
        [3]="和{C:spectral}蜡封{}都是随机的",
        [4]="但偏向于同一种"
    }
}

local loc_txt = loc_en
if G.SETTINGS.language == "zh_CN" then
    loc_txt = loc_zh
end

local eccentric = SMODS.Deck:new(
    "Eccentric Deck",
    "b_eccentric",
    {eccentric = true},
    {x = 2, y = 3},
    loc_txt
)
eccentric:register()

----------------------------------------------
------------MOD CODE END----------------------
