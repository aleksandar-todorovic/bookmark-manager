using Granite.Widgets;

namespace BookmarkManager {
public class ListBoxRow : Gtk.ListBoxRow {

    private const int PROGRESS_BAR_HEIGHT = 5;

    private Gtk.Label summary_label;
    private Gtk.Label name_label;
    private Gtk.Image start_session_image = new Gtk.Image.from_icon_name ("media-playback-start", Gtk.IconSize.SMALL_TOOLBAR);
    //private Gtk.Image edit_image = new Gtk.Image.from_icon_name ("document-properties", Gtk.IconSize.SMALL_TOOLBAR);
    //private Gtk.Image remove_image = new Gtk.Image.from_icon_name ("edit-delete-symbolic", Gtk.IconSize.SMALL_TOOLBAR);

    private Gtk.Image icon = new Gtk.Image.from_icon_name ("terminal", Gtk.IconSize.DND);        
    private Gtk.Box vertical_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 6);
    private Gtk.Box button_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12);
    private Gtk.ListBoxRow list_bow_row = new Gtk.ListBoxRow ();

    public ListBoxRow (Bookmark bookmark){
        
        name_label = new Gtk.Label ("<b>%s</b>".printf (bookmark.getName()));
        name_label.use_markup = true;
        name_label.halign = Gtk.Align.START;

        var sshCommand = "ssh " + bookmark.getUser() + "@" + bookmark.getIp() + " -p " + bookmark.getPort().to_string();
        
        summary_label = new Gtk.Label (sshCommand);
        summary_label.halign = Gtk.Align.START;

        var start_session_event_box = new Gtk.EventBox();
        start_session_event_box.add(start_session_image);
        start_session_event_box.set_tooltip_text("Start an SSH session");
        start_session_event_box.button_press_event.connect (() => {
            try {
                Process.spawn_command_line_async (
                    "pantheon-terminal --execute='" + sshCommand + "'"
                );
            } catch (SpawnError e) {
	            stdout.printf ("Error: %s\n", e.message);
            }
            return true;
        });

        vertical_box.add (name_label);
        vertical_box.add (summary_label);

        button_box.margin = 12;
        button_box.add(icon);
        button_box.add (vertical_box);
        button_box.pack_end (start_session_event_box, false, false);
        //button_box.pack_end (edit_image, false, false);
        //button_box.pack_end (remove_image, false, false);        

        list_bow_row.add (button_box);
        list_bow_row.selectable = false;
        list_bow_row.activatable = false;

        add (list_bow_row);
    }
}
}
