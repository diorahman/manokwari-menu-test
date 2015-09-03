public class Menu {
  private int depth = 0;

  public int test() {
    var apps_menu = new GMenu.Tree(
      "manokwari-applications.menu",
      GMenu.TreeFlags.INCLUDE_EXCLUDED
    );

    try {
      if (!apps_menu.load_sync()) {
        print("Could not load menu.");
        return 0;
      }
    } catch (Error e) {
      print("Error loading menu file: %s", e.message);
      return 0;
    }

    update_tree(apps_menu.get_root_directory());
    print("OK!\n");
    return 1;
  }
  
  private void update_tree(GMenu.TreeDirectory root_tree) {
    var iter = root_tree.iter();
    GMenu.TreeItemType type;
    while ((type = iter.next()) != GMenu.TreeItemType.INVALID) {
      switch (type) {
        case GMenu.TreeItemType.DIRECTORY:
          var dir = iter.get_directory();
          var name = dir.get_name();
          var icon = dir.get_icon().to_string();
          print("dir: %s (icon=%s;%s)\n", name, icon, get_icon_path(icon));
          update_tree(dir);
          break;
        case GMenu.TreeItemType.ALIAS:
        case GMenu.TreeItemType.ENTRY:
          var entry = iter.get_entry();
          var app_info = entry.get_app_info();
          var name = app_info.get_display_name();
          var icon = app_info.get_string("Icon");
          var path = entry.get_desktop_file_path();
          print("  - %s (icon=%s;%s, file:%s)\n", name, icon, get_icon_path(icon), path);
          break;

        default:
          break;
      }
    }
  }

  private string get_icon_path (string name, int size = 24) {
    var icon = Gtk.IconTheme.get_default ();
    var i = icon.lookup_icon (name, size, Gtk.IconLookupFlags.GENERIC_FALLBACK);
    if (i != null) {
      return i.get_filename();
    } else {
      return name;
    }  
  }
}
