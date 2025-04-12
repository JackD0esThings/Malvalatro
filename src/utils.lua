-- Upgrading Aelar when +Mult triggers
local scie = SMODS.calculate_individual_effect
function SMODS.calculate_individual_effect(effect, scored_card, key, amount, from_edition)
	local ret = scie(effect, scored_card, key, amount, from_edition)
	if (key == "mult" or key == "mult_mod") and amount > 0 then
		for _, v in pairs(SMODS.find_card('j_mal_aelar', false)) do
			v.ability.extra.x_mult = v.ability.extra.x_mult + v.ability.extra.x_mult_gain
			card_eval_status_text(v, "extra", nil, nil, nil, {
                message = 'Upgrade'
			})
		end
	end
	return ret
end


-- Upgrading Jollar Bill when $ earned
local ed = ease_dollars
function ease_dollars(mod, instant)
    local ret = ed(mod, instant)
    if mod > 0 then
        for _, v in pairs(SMODS.find_card('j_mal_jollar', false)) do
            v.ability.extra.x_mult = v.ability.extra.x_mult + v.ability.extra.x_mult_gain
            card_eval_status_text(v, "extra", nil, nil, nil, {
                message = 'Upgrade'
            })
        end
    end
    return ret
end


-- Destroying Joker trigger
local sd = Card.start_dissolve
function Card:start_dissolve(dissolve_colours, silent, dissolve_time_fac, no_juice)
    local ret = sd(self, dissolve_colours, silent, dissolve_time_fac, no_juice)
    if self.ability.set == 'Joker' then
        for i = 1, #G.jokers.cards do
            G.jokers.cards[i]:calculate_joker({destroy_joker = true, card = self})
        end
    end
    return ret
end


-- Initialize the rank for Lasagna Spiral and poker hand for Report Card
local igo = Game.init_game_object
function Game:init_game_object()
	local ret = igo(self)
	ret.current_round.lasagna_card = { rank = 'Ace' }
    ret.current_round.loom_card = { rank = 'Ace' }
	return ret
end


-- Reset rank for Lasagna Spiral and poker hand for Report Card each round
function SMODS.current_mod.reset_game_globals(run_start)
    G.GAME.current_round.lasagna_card.rank = 'Ace'
    local valid_lasagna_cards = {}
    for k, v in ipairs(G.playing_cards) do
        if v.ability.effect ~= 'Stone Card' then
            valid_lasagna_cards[#valid_lasagna_cards+1] = v
        end
    end
    if valid_lasagna_cards[1] then 
        local lasagna_card = pseudorandom_element(valid_lasagna_cards, pseudoseed('lasagna'..G.GAME.round_resets.ante))
        G.GAME.current_round.lasagna_card.rank = lasagna_card.base.value
        G.GAME.current_round.lasagna_card.id = lasagna_card.base.id
    end

    G.GAME.current_round.loom_card.rank = 'Ace'
    local valid_loom_cards = {}
    for k, v in ipairs(G.playing_cards) do
        if v.ability.effect ~= 'Stone Card' then
            valid_loom_cards[#valid_loom_cards+1] = v
        end
    end
    if valid_loom_cards[1] then 
        local loom_card = pseudorandom_element(valid_loom_cards, pseudoseed('loom'..G.GAME.round_resets.ante))
        G.GAME.current_round.loom_card.rank = loom_card.base.value
        G.GAME.current_round.loom_card.id = loom_card.base.id
    end
end


-- Pool for Mandrake repeat vouchers
-- I'm new to Lua, don't laugh
function Game:get_mandrake()
    local voucher_repeat = {}

    voucher_repeat['v_grabber'] = true
    voucher_repeat['v_wasteful'] = true
    voucher_repeat['v_crystal_ball'] = true
    voucher_repeat['v_paint_brush'] = true

    voucher_repeat['v_nacho_tong'] = true
    voucher_repeat['v_recyclomancy'] = true
    voucher_repeat['v_antimatter'] = true
    voucher_repeat['v_palette'] = true

    return voucher_repeat
end



--Utility function replacing most instances of 'get_id()'
--Mostly used for Binary Joker
function Card:is_rank(num)
    if next(SMODS.find_card('j_mal_binary', false)) then
        if (num == 2 or num == 10) and (self:get_id() == 2 or self:get_id() == 10) then
            return true
        end
    end
    return self:get_id() == num
end


--Overiding the overide by steammodded because the code was terrible
--Small modifications to the original method to work with Binary Joker
function get_straight(hand)
    local ret = {}
    local four_fingers = next(find_joker('Four Fingers'))
    if #hand > 5 or #hand < (5 - (four_fingers and 1 or 0)) then return ret else
      local t = {}
      local IDS = {}
      for i=1, #hand do

        for j=2, 14 do
            if hand[i]:is_rank(j) then
                if IDS[j] then
                    IDS[j][#IDS[j]+1] = hand[i]
                else
                    IDS[j] = {hand[i]}
                end
            end
        end
      end
  
      local straight_length = 0
      local straight = false
      local can_skip = next(find_joker('Shortcut')) 
      local skipped_rank = false
      for j = 1, 14 do
        if IDS[j == 1 and 14 or j] then
          straight_length = straight_length + 1
          skipped_rank = false
          for k, v in ipairs(IDS[j == 1 and 14 or j]) do
            t[#t+1] = v
          end
        elseif can_skip and not skipped_rank and j ~= 14 then
            skipped_rank = true
        else
          straight_length = 0
          skipped_rank = false
          if not straight then t = {} end
          if straight then break end
        end
        if straight_length >= (5 - (four_fingers and 1 or 0)) then straight = true end 
      end
      if not straight then return ret end
      table.insert(ret, t)
      return ret
    end
end
