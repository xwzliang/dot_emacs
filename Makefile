EMACS_DIR = ~/.emacs.d
MY_INIT_DIR = my_inits
MY_PACKAGE_DIR = my_packages
OTHERS_DIR = others
LOCAL_SETTING_DIR = local_setting
REPO_DIR = ~/git/dot_emacs
STRAIGHT_DIR = $(EMACS_DIR)/straight
STRAIGHT_VERSIONS_FILE = $(STRAIGHT_DIR)/versions

all:
	make clean
	ln -sf $(REPO_DIR)/init.el $(EMACS_DIR)/init.el
	ln -sf $(REPO_DIR)/$(MY_INIT_DIR) $(EMACS_DIR)/$(MY_INIT_DIR)
	ln -sf $(REPO_DIR)/$(MY_PACKAGE_DIR) $(EMACS_DIR)/$(MY_PACKAGE_DIR)
	ln -sf $(REPO_DIR)/$(LOCAL_SETTING_DIR) $(EMACS_DIR)/$(LOCAL_SETTING_DIR)
	mkdir -p $(EMACS_DIR)/eshell
	ln -sf $(REPO_DIR)/$(OTHERS_DIR)/eshell_alias $(EMACS_DIR)/eshell/alias
	mkdir -p $(STRAIGHT_DIR)
	ln -sf $(REPO_DIR)/versions.el $(STRAIGHT_VERSIONS_FILE)

clean:
	rm -f $(EMACS_DIR)/init.el
	rm -rf $(EMACS_DIR)/$(MY_INIT_DIR)
	rm -rf $(EMACS_DIR)/$(MY_PACKAGE_DIR)
	rm -rf $(EMACS_DIR)/$(LOCAL_SETTING_DIR)
	rm -f $(EMACS_DIR)/eshell/alias
	rm -f $(STRAIGHT_VERSIONS_FILE)
