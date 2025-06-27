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
    key = 'jack_of_spades',
    loc_txt = {
        name = 'Jack of Spades',
        text = {
            "Adds mult equal to the",
            "combined ranks of all",
            "scoring cards",
            "{C:inactive}(Cannot exceed {C:attention}21{C:inactive})"
        }
    },
    rarity = 1,
    atlas = 'Malvalatro_Jokers',
    pos = { x = 0, y = 0 },
    cost = 5,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.joker_main then
            local sum = 0
            local aces = 0
            for i = 1, #context.scoring_hand do
                if not context.scoring_hand[i].debuff then
                    if context.scoring_hand[i]:is_rank(14) then
                        aces = aces + 1
                    elseif context.scoring_hand[i].ability.effect ~= 'Stone Card' then
                        sum = sum + context.scoring_hand[i].base.nominal
                    end
                end
            end
            if aces > 0 then
                sum = sum + aces - 1
                if sum <= 10 then
                    sum = sum + 11
                else
                    sum = sum + 1
                end
            end
            if sum <= 21 then
                return {
                    mult_mod = sum,
                    message = localize { type = 'variable', key = 'a_mult', vars = { sum } }
                }
            else
                return {
                    message = 'Bust',
                    card = card
                }
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
            "card from {C:attention}9{} to {C:attention}5{}",
            "{C:inactive}(Includes 5, 6, 7, 8, and 9){}"
        }
    },
    config = { extra = { money = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.money } }
    end,
    rarity = 1,
    atlas = 'Malvalatro_Jokers',
    pos = { x = 1, y = 4 },
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.before then
            for i = 1, #context.scoring_hand do
                if not context.scoring_hand[i].debuff and (context.scoring_hand[i]:get_id() >= 5 and context.scoring_hand[i]:get_id() <= 9) then
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
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.c_strength
        return { vars = {} }
    end,
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
                            local tarot = create_card('Tarot', G.consumeables, nil, nil, nil, nil, 'c_strength', 'bodybuilder')
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
    key = 'omelette',
    loc_txt = {
        name = "Omelette",
        text = {
            "When a card is {C:attention}sold{}",
            "this Joker gains",
            "its {C:attention}sell value{}"
        }
    },
    rarity = 1,
    atlas = 'Malvalatro_Jokers',
    pos = { x = 0, y = 10 },
    cost = 1,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.selling_card and not context.blueprint then
            card.ability.extra_value = card.ability.extra_value + context.card.sell_cost
            card:set_cost()
            return {
                message = localize('k_val_up'),
                colour = G.C.MONEY
            }
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
                if card.edition.negative or card.edition.key == 'e_mal_phantom' then
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
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = {key = 'tag_double', set = 'Tag'}
        return { vars = {} }
    end,
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
    key = 'loom',
    loc_txt = {
        name = "The Loom",
        text = {
            "If any {C:attention}discard{} is a {C:attention}single{}",
            "{C:attention}#1#{}, destroy it and",
            "create a random {C:tarot}Tarot{} card",
            "Rank changes every round"
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { localize(G.GAME.current_round.loom_card.rank, 'ranks') } }
    end,
    rarity = 2,
    atlas = 'Malvalatro_Jokers',
    pos = { x = 1, y = 10 },
    cost = 6,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.discard then
            if #context.full_hand == 1 then
                if context.full_hand[1]:is_rank(G.GAME.current_round.loom_card.id) then
                    local consumeable_max = G.consumeables.config.card_limit - #G.consumeables.cards
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    if consumeable_max > 0 then
                        G.E_MANAGER:add_event(Event({
                            func = (function()
                                local card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, nil, 'loom')
                                card:add_to_deck()
                                G.consumeables:emplace(card)
                                G.GAME.consumeable_buffer = 0
                                return true
                        end)}))
                    end
                    return {
                        remove = true,
                        card = card
                    }
                end
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
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.playing_card_added and not (card.getting_sliced or context.blueprint) then
            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = 'Jack', colour = G.C.SECONDARY_SET.Enhanced})
        end
    end
}


