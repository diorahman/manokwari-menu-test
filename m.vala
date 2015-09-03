public class Main: Gtk.Application {
  private Win w;
  private Menu m;
  private Main() {
    Object (application_id: "id.manokwari.menu_test", flags: ApplicationFlags.FLAGS_NONE);
  }

  public static int main(string[] args) {
    Main app = new Main();
    return app.run(args);
  }

  public override void activate() {
    w = new Win(this);
    m = new Menu();
    m.test();
    w.show_all();
  }
}
