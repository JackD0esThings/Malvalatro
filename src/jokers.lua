SMODS.Atlas {
	key = "Malvalatro_Jokers",
	path = "Jokers.png",
	px = 71,
	py = 95
}


SMODS.Joker {
    key = 'woker',
    loc_txt = {
        name = 'Woker',
        text = {
            "This Joker gains {C:mult}+#2#{} Mult",
            "per {C:attention}consecutive{} hand",
            "played without containing",
            "a {C:attention}Straight{} or a {C:attention}Flush{}",
            "{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)"
        }
    },
    config = { extra = { mult = 0, mult_gain = 2 } },
    rarity = 1,
    atlas = 'Malvalatro_Jokers',
    pos = { x = 8, y = 2 },
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.mult_gain } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult_mod = card.ability.extra.mult,
                message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
            }
        end

        if context.before and not context.blueprint then
            if next(context.poker_hands['Straight']) or next(context.poker_hands['Flush']) then
                card.ability.extra.mult = 0
                return {
                    message = 'Reset',
                    colour = G.C.MULT,
                    card = card
                }
            end
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
            return {
                message = 'Upgrade',
                colour = G.C.MULT,
                card = card
            }
        end
    end
}


SMODS.Joker {
    key = 'cat',
    loc_txt = {
        name = "Black Cat",
        text = {
            "This Joker gains {C:chips}+#2#{} Chips",
            "when a {C:attention}#3#{} is discarded",
            "{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)"
        }
    },
    config = { extra = { chips = 0, chip_gain = 13, rank = 9 } },
    rarity = 1,
    atlas = 'Malvalatro_Jokers',
    pos = { x = 5, y = 14 },
    cost = 5,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.chip_gain, card.ability.extra.rank } }
    end,
    calculate = function(self, card, context)
        if context.discard and not context.other_card.debuff and not context.blueprint then
            if context.other_card:is_rank(card.ability.extra.rank) then
                card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_gain
                return {
                    message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.chip_gain } },
                    colour = G.C.CHIPS,
                    card = card
                }
            end
        elseif context.joker_main then
            return {
                chip_mod = card.ability.extra.chips,
                message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.chips } }
            }
        end
    end
}


SMODS.Joker {
    key = 'binary',
    loc_txt = {
        name = 'Binary Joker',
        text = {
            "{C:attention}2{} and {C:attention}10{} are",
            "considered the",
            "same {C:attention}rank{}"
        }
    },
    rarity = 1,
    atlas = 'Malvalatro_Jokers',
    pos = { x = 0, y = 3 },
    cost = 4,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true
}


SMODS.Joker {
    key = 'arcane',
    loc_txt = {
        name = 'Arcane Eye',
        text = {
            "{C:tarot}Tarot{} cards can",
            "select {C:attention}#1#{} additional",
            "{C:attention}playing card{}"
        }
    },
    config = { extra = { select = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.select } }
    end,
    rarity = 1,
    atlas = 'Malvalatro_Jokers',
    pos = { x = 0, y = 12 },
    cost = 6,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    add_to_deck = function(self, card, from_debuff)
        for k, v in pairs(G.P_CENTERS) do
            if v.config and v.set == "Tarot" then
                if v.config.max_highlighted then
                    v.config.max_highlighted = v.config.max_highlighted + card.ability.extra.select
                end
            end
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        for k, v in pairs(G.P_CENTERS) do
            if v.config and v.set == "Tarot" then
                if v.config.max_highlighted then
                    v.config.max_highlighted = v.config.max_highlighted - card.ability.extra.select
                end
            end
        end
    end
}


SMODS.Joker {
    key = 'serpent_oil',
    loc_txt = {
        name = 'Serpent Oil',
        text = {
            "After you Play or Discard",
            "less than {C:attention}3{} cards",
            "draw {C:attention}3{} cards"
        }
    },
    rarity = 1,
    atlas = 'Malvalatro_Jokers',
    pos = { x = 2, y = 15 },
    cost = 5,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true
}


SMODS.Joker {
    key = 'paycheck',
    loc_txt = {
        name = 'Paycheck',
        text = {
            "Earn {C:money}$#1#{} for each scoring",
            "card between {C:attention}9{} and {C:attention}5{}",
            "{C:inactive}(Includes 6, 7, and 8){}"
        }
    },
    config = { extra = { money = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.money } }
    end,
    rarity = 1,
    atlas = 'Malvalatro_Jokers',
    pos = { x = 1, y = 4 },
    cost = 4,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.before then
            for i = 1, #context.scoring_hand do
                if not context.scoring_hand[i].debuff and (context.scoring_hand[i]:get_id() > 5 and context.scoring_hand[i]:get_id() < 9) then
                    G.E_MANAGER:add_event(Event({func = function()
                        context.scoring_hand[i]:juice_up()
                        card:juice_up()
                    return true end })) 
                    ease_dollars(card.ability.extra.money)
                    delay(0.23)
                end
            end
        end
    end
}


