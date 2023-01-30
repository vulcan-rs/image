################################################################################
#
# vulcan
#
################################################################################

VULCAN_VERSION = 0.0.1
VULCAN_SITE = $(BR2_EXTERNAL_VULCAN_PATH)/src/vulcan
VULCAN_SITE_METHOD = local
VULCAN_LICENSE = GPL-3.0+
VULCAN_LICENSE_FILES = LICENSE

VULCAN_CARGO_MODE = release
VULCAN_BIN_DIR = target/$(RUSTC_TARGET_NAME)/$(VULCAN_CARGO_MODE)

define VULCAN_BUILD_CMDS
	cd $(@D) && \
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(PKG_CARGO_ENV) $(VULCAN_CARGO_ENVIRONMENT) cargo build --$(VULCAN_CARGO_MODE) --target $(RUSTC_TARGET_NAME) -Z target-applies-to-host
endef

define VULCAN_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 $(@D)/$(VULCAN_BIN_DIR)/vulcan-dhcpd $(TARGET_DIR)/usr/bin/vulcan-dhcpd
	$(INSTALL) -m 0755 $(@D)/$(VULCAN_BIN_DIR)/vulcan-dhcp $(TARGET_DIR)/usr/bin/vulcan-dhcp
endef

$(eval $(cargo-package))