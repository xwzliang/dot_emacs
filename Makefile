EMACS_DIR = ~/.emacs.d
MY_INIT_DIR = my_inits
MY_PACKAGE_DIR = my_packages
OTHERS_DIR = others
REPO_DIR = ~/git/dot_emacs

all:
	make clean
	ln -sf $(REPO_DIR)/init.el $(EMACS_DIR)/init.el
	ln -sf $(REPO_DIR)/$(MY_INIT_DIR) $(EMACS_DIR)/$(MY_INIT_DIR)
	ln -sf $(REPO_DIR)/$(MY_PACKAGE_DIR) $(EMACS_DIR)/$(MY_PACKAGE_DIR)
	ln -sf $(REPO_DIR)/$(OTHERS_DIR)/eshell_alias $(EMACS_DIR)/eshell/alias

clean:
	rm -f $(EMACS_DIR)/init.el
	rm -f $(EMACS_DIR)/$(MY_INIT_DIR)
	rm -f $(EMACS_DIR)/$(MY_PACKAGE_DIR)