SMODS.Joker {
    key = 'bodybuilder',
    loc_txt = {
        name = 'Bodybuilder',
        text = {
            "Create a {C:attention}Strength{} card",
            "when {C:attention}Blind{} is selected if",
            "no consumable cards are held"
        }
    },
    rarity = 1,
    atlas = 'Malvalatro_Jokers',
    pos = { x = 7, y = 14 },
    cost = 6,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.setting_blind and not (context.blueprint_card or card).getting_sliced and #G.consumeables.cards == 0 then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                func = (function()
                    G.E_MANAGER:add_event(Event({
                        func = function() 
                            local tarot = create_card('Tarot',G.consumeables, nil, nil, nil, nil, 'c_strength', 'bodybuilder')
                            tarot:add_to_deck()
                            G.consumeables:emplace(tarot)
                            G.GAME.consumeable_buffer = 0
                            return true
                    end}))   
                    return {
                        message = 'Flexing',
                        card = card
                    }
            end)}))
        end
    end
}


SMODS.Joker {
    key = 'zip',
    loc_txt = {
        name = 'Zip Bomb',
        text = {
            "Sell this card to fill all",
            "Joker slots with {C:attention}random{} Jokers",
            "and all consumable slots with",
            "{C:attention}random{} consumable cards"
        }
    },
    rarity = 2,
    atlas = 'Malvalatro_Jokers',
    pos = { x = 7, y = 13 },
    cost = 10,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.selling_self then
            local jokers_to_create = G.jokers.config.card_limit - (#G.jokers.cards + G.GAME.joker_buffer) + 1
            if card.edition then
                if card.edition.negative then
                    jokers_to_create = jokers_to_create - 1
                end
            end
            local consumeables_to_create = G.consumeables.config.card_limit - #G.consumeables.cards
            G.GAME.joker_buffer = G.GAME.joker_buffer + jokers_to_create
            G.E_MANAGER:add_event(Event({
                func = function() 
                    for i = 1, jokers_to_create do
                        local joker = create_card('Joker', G.jokers, nil, nil, nil, nil, nil, 'zip')
                        joker:add_to_deck()
                        G.jokers:emplace(joker)
                        card:start_materialize()
                        G.GAME.joker_buffer = 0
                    end
                    for i = 1, consumeables_to_create do
                        local consumeable_type = pseudorandom_element({'Planet', 'Planet', 'Tarot', 'Tarot', 'Spectral'}, pseudoseed('zip_bomb'))
                        local consumeable = create_card(consumeable_type, G.consumeables, nil, nil, nil, nil, nil, 'zip')
                        consumeable:add_to_deck()
                        G.consumeables:emplace(consumeable)
                    end
                return true
            end}))
        end
    end
}


SMODS.Joker {
    key = 'broker',
    loc_txt = {
        name = 'Broker',
        text = {
            "{X:mult,C:white}X#1#{} Mult",
            "Loses {X:mult,C:white}X#2#{} Mult for",
            "every {C:money}$#3#{} you have",
            "{C:inactive}(Currently {X:mult,C:white}X#4#{C:inactive} Mult)"
        }
    },
    config = { extra = { mult = 3, mult_reduce = 0.1, dollars = 1 } },
    rarity = 2,
    atlas = 'Malvalatro_Jokers',
    pos = { x = 5, y = 12 },
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    loc_vars = function(self, info_queue, card)
        local current_mult = card.ability.extra.mult_reduce * math.floor((G.GAME.dollars + (G.GAME.dollar_buffer or 0)) / card.ability.extra.dollars)
        current_mult = card.ability.extra.mult - current_mult
        if current_mult < 1 then
            current_mult = 1
        end
        return { vars = { card.ability.extra.mult, card.ability.extra.mult_reduce, card.ability.extra.dollars, current_mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local current_mult = card.ability.extra.mult_reduce * math.floor((G.GAME.dollars + (G.GAME.dollar_buffer or 0)) / card.ability.extra.dollars)
            current_mult = card.ability.extra.mult - current_mult
            if current_mult < 1 then
                current_mult = 1
            end
            return {
                message = localize { type = 'variable', key = 'a_xmult', vars = { current_mult } },
                Xmult_mod = current_mult
            }
        end
    end
}


SMODS.Joker {
    key = 'jenny',
    loc_txt = {
        name = 'Jenny',
        text = {
            "Each played {C:attention}8{}, {C:attention}6{}, {C:attention}7{},",
            "{C:attention}5{}, {C:attention}3{}, or {C:attention}9{} gives",
            "{C:mult}+#1#{} Mult when scored"
        }
    },
    config = { extra = { mult = 7 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
    rarity = 2,
    atlas = 'Malvalatro_Jokers',
    pos = { x = 5, y = 7 },
    cost = 5,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card:is_rank(8) or context.other_card:is_rank(6) or
            context.other_card:is_rank(7) or context.other_card:is_rank(5) or
            context.other_card:is_rank(3) or context.other_card:is_rank(9) then
                return {
					mult = card.ability.extra.mult,
					card = card
				}
            end
        end
    end
}


SMODS.Joker {
    key = 'sculptor',
    loc_txt = {
        name = 'Sculptor',
        text = {
            "Played {C:blue}Stone Cards{} become",
            "copies of the {C:attention}first{} played",
            "card during scoring"
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_stone
        return { vars = {} }
    end,
    rarity = 2,
    atlas = 'Malvalatro_Jokers',
    pos = { x = 9, y = 0 },
    cost = 5,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    enhancement_gate = 'm_stone',
    calculate = function(self, card, context)
        if context.before then
            local first = context.scoring_hand[1]
            for i = 1, #context.scoring_hand do
                local other = context.scoring_hand[i]
                if other.ability.effect == 'Stone Card' then
                    copy_card(first, other)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            other:juice_up()
                            return true
                        end
                    }))
                end
            end
        end
    end
}


SMODS.Joker {
    key = 'mobius',
    loc_txt = {
        name = 'Mobius',
        text = {
            "Retrigger all played",
            "cards if played hand",
            "contains a {C:attention}Straight{}"
        }
    },
    config = { extra = { repetitions = 1 } },
    rarity = 2,
    atlas = 'Malvalatro_Jokers',
    pos = { x = 1, y = 5 },
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.before then
            if next(context.poker_hands['Straight']) then
                card.ability.extra.repetitions = 1
            else
                card.ability.extra.repetitions = 0
            end
        end
        if context.repetition then
            if context.cardarea == G.play then
                return {
                    message = 'Again',
                    repetitions = card.ability.extra.repetitions,
                    card = card
                }
            end
        end
    end
}


SMODS.Joker {
    key = 'prism',
    loc_txt = {
        name = 'Prism',
        text = {
            "If {C:attention}poker hand{}",
            "is a {C:attention}Straight Flush{}",
            "create a {C:attention}Double Tag{}"
        }
    },
    rarity = 2,
    atlas = 'Malvalatro_Jokers',
    pos = { x = 4, y = 6 },
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.before then
            if next(context.poker_hands['Straight Flush']) then
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        card:juice_up(0.5, 0.5)
                        add_tag(Tag('tag_double'))
                        play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                        play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                        return true
                    end)
                }))
            end
        end
    end
}


