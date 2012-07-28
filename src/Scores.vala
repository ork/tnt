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
 * Callback for TreeViewColumn
 **/
void data_func (Gtk.CellLayout layout, Gtk.CellRendererText renderer, Gtk.TreeModel model, Gtk.TreeIter iter)
{
	GLib.Value value;
	model.get_value (iter, 4, out value);
	string content = value.get_string ();
	int i = int.parse (content);
	
	if (i == 1)
	{
		renderer.cell_background = "#FF00FF";
	}
	else
	{
		renderer.cell_background = "#FFFFFF";
	}
}

/**
 * This class allows to manages score and to display them in a table.
 **/
public class Scores:Gtk.TreeView
{
	private Gtk.ListStore store;
	private int nb_cols;
	private Gtk.TreeIter total;
	private Game game;

	public Scores (Game game, string[] names)
	{
		this.game = game;
		nb_cols = game.nb_players;
		assert (nb_cols == names.length);

		/* Sets store */
		GLib.Type[] types = new GLib.Type[nb_cols];
		foreach (GLib.Type t in types)
		{
			t = typeof (string);
		}
		//store = new Gtk.ListStore.newv (types);
		/* TODO: make varialbe list */
		store = new Gtk.ListStore (nb_cols + 1, typeof(string), typeof (string), typeof (string), typeof (string), typeof (string));
		assert (store != null);
		this.set_model (store);

		/* Add renderer and columns */
		Gtk.CellRendererText renderer = new Gtk.CellRendererText ();
		renderer.set_sensitive (false);
		for (int i = 0; i < game.nb_players; i++)
		{
			Gtk.TreeViewColumn column = new Gtk.TreeViewColumn.with_attributes (names[i], renderer, "text", i);
			this.append_column (column);
			column.set_cell_data_func (renderer, (Gtk.CellLayoutDataFunc) data_func);
		}
		Gtk.TreeViewColumn invisible_column = new Gtk.TreeViewColumn.with_attributes ("Invisible anyway", renderer, "text", game.nb_players);
		invisible_column.set_visible (false);
		this.append_column (invisible_column);

		/* Add the total iter */
		store.append (out total);
		for (int i = 0; i < nb_cols; i++)
		{
			store.set (total, i, "0");
		}
		store.set (total, nb_cols, "1");
		this.set_sensitive (false);
		this.set_grid_lines (Gtk.TreeViewGridLines.BOTH);
	}

	/**
	 * Add the score from a game 
	 **/
	public void add_scores (int[] scores)
	{
		assert (scores.length == nb_cols);
		Gtk.TreeIter iter;
		store.insert_before (out iter, total);
		for (int i = 0; i < nb_cols; i++)
		{
			store.set (iter, i, scores[i].to_string ());
			store.set (total, i, game.players[i].score.to_string ());
		}
		store.set (iter, nb_cols, "0");
		store.set (total, nb_cols, "1");
	}
}