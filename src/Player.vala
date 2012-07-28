/***********************************************************************
    Copyright (C) 2012 Élisabeth Henry <liz.henry@ouvaton.org>

    This file is part of TnT.

    TnT is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published 
    by the Free Software Foundation; either version 2 of the License,
    or (at your option) any later version.

    TnT is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of 
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License 
    along with this software; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
    02111-1307  USA.

***********************************************************************/


/**
 * Abtract class player, which allows to implement both IA Players and
 * Graphical Players.
 **/
public abstract class Player:GLib.Object
{
	public string name {get; protected set;}
	public int score {get; set;}
	public Hand hand;
	public weak Game game;

	/* Informs of the cards */
	public abstract void receive_hand (Hand hand);

	/* Treat the information of a move */
	public virtual void treat_move_info (int player, Card card) 
	{
	}
	
	/* Treat the results at the end of turn */
	public virtual void treat_turn_info (int winner, Card[] cards)
	{
		game.approve_new_turn (this);
	}

	/* Must decide what bid the player wants to do, and inform back
	 * game.give_bid */
	public abstract void select_bid (Bid max_bid = Bid.PASSE);
	
	/* Must decide of a dog, and call back game.give_dog */
	public abstract void receive_dog (Hand dog);

	/* This method must call back game.give_card at some point */
	public abstract void select_card (int beginner, Card[] cards);
	
	public Player (Game game, string? name = null)
	{
		hand = new Hand ();
		score = 0;
		this.game = game;

		this.name = name;
	}
}