SMODS.Joker {
    key = 'pauper',
    loc_txt = {
        name = 'Pauper',
        text = {
            "{C:blue}Common{} Jokers",
            "each give {C:chips}+#1#{} Chips"
        }
    },
    config = { extra = { chips = 50 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips } }
    end,
    rarity = 2,
    atlas = 'Malvalatro_Jokers',
    pos = { x = 9, y = 5 },
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.other_joker then
            if context.other_joker.config.center.rarity == 1 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        context.other_joker:juice_up(0.5, 0.5)
                        return true
                    end
                }))
                return {
                    message = localize { type='variable', key='a_chips', vars = { card.ability.extra.chips } },
                    chip_mod = card.ability.extra.chips
                }
            end
        end
    end
}


SMODS.Joker {
    key = 'jackpot',
    loc_txt = {
        name = 'Jackpot!',
        text = {
            "If played hand contains {C:attention}#1#{}",
            "scoring {C:attention}7s{}, create {C:attention}#2#{} random",
            "consumable cards",
            "{C:inactive}(Must have room)"
        }
    },
    config = { extra = { sevens = 3, consumeables = 2 } },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.sevens, card.ability.extra.consumeables } }
    end,
    rarity = 2,
    atlas = 'Malvalatro_Jokers',
    pos = { x = 8, y = 13 },
    cost = 7,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.before then
            local seven_count = 0
            for i = 1, #context.scoring_hand do
                if context.scoring_hand[i]:is_rank(7) then
                    seven_count = seven_count + 1
                end
            end
            if seven_count >= card.ability.extra.sevens then
                local consumeable_max = G.consumeables.config.card_limit - #G.consumeables.cards
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 2
                for i = 1, math.min(card.ability.extra.consumeables, consumeable_max) do
                    local consumeable_type = pseudorandom_element({'Planet', 'Planet', 'Tarot', 'Tarot', 'Spectral'}, pseudoseed('jackpot'))
                    G.E_MANAGER:add_event(Event({
                        func = (function()
                            local card = create_card(consumeable_type, G.consumeables, nil, nil, nil, nil, nil, 'jackpot')
                            card:add_to_deck()
                            G.consumeables:emplace(card)
                            G.GAME.consumeable_buffer = 0
                            return true
                    end)}))
                end
                return {
                    message = 'Jackpot!',
                    card = card
                }
            end
        end
    end
}