SMODS.Joker {
    key = 'whale',
    loc_txt = {
        name = 'Whale',
        text = {
            "Jokers and {C:attention}playing cards{}",
            "with {C:dark_edition}Editions{} give {X:mult,C:white}X#1#{} Mult"
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
    key = 'haunted',
    loc_txt = {
        name = 'Haunted Joker',
        text = {
            "All {C:tarot}Tarot{} cards have a",
            "{C:green}#1# in #2#{} chance to appear",
            "as a {C:spectral}Spectral{} card instead"
        }
    },
    config = { extra = { odds = 4 } },
    rarity = 3,
    atlas = 'Malvalatro_Jokers',
    pos = { x = 8, y = 10 },
    cost = 8,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { (G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
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
    key = 'reaper',
    loc_txt = {
        name = 'The Reaper',
        text = {
            "When {C:attention}#1#{} or more {C:attention}playing{}",
            "{C:attention}cards{} are destroyed",
            "create a {C:attention}Death{} card",
            "{C:inactive}(Must have room){}"
        }
    },
    config = { extra = { destroyed = 1 } },
    rarity = 3,
    atlas = 'Malvalatro_Jokers',
    pos = { x = 3, y = 4 },
    cost = 8,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.c_death
        return { vars = { card.ability.extra.destroyed } }
    end,
    calculate = function(self, card, context)
        if context.remove_playing_cards and #context.removed >= card.ability.extra.destroyed then
            if G.consumeables.config.card_limit - #G.consumeables.cards > 0 then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    func = function() 
                        local tarot = create_card('Tarot', G.consumeables, nil, nil, nil, nil, 'c_death', 'reaper')
                        tarot:add_to_deck()
                        G.consumeables:emplace(tarot)
                        G.GAME.consumeable_buffer = 0
                        return {
                            card = card
                        }
                end}))
            end
        end
    end
}


SMODS.Joker {
    key = 'tic_tac',
    loc_txt = {
        name = 'Tic-Tac',
        text = {
            "{C:dark_edition}Non-Phantom{} consumable",
            "cards have a {C:green}#1# in #2#{} chance",
            "to create a {C:dark_edition}Phantom{}",
            "copy when used"
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
        info_queue[#info_queue + 1] = {key = 'e_mal_phantom', set = 'Edition', config = {}}
        return { vars = { (G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
    end,
    calculate = function(self, card, context)
        if context.using_consumeable then
            local consumeable = context.consumeable
            if not consumeable.edition or not (consumeable.edition.key == 'e_mal_phantom') then
                if pseudorandom('tic_tac') < G.GAME.probabilities.normal / card.ability.extra.odds then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            local copy = copy_card(consumeable, nil)
                            copy:set_edition('e_mal_phantom', true)
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
            "{C:inactive}(Some redeemed vouchers{}",
            "{C:inactive}still appear in the shop){}"
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = {key = 'tag_voucher', set = 'Tag'}
        return { vars = {} }
    end,
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
            "When {C:attention}Blind{} is selected,",
            "do something {C:dark_edition}AWESOME{}",
            "{C:inactive}(Currently {X:mult,C:white}X#1#{c:inactive} Mult){}"
        }
    },
    config = { extra = { x_mult = 1, x_mult_gain = 0.5, dollars = 10, hands = 1, discards = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_mult, card.ability.extra.x_mult_gain } }
    end,
    rarity = 4,
    atlas = 'Malvalatro_Jokers',
    pos = { x = 5, y = 8 },
    cost = 20,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        
        if context.setting_blind and not card.getting_sliced then
            local rand = pseudorandom('mal_malvadar')

            if (rand <= 0.1) then
                sendTraceMessage("Option #1", "MessageLogger")
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = 'Money', colour = G.C.SECONDARY_SET.Enhanced})
                ease_dollars(card.ability.extra.dollars, true)
            end

            if (0.1 < rand and rand <= 0.2) then
                sendTraceMessage("Option #2", "MessageLogger")
                local _rank = pseudorandom_element({'J', 'Q', 'K'}, pseudoseed('mal_create'))
                local _suit = pseudorandom_element({'S','H','D','C'}, pseudoseed('mal_create'))
                local cen_pool = {}
                for k, v in pairs(G.P_CENTER_POOLS["Enhanced"]) do
                    if v.key ~= 'm_stone' then 
                        cen_pool[#cen_pool+1] = v
                    end
                end
                G.E_MANAGER:add_event(Event({
                    func = function() 
                        G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                        local _front = G.P_CARDS[_suit..'_'.._rank]
                        local _center = pseudorandom_element(cen_pool, pseudoseed('mal_card'))
                        local new_card = Card(G.play.T.x + G.play.T.w/2, G.play.T.y, G.CARD_W, G.CARD_H, _front, _center, {playing_card = G.playing_card})
                        local seal_type = pseudorandom(pseudoseed('mal_seal'))
                        if seal_type > 0.75 then new_card:set_seal('Red', true)
                        elseif seal_type > 0.5 then new_card:set_seal('Blue', true)
                        elseif seal_type > 0.25 then new_card:set_seal('Gold', true)
                        else new_card:set_seal('Purple', true)
                        end
                        local edition = poll_edition('mal_edition', nil, true, true)
                        new_card:set_edition(edition)
                        new_card:start_materialize({G.C.SECONDARY_SET.Enhanced})
                        G.play:emplace(new_card)
                        table.insert(G.playing_cards, new_card)
                        return true
                end}))

                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = 'Card', colour = G.C.SECONDARY_SET.Enhanced})

                G.E_MANAGER:add_event(Event({
                    func = function() 
                        G.deck.config.card_limit = G.deck.config.card_limit + 1
                        return true
                end}))
                
                draw_card(G.play, G.deck, 90,'up', nil)  
                playing_card_joker_effects({true})

            end

            if (0.2 < rand and rand <= 0.3) then
                sendTraceMessage("Option #3", "MessageLogger")
                for i = 1, 2 do
                    local consumeable = create_card('Tarot_Planet', G.consumeables, nil, nil, nil, nil, nil, 'malvadar')
                    if #G.consumeables.cards >= G.consumeables.config.card_limit then
                        consumeable:set_edition('e_mal_phantom')
                    end
                    consumeable:add_to_deck()
                    G.consumeables:emplace(consumeable)
                end

                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = 'Consumables', colour = G.C.SECONDARY_SET.Enhanced})
            end

            if (0.3 < rand and rand <= 0.4) then
                sendTraceMessage("Option #4", "MessageLogger")
                for i = 1, 2 do
                    local joker = create_card('Joker', G.jokers, nil, nil, nil, nil, nil, 'malvadar')
                    if #G.jokers.cards >= G.jokers.config.card_limit then
                        joker:set_edition('e_mal_phantom')
                    end
                    joker:add_to_deck()
                    joker:start_materialize()
                    G.jokers:emplace(joker)
                end
            end

            if (0.4 < rand and rand <= 0.5) then
                sendTraceMessage("Option #5", "MessageLogger")
                for i = 1, 2 do
                    local tag = pseudorandom_element({'tag_uncommon', 'tag_rare', 'tag_negative', 'tag_foil', 'tag_holo', 'tag_polychrome', 'tag_voucher', 'tag_coupon', 'tag_d_six'}, pseudoseed('mal_tag'))
                    G.E_MANAGER:add_event(Event({
                    func = function()
                        card:juice_up(0.5, 0.5)
                        add_tag(Tag(tag))
                        play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                        play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                        return true
                    end}))
                end

                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = 'Tags', colour = G.C.SECONDARY_SET.Enhanced})
            end

            if (0.5 < rand and rand <= 0.6) then
                sendTraceMessage("Option #6", "MessageLogger")
                G.E_MANAGER:add_event(Event({func = function()
                    ease_discard(card.ability.extra.discards, nil, true)
                    ease_hands_played(card.ability.extra.hands)
                return true end }))

                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = '+1/+1', colour = G.C.SECONDARY_SET.Enhanced})
            end

            if (0.6 < rand and rand <= 0.7) then
                sendTraceMessage("Option #7", "MessageLogger")
                local consumeable = create_card('Spectral', G.consumeables, nil, nil, nil, nil, nil, 'malvadar')
                if #G.consumeables.cards >= G.consumeables.config.card_limit then
                    consumeable:set_edition('e_mal_phantom')
                end
                consumeable:add_to_deck()
                G.consumeables:emplace(consumeable)

                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = 'Spectral', colour = G.C.SECONDARY_SET.Enhanced})
            end

            if (0.7 < rand and rand <= 0.8) then
                sendTraceMessage("Option #8", "MessageLogger")
                local editionless_jokers = EMPTY(editionless_jokers)
                for k, v in pairs(G.jokers.cards) do
                    if v.ability.set == 'Joker' and (not v.edition) then
                        table.insert(editionless_jokers, v)
                    end
                end
                if next(editionless_jokers) then
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                        local eligible_card = pseudorandom_element(editionless_jokers, pseudoseed('mal_edition'))
                        local edition = poll_edition('malvadar', nil, false, true)
                        eligible_card:set_edition(edition, true)
                    return true end }))

                    card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = 'Edition', colour = G.C.SECONDARY_SET.Enhanced})
                else
                    rand = rand + 0.1
                end
            end

            if (0.8 < rand and rand <= 0.9) then
                sendTraceMessage("Option #9", "MessageLogger")
                if not context.blueprint then
                    card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_gain
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.x_mult}}})
                else
                    rand = rand + 0.1
                end
            end

            if (0.9 < rand) then
                sendTraceMessage("Option #10", "MessageLogger")
                local poker_hands = {}
                for k, v in pairs(G.GAME.hands) do
                    if v.visible then poker_hands[#poker_hands+1] = k end
                end
                for i = 1, 3 do
                    local hand = pseudorandom_element(poker_hands, pseudoseed('mal_level'))
                    update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(hand, 'poker_hands'),chips = G.GAME.hands[hand].chips, mult = G.GAME.hands[hand].mult, level=G.GAME.hands[hand].level})
                    level_up_hand(context.blueprint_card or card, hand)
                    update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
                end
            end

            return {
                card = card
            }
        end

        if context.joker_main and card.ability.extra.x_mult > 1 then
            return {
                message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.x_mult } },
                Xmult_mod = card.ability.extra.x_mult
            }
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
            "Create {C:dark_edition}Phantom{} copies",
            "of {C:attention}adjacent{} Jokers",
            "when {C:attention}Blind{} is selected"
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = {key = 'e_mal_phantom', set = 'Edition', config = {}}
        return { vars = {} }
    end,
    rarity = 4,
    atlas = 'Malvalatro_Jokers',
    pos = { x = 7, y = 8 },
    cost = 20,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.setting_blind and not (context.blueprint_card or card).getting_sliced then
            local left_joker = nil
            local right_joker = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == (context.blueprint_card or card) then
                    left_joker = G.jokers.cards[i - 1]
                    right_joker = G.jokers.cards[i + 1]
                end
            end
            G.E_MANAGER:add_event(Event({
                func = function()
                    local copy = nil
                    if left_joker then
                        copy = copy_card(left_joker, nil)
                        copy:set_edition('e_mal_phantom', true)
                        copy:set_eternal(false)
                        copy:add_to_deck()
                        G.jokers:emplace(copy)
                    end
                    if right_joker then
                        copy = copy_card(right_joker, nil)
                        copy:set_edition('e_mal_phantom', true)
                        copy:set_eternal(false)
                        copy:add_to_deck()
                        G.jokers:emplace(copy)
                    end
                    return true
                end
            }))
        end
    end
}
