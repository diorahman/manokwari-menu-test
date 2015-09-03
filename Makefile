manokwari_menu_test: m.vala w.vala menu.vala
	valac m.vala w.vala menu.vala --pkg gio-unix-2.0 --pkg libgnome-menu-3.0 --pkg gtk+-3.0 -X -DGMENU_I_KNOW_THIS_IS_UNSTABLE -o manokwari_menu_test

test:
	./manokwari_menu_test

clean:
	rm -fr manokwari_menu_test