SMODS.Joker {
    key = 'lasagna',
    loc_txt = {
        name = 'Lasagna Spiral',
        text = {
            "Retrigger each played {C:attention}#1#{}",
            "Rank changes every round"
        }
    },
    config = { extra = { repetitions = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { localize(G.GAME.current_round.lasagna_card.rank, 'ranks') } }
    end,
    rarity = 2,
    atlas = 'Malvalatro_Jokers',
    pos = { x = 8, y = 11 },
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
		if context.cardarea == G.play and context.repetition and not context.repetition_only then
			if context.other_card:is_rank(G.GAME.current_round.lasagna_card.id) then
				return {
					message = 'Again',
					repetitions = card.ability.extra.repetitions,
					card = card
				}
			end
		end
	end
}


-- SMODS.Joker {
--     key = 'report',
--     loc_txt = {
--         name = 'Report Card',
--         text = {
--             "Upgrade played {C:attention}poker hand{}",
--             "if it is a {C:attention}#1#{}",
--             "Poker hand changes every round"
--         }
--     },
--     loc_vars = function(self, info_queue, card)
--         return { vars = { localize(G.GAME.current_round.report_card.hand, 'poker_hands') } }
--     end,
--     rarity = 2,
--     atlas = 'Malvalatro_Jokers',
--     pos = { x = 0, y = 15 },
--     cost = 6,
--     blueprint_compat = true,
--     eternal_compat = true,
--     perishable_compat = true,
--     calculate = function(self, card, context)
--         if context.before then
--             if context.scoring_name == G.GAME.current_round.report_card.hand then
--                 level_up_hand(context.blueprint_card or card, G.GAME.current_round.report_card.hand, nil, 1)
--             end
--         end
--     end
-- }


-- SMODS.Joker {
--     key = 'singularity',
--     loc_txt = {
--         name = 'Singularity',
--         text = {
--             "When {C:attention}1{} or more {C:attention}playing cards{}",
--             "are destroyed, add an",
--             "{C:attention}Ace{} to your deck"
--         }
--     },
--     rarity = 3,
-- 	atlas = 'Malvalatro_Jokers',
-- 	pos = { x = 2, y = 4 },
-- 	cost = 7,
--     blueprint_compat = true,
--     eternal_compat = true,
--     perishable_compat = true,
--     calculate = function(self, card, context)
--         if context.remove_playing_cards and #context.removed >= 1 then
--             G.E_MANAGER:add_event(Event({ func = function()
--                 local cards = {}
--                 for i = 1, #context.removed do
--                     local _suit = pseudorandom_element({'S','H','D','C'}, pseudoseed('singularity'))
--                     local cen_pool = {}
--                     for k, v in pairs(G.P_CENTER_POOLS["Enhanced"]) do
--                         if v.key ~= 'm_stone' then 
--                             cen_pool[#cen_pool+1] = v
--                         end
--                     end
--                     cen_pool[#cen_pool+1] = G.P_CENTERS.c_base
--                     local card = create_playing_card({front = G.P_CARDS[_suit..'_A'], center = pseudorandom_element(cen_pool, pseudoseed('singularity'))}, G.hand, nil, i ~= 1, {G.C.SECONDARY_SET.Enhanced})
--                     cards[i] = card
--                 end
--                 playing_card_joker_effects(cards)
--                 local _suit = pseudorandom_element({'S','H','D','C'}, pseudoseed('singularity'))
--                 local cen_pool = {}
--                 for k, v in pairs(G.P_CENTER_POOLS["Enhanced"]) do
--                     if v.key ~= 'm_stone' then 
--                         cen_pool[#cen_pool+1] = v
--                     end
--                 end
--                 cen_pool[#cen_pool+1] = G.P_CENTERS.c_base
--                 local card = create_playing_card({front = G.P_CARDS[_suit..'_A'], center = pseudorandom_element(cen_pool, pseudoseed('singularity'))}, G.hand, nil, nil, {G.C.SECONDARY_SET.Enhanced})
--                 playing_card_joker_effects({card})
--             return true end }))
--         end
--     end
-- }


SMODS.Joker {
    key = 'diploma',
    loc_txt = {
        name = 'Diploma',
        text = {
            "Upgrading a {C:attention}poker hand{}",
            "gives {C:attention}#1#{} additional level"
        }
    },
    config = { extra = { levels = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.levels } }
    end,
    rarity = 3,
    atlas = 'Malvalatro_Jokers',
    pos = { x = 8, y = 8 },
    cost = 8,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true
}


SMODS.Joker {
    key = 'singularity',
    loc_txt = {
        name = 'Singularity',
        text = {
            "Played {C:attention}Aces{} give",
            "{X:mult,C:white}X#1#{} Mult when scored",
        }
    },
    config = { extra = { x_mult = 2 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_mult } }
    end,
    rarity = 3,
    atlas = 'Malvalatro_Jokers',
    pos = { x = 2, y = 4 },
    cost = 8,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card:is_rank(14) then
                return {
					x_mult = card.ability.extra.x_mult,
					card = card
				}
            end
        end
    end
}


SMODS.Joker {
    key = 'jacker',
    loc_txt = {
        name = 'Jacker',
        text = {
            "{C:attention}Playing cards{} added to",
            "your deck become {C:attention}Jacks{}"
        }
    },
    rarity = 3,
    atlas = 'Malvalatro_Jokers',
    pos = { x = 8, y = 5 },
    cost = 8,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true
}


SMODS.Joker {
    key = 'whale',
    loc_txt = {
        name = 'Whale',
        text = {
            "Jokers and {C:attention}playing cards{}",
            "with {C:blue}Editions{} give {X:mult,C:white}X#1#{} Mult"
        }
    },
    config = { extra = { mult = 1.5 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
    rarity = 3,
    atlas = 'Malvalatro_Jokers',
    pos = { x = 9, y = 14 },
    cost = 8,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card.edition then
                return {
                    x_mult = card.ability.extra.mult,
                    card = card
                }
            end
        end
        if context.other_joker then
            if context.other_joker.edition then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        context.other_joker:juice_up(0.5, 0.5)
                        return true
                    end
                }))
                return {
                    message = localize { type='variable', key='a_xmult', vars = { card.ability.extra.mult } },
                    Xmult_mod = card.ability.extra.mult
                }
            end
        end
    end
}


SMODS.Joker {
    key = 'jollar',
    loc_txt = {
        name = 'Jollar Bill',
        text = {
            "This Joker gains {X:mult,C:white}X#2#{} Mult",
            "when {C:money}$1{} or more is earned",
            "{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult)"
        }
    },
    config = { extra = { x_mult = 1, x_mult_gain = 0.05 } },
    rarity = 3,
    atlas = 'Malvalatro_Jokers',
    pos = { x = 5, y = 1 },
    cost = 10,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_mult, card.ability.extra.x_mult_gain } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.x_mult } },
                Xmult_mod = card.ability.extra.x_mult
            }
        end
    end
}


