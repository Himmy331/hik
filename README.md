# The Changer - YGOPro Custom Card

## Card Details
- **Name**: The Changer
- **ID**: 100000001
- **Type**: Link Monster / Effect Monster
- **Link Rating**: 4
- **ATK**: 2800
- **Attribute**: DARK
- **Race**: Cyberse
- **Link Material**: 2+ Link monsters

## Effects

### Effect 1: Attribute Change (When Link Summoned)
- **Trigger**: When this card is Link Summoned
- **Target**: Up to 5 cards on the field and/or in either Graveyard
- **Effect**: Change their Attributes to Attributes of your choice
- **Usage**: Once per turn

### Effect 2: Monster Control Switch (Ignition Effect)
- **Activation Condition**: If you and your opponent each control a monster (except this card)
- **Effect**: Switch control of 1 monster you control and 1 monster your opponent controls
- **Usage**: Once per turn

## Files Structure
```
/script/c100000001.lua  - Card script with effect implementations
/cards.cdb              - SQLite database with card data and text
```

## Technical Implementation
- Uses modern YGOPro scripting conventions
- Proper Link Summoning procedures
- Target validation and effect resolution
- Count limits to prevent abuse
- Error handling for edge cases

## Usage
1. Place `c100000001.lua` in your YGOPro `script` folder
2. Place `cards.cdb` in your YGOPro database folder or merge with existing database
3. The card will be available for use in custom games