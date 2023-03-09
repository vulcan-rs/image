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
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(PKG_CARGO_ENV) $(VULCAN_CARGO_ENVIRONMENT) cargo build \
		--workspace \
		--$(VULCAN_CARGO_MODE) \
		--target $(RUSTC_TARGET_NAME) \
		-Z target-applies-to-host
endef

define VULCAN_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 $(@D)/$(VULCAN_BIN_DIR)/vulcan-dhcpd $(TARGET_DIR)/usr/bin/vulcan-dhcpd
	$(INSTALL) -m 0755 $(@D)/$(VULCAN_BIN_DIR)/vulcan-dhcpc $(TARGET_DIR)/usr/bin/vulcan-dhcpc
	$(INSTALL) -m 0755 $(@D)/$(VULCAN_BIN_DIR)/vulcan-ctl $(TARGET_DIR)/usr/bin/vulcan-ctl
endef

define VULCAN_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 $(BR2_EXTERNAL_VULCAN_PATH)/package/vulcan/services/vulcan-dhcpd.service \
		$(TARGET_DIR)/usr/lib/systemd/system/vulcan-dhcpd.service
	$(INSTALL) -D -m 644 $(BR2_EXTERNAL_VULCAN_PATH)/package/vulcan/services/vulcan-dhcpc.service \
		$(TARGET_DIR)/usr/lib/systemd/system/vulcan-dhcpc.service
endef

define VULCAN_INSTALL_CONFIG_FILE
	$(INSTALL) -D -m 644 $(BR2_EXTERNAL_VULCAN_PATH)/package/vulcan/extra/dhcpd.toml \
		$(TARGET_DIR)/etc/vulcan/dhcpd.toml
	$(INSTALL) -D -m 644 $(BR2_EXTERNAL_VULCAN_PATH)/package/vulcan/extra/dhcpc.toml \
		$(TARGET_DIR)/etc/vulcan/dhcpc.toml
endef

$(eval $(cargo-package))