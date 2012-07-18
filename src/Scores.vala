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
    along with ASpiReNN; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
    02111-1307  USA.

***********************************************************************/

/**
 * This class allows to manages score and to display them in a table.
 **/
public class Scores:Gtk.TreeView
{
	private Gtk.ListStore store;
	private int nb_cols;

	public Scores (string[] players_names)
	{
		nb_cols = players_names.length;

		/* Sets store */
		GLib.Type[] types = new GLib.Type[nb_cols];
		foreach (GLib.Type t in types)
		{
			t = typeof (string);
		}
		//store = new Gtk.ListStore.newv (types);
		store = new Gtk.ListStore (nb_cols, typeof(string), typeof (string), typeof (string), typeof (string));
		assert (store != null);
		this.set_model (store);

		/* Add renderer and columns */
		Gtk.CellRenderer renderer = new Gtk.CellRendererText ();
		for (int i = 0; i < players_names.length; i++)
		{
			Gtk.TreeViewColumn column = new Gtk.TreeViewColumn.with_attributes (players_names[i], renderer, "text", i);
			this.append_column (column);
		}
	}

	/**
	 * Add the score from a game 
	 **/
	public void add_scores (int[] scores)
	{
		assert (scores.length == nb_cols);
		Gtk.TreeIter iter;
		store.append (out iter);
		for (int i = 0; i < nb_cols; i++)
		{
			store.set (iter, i, scores[i].to_string ());
		}
	}
}