PROGRAM_NAME	=  "tslides"
RESOURCES_DIR   =  $(HOME)/.resources
BIN_INSTALL_DIR =  $(HOME)/bin

install:
		mkdir -p $(RESOURCES_DIR)/$(PROGRAM_NAME)
		cp -r resources/* $(RESOURCES_DIR)/$(PROGRAM_NAME) 
		cp -r main.sh $(BIN_INSTALL_DIR)/$(PROGRAM_NAME)

uninstall:
		rm -rf $(RESOURCES_DIR)/$(PROGRAM_NAME)
		rm $(BIN_INSTALL_DIR)/$(PROGRAM_NAME)

document:
		autodoc main.sh
