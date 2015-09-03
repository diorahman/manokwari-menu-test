public class Menu {
  private int depth = 0;
  private StringBuilder json;

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
    
    // the populate function
    json = new StringBuilder();
    json.assign("[");
    update_tree(apps_menu.get_root_directory());
    if (json.str[json.len -1] == ',') {
      json.erase(json.len - 1, 1);
    }
    json.append("]");
    print("%s\n", json.str);
    return 1;
  }
  
  private void update_tree(GMenu.TreeDirectory root_tree) {
    var iter = root_tree.iter();
    GMenu.TreeItemType type;
    while ((type = iter.next()) != GMenu.TreeItemType.INVALID) {
      switch (type) {
        case GMenu.TreeItemType.DIRECTORY:
          if (depth > 0) {
            break;
          }
          var dir = iter.get_directory();
          var name = dir.get_name();
          var icon = dir.get_icon().to_string();
          // print("dir: %s (icon=%s;%s)\n", name, icon, get_icon_path(icon));
          var data = "{
            \"name\": \"%s\",
            \"icon\": \"%s\",
          ".printf(name, get_icon_path(icon));
          json.append(data);
          json.append("\"children\": [");
          depth++;
          update_tree(dir);
          depth--;
          if (json.str [json.len - 1] == ',') {
            json.erase(json.len - 1, 1);
          }
          json.append("]");
          json.append("},");

          break;
        case GMenu.TreeItemType.ALIAS:
        case GMenu.TreeItemType.ENTRY:
          var entry = iter.get_entry();
          var app_info = entry.get_app_info();
          var name = app_info.get_display_name();
          var icon = app_info.get_string("Icon");
          var desktop = entry.get_desktop_file_path();
          // print("  - %s (icon=%s;%s, file:%s)\n", name, icon, get_icon_path(icon), path);
          var data = "{
            \"name\": \"%s\",
            \"icon\": \"%s\",
            \"desktop\": \"%s\"
          },".printf(name, get_icon_path(icon), desktop);
          json.append(data);
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