SMODS.Joker {
    key = 'tic_tac',
    loc_txt = {
        name = 'Tic-Tac',
        text = {
            "{C:dark_edition}Non-Negative{} consumable",
            "cards have a {C:green}#1#{} in {C:green}#2#{} chance",
            "to create a {C:dark_edition}Negative{}",
            "free copy when used",
            "{C:inactive}(Negative copies can still appear)"
        }
    },
    config = { extra = { odds = 2 } },
    rarity = 4,
    atlas = 'Malvalatro_Jokers',
    pos = { x = 3, y = 8 },
    cost = 20,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.e_negative
        return { vars = { (G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
    end,
    calculate = function(self, card, context)
        if context.using_consumeable then
            local consumeable = context.consumeable
            if not consumeable.edition then
                if pseudorandom('tic_tac') < G.GAME.probabilities.normal / card.ability.extra.odds then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            local copy = copy_card(consumeable, nil)
                            copy.no_sell = true
                            copy:set_edition('e_negative', true)
                            copy:add_to_deck()
                            G.consumeables:emplace(copy)
                            return true
                        end
                    }))
                    return {
                        message = 'Copied'
                    }
                end
            end
        end
    end
}


SMODS.Joker {
    key = 'mandrake',
    loc_txt = {
        name = 'Mandrake',
        text = {
            "Create a free {C:attention}Voucher Tag{}",
            "when {C:attention}Small Blind{} or",
            "{C:attention}Big Blind{} is defeated",
            "Some {C:attention}redeemed{} vouchers can",
            "still appear in the {C:attention}shop{}"
        }
    },
    rarity = 4,
    atlas = 'Malvalatro_Jokers',
    pos = { x = 4, y = 8 },
    cost = 20,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.end_of_round and not G.GAME.blind.boss and context.cardarea == G.jokers then
            G.E_MANAGER:add_event(Event({
                func = (function()
                    card:juice_up(0.5, 0.5)
                    add_tag(Tag('tag_voucher'))
                    play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                    play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                    return true
                end)
            }))
        end
    end
}


