# MojiBalatro

A collection of my mods for the awesome poker roguelike [Balatro](https://www.playbalatro.com/).

## Before you start

- **[Steamodded](https://github.com/Steamopollys/Steamodded) is required**. Please follow the instructions there to install Steamodded and these mods.
- English and Simplified Chinese are supported. Switching between the two languages requires a game restart.
- In-game descriptions are modified for brevity so that they fit the UI. Here you can find detailed descriptions in both languages.

## Installation

1. Install Steamodded.
2. Download the mods as a zip file.
3. Extract the zip file to the `%appdata%\Balatro\Mods` folder. (Create `Mods` folder if it doesn't exist)
4. Restart the game.

## Decks

### [Eccentric Deck](EccentricDeck/EccentricDeck.lua)

All **Ranks** and **Suits** in the deck are random but biased towards the same kind.

**Enhancements**, **Editions** and **Seals** are also biasedly added to some cards.

> **怪奇牌组**  
> 牌组中的所有牌的**点数**和**花色**都是随机的，部分牌也会随机获得**增强**、**版本**和**蜡封**，但都偏向于同一种。

### [Joker Only Deck](JokerOnlyDeck/JokerOnlyDeck.lua)

All **Consumables** and **Vouchers** are banned, together with related Jokers, Tags and Booster Packs.

| Type | Ban List |
| ---- | -------- |
| Tarot Cards | ALL |
| Planet Cards | ALL |
| Spectral Cards | ALL |
| Vouchers | ALL |
| Jokers | Superposition, Vagabond, Hallucination, Fortune Teller, Cartomancer <br>8 Ball, Constellation, Satellite, Astronomer <br>Sixth Sense, Séance |
| Tags | Voucher, Charm, Meteor, Ethereal, Orbital |
| Booster Packs | Arcana, Celestial, Spectral |

Additionally, the consumable slot is set to 0.

> **仅小丑牌组**  
> 所有**消耗牌**和**优惠券**，及相关的小丑牌、标签和补充包都被禁用

| 类型 | 禁用列表 |
| ---- | -------- |
| 塔罗牌 | 全部 |
| 星球牌 | 全部 |
| 幻灵牌 | 全部 |
| 优惠券 | 全部 |
| 小丑牌 | 叠加态、流浪者、幻觉、占卜师、卡牌术士 <br>八号球、星座、卫星、天文学家 <br>第六感、通灵 |
| 标签 | 优惠券、吊饰、流星、空灵、轨道 |
| 补充包 | 秘术、天体、幻灵 |

此外，消耗牌槽位为 0。

## Mechanics

### [Negative Poker](NegativePoker/NegativePoker.lua)

Allow playing cards to have **Negative** edition, giving **+1 hand size when held in hand**.

Also adds a new deck, **Negative Deck**. 

Each starting card has an **1 in 6** chance to be negative, but also **-1** discard every round.

> **负片扑克**  
> 让游戏牌也能获得**负片**版本，效果为：**在手中时，手牌上限+1**。  
> **负片牌组**  
> 开局时牌组中的每张牌有**1/6**的概率是负片，但每回合 **-1**次弃牌。

#### Important

This mod is currently in beta. Bugs and balance issues are expected. 

Please report them in the [Issues](https://github.com/mojimoon/MojiBalatro/issues) or make a [Pull Request](https://github.com/mojimoon/MojiBalatro/pulls). 

Thanks for playing!

#### Known issues

- Negative shader will not correctly apply until you draw a Negative card to your hand, after each game start.

#### Future plans

- Negative playing cards badge：+1 hand size when in hand
- Adding Negative cards to Standard Booster Pack
- Adding Spectral cards to create Negative cards
- Adding negative Shader to the Negative Deck (Instead of adding `Enhancers.jpg`)
- Pull request to Steamodded to:
    - Add API for adding custom editions, enhancements and seals
    - Add API for in-round hand size change
