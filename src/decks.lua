SMODS.Atlas {
	key = "Malvalatro_Decks",
	path = "Backs.png",
	px = 71,
	py = 95
}


-- SMODS.Back {
--     key = 'test_deck',
--     loc_txt = {
--         name = 'Test Deck',
--         text = {
--             "Start run with whatever",
--             "Joker {C:attention}Jack{} is currently",
--             "{C:attention}playtesting{}"
--         }
--     },
--     atlas = 'Malvalatro_Decks',
--     pos = { x = 0, y = 0 },
--     apply = function(self)
--         G.E_MANAGER:add_event(Event({
--             func = function()
--                 if G.jokers then
--                     --Last parameter should be in the format 'j_mal_jokername' if modded, otherwise it's 'j_jokername'
--                     local card = create_card("Joker", G.jokers, nil, nil, nil, nil, 'j_mal_jacker')
-- 					--card:set_edition('e_mal_phantom', true)
--                     --card:set_eternal(true)
--                     card:add_to_deck()
-- 					card:start_materialize()
-- 					G.jokers:emplace(card)
--                     -- local card = create_card("Joker", G.jokers, nil, nil, nil, nil, 'j_blueprint')
-- 					-- --card:set_edition('e_negative', true)
--                     -- card:add_to_deck()
-- 					-- card:start_materialize()
-- 					-- G.jokers:emplace(card)
--                     -- card = create_card("Tarot", G.consumeables, nil, nil, nil, nil, 'c_emperor')
--                     -- card:set_edition('e_negative', true)
--                     -- card:add_to_deck()
-- 					-- G.consumeables:emplace(card)
--                     --sendTraceMessage("Testing the message logger", "MessageLogger")
--                     return true
--                 end
--             end
--         }))
--     end
-- }


SMODS.Back {
    key = 'malvadeck',
    loc_txt = {
        name = 'Malvadeck',
        text = {
            "Start run with an",
            "{C:attention}Eternal{} {C:purple}Legendary{} Joker",
            "from {C:purple}Malvalatro{}"
        }
    },
    atlas = 'Malvalatro_Decks',
    pos = { x = 3, y = 2 },
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                if G.jokers then
                    local name = pseudorandom_element({'tic_tac', 'mandrake', 'malvadar', 'aelar', 'rix'}, pseudoseed('malvadeck'))
                    local card = create_card("Joker", G.jokers, nil, nil, nil, nil, 'j_mal_'..name)
					card:set_eternal(true)
                    card:add_to_deck()
					card:start_materialize()
					G.jokers:emplace(card)
                    return true
                end
            end
        }))
    end
}