SMODS.Joker {
    key = 'malvadar',
    loc_txt = {
        name = 'Malvadar',
        text = {
            "Gain {C:attention}+#1#{} Joker Slot",
            "for every {C:attention}#2#{C:inactive} [#3#]{}",
            "{C:attention}playing cards{} destroyed",
            "{C:inactive}(Requires {C:attention}#4#{C:inactive} more each time)"
        }
    },
    config = { extra = { slots = 1, destroy = 4, malvadar_destroyed = 4, increase = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.slots, card.ability.extra.destroy, card.ability.extra.malvadar_destroyed, card.ability.extra.increase } }
    end,
    rarity = 4,
    atlas = 'Malvalatro_Jokers',
    pos = { x = 5, y = 8 },
    cost = 20,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if (context.remove_playing_cards and not context.blueprint) and #context.removed >= 1 then
            for i = 1, #context.removed do
                card.ability.extra.malvadar_destroyed = card.ability.extra.malvadar_destroyed - 1
                if card.ability.extra.malvadar_destroyed <= 0 then
                    card.ability.extra.destroy = card.ability.extra.destroy + card.ability.extra.increase
                    card.ability.extra.malvadar_destroyed = card.ability.extra.destroy
                    G.E_MANAGER:add_event(Event({func = function()
                        if G.jokers then 
                            card:juice_up(0.5, 0.5)
                            G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.slots
                        end
                        return {
                            message = 'Upgrade',
                            card = card
                        }
                    end }))
                end
            end
        end
    end
}


SMODS.Joker {
    key = 'aelar',
    loc_txt = {
        name = 'Aelar',
        text = {
            "This Joker gains {X:mult,C:white}X#2#{} Mult",
            "when {C:mult}+Mult{} is triggered",
            "{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult)"
        }
    },
    config = { extra = { x_mult = 1, x_mult_gain = 0.1 } },
    rarity = 4,
    atlas = 'Malvalatro_Jokers',
    pos = { x = 6, y = 8 },
    cost = 20,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_mult, card.ability.extra.x_mult_gain } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.x_mult } },
                Xmult_mod = card.ability.extra.x_mult
            }
        end
    end
}


SMODS.Joker {
    key = 'rix',
    loc_txt = {
        name = "Rix",
        text = {
            "When you {C:attention}buy{} a Joker",
            "create a {C:dark_edition}Negative{} copy of it",
            "When you {C:attention}sell{} a Joker",
            "destroy all copies of it"
        }
    },
    rarity = 4,
    atlas = 'Malvalatro_Jokers',
    pos = { x = 7, y = 8 },
    cost = 20,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.buying_card then
            if context.card.ability.set == "Joker" then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        local copy = copy_card(context.card, nil)
                        copy:set_edition('e_negative', true)
                        copy:add_to_deck()
                        G.jokers:emplace(copy)
                        return true
                    end
                }))
            end
        end
        if context.selling_card then
            if context.card.ability.set == "Joker" then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        for i = 1, #G.jokers.cards do
                            if context.card.ability.name == G.jokers.cards[i].ability.name then
                                G.jokers.cards[i]:start_dissolve({G.C.RED}, nil, 1.6)
                            end
                        end
                        return true
                    end
                }))
            end
        end
    end
}
