SMODS.Edition ({
    key = "phantom",
    loc_txt = {
        name = "Phantom",
        label = "Phantom",
        text = {
            "{C:dark_edition}+1{} Joker Slot",
            "No sell value",
            "{C:attention}Destroyed{} at end of round"
        }
    },
    shader = false,
    discovered = true,
    unlocked = true,
    in_shop = false,
    on_apply = function(card)
        if card.ability.consumeable then
            if G.consumeables then
                G.consumeables.config.card_limit = G.consumeables.config.card_limit + 1
            end
        else
            if G.jokers then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end
        if card.eternal then
            card:set_eternal(false)
        end
    end,
})
