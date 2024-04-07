# MojiBalatro

[English](README.md) | **简体中文**

[Balatro](https://www.playbalatro.com/) 是一款以扑克为主题的 rougelike 卡牌构筑游戏。本项目是由 [Mojimoon](https://github.com/Mojimoon) 制作的 Balatro 模组合集。

## 请先阅读

- **需要 [Steamodded](https://github.com/Steamopollys/Steamodded)**。请按照 Steamodded 的 README 中的说明安装模组加载器和这些模组。
- 支持英文和简体中文。在两种语言或存档之间切换需要重启游戏才能生效。

## 安装

1. 安装 Steamodded。
2. 点击本页面右上角的绿色按钮 `Code`，选择 `Download ZIP` 下载本项目的压缩包。
3. 将压缩包解压到 `%appdata%\Balatro\Mods` 文件夹中（如果不存在则创建 `Mods` 文件夹；`%appdata%` 是 `C:\Users\<Your Username>\AppData\Roaming`）。
4. 每次修改启用的模组后都需要重启游戏。

## 小丑牌

### [MojiJoker](https://github.com/Mojimoon/MojiJoker)

MojiJoker 现已成为一个独立的模组，包含 30+ 张新增小丑牌。

- 预览：[https://mojimoon.github.io/MojiJoker/](https://mojimoon.github.io/MojiJoker/)
- 下载：[https://github.com/Mojimoon/MojiJoker/releases](https://github.com/Mojimoon/MojiJoker/releases)

## 牌组

### [怪奇牌组](EccentricDeck/EccentricDeck.lua)

牌组中的所有牌的**点数**和**花色**都是随机的，部分牌也会随机获得**增强**、**版本**和**蜡封**，但都偏向于同一种。

### [仅小丑牌组](JokerOnlyDeck/JokerOnlyDeck.lua)

所有**消耗牌**和**优惠券**都被禁用，同时相关的小丑牌、标签和补充包也被禁用。

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

### [新手牌组](StarterDeck/StarterDeck.lua)

开局时获得一个免费的**超级小丑包**。小丑包中有 **30%** 的几率出现**永恒**小丑牌。

## 工具

### [负片扑克](NegativePoker/NegativePoker.lua)

让游戏牌也能获得**负片**版本，效果为：**在手中时，手牌上限+1**。

**负片牌组**：开局时牌组中的每张牌有**1/6**的概率是负片，但每回合 **-1**次弃牌。