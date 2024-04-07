# MojiBalatro

**English** | [简体中文](README.zh-cn.md)

[Balatro](https://www.playbalatro.com/) is a poker-themed rougelike deckbuilder. This repository is a collection of Balatro mods by [Mojimoon](https://github.com/Mojimoon).

## Before you start

- **[Steamodded](https://github.com/Steamopollys/Steamodded) is required**. Please follow the instructions in its README to install the mod loader and these mods.
- English and Simplified Chinese are supported. Switching between the two languages or save slots requires restarting the game.

## Installation

1. Install Steamodded.
2. Click the green `Code` button at the top right of this page, and select `Download ZIP` to download the repository.
3. Extract the zip file to the `%appdata%\Balatro\Mods` folder. (Create `Mods` folder if it doesn't exist; `%appdata%` is `C:\Users\<Your Username>\AppData\Roaming`).
4. Every time you change the enabled mods, you need to restart the game.

## Jokers

### [MojiJoker](https://github.com/Mojimoon/MojiJoker)

MojiJoker is now a standalone mod. It adds 30+ new Jokers to the game and is under active development.

- Preview: [https://mojimoon.github.io/MojiJoker/](https://mojimoon.github.io/MojiJoker/)
- Download: [https://github.com/Mojimoon/MojiJoker/releases](https://github.com/Mojimoon/MojiJoker/releases)

## Decks

### [Eccentric Deck](EccentricDeck/EccentricDeck.lua)

All **Ranks** and **Suits** in the deck are random but biased towards the same kind.

**Enhancements**, **Editions** and **Seals** are also biasedly added to some cards.

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

### [Starter Deck](StarterDeck/StarterDeck.lua)

Start with a free **Mega Buffoon Pack**. Jokers in Buffoon Pack have a **30%** chance to be **Eternal**.

## Utilities

### [Negative Poker](NegativePoker/NegativePoker.lua)

Allow playing cards to have **Negative** edition, giving **+1 hand size when held in hand**.

Also adds a new deck, **Negative Deck**. 

Each starting card has an **1 in 6** chance to be negative, but also **-1** discard every round.
