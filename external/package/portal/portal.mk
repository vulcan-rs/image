################################################################################
#
# portal
#
################################################################################

PORTAL_VERSION = 0.0.1
PORTAL_SITE = $(BR2_EXTERNAL_VULCAN_PATH)/src/portal
PORTAL_SITE_METHOD = local
PORTAL_LICENSE = GPL-3.0+
PORTAL_LICENSE_FILES = LICENSE

PORTAL_CARGO_MODE = release
PORTAL_BIN_DIR = target/$(RUSTC_TARGET_NAME)/$(PORTAL_CARGO_MODE)

define PORTAL_BUILD_CMDS
	cd $(@D) && \
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(PKG_CARGO_ENV) $(PORTAL_CARGO_ENVIRONMENT) cargo build \
		--workspace \
		--$(PORTAL_CARGO_MODE) \
		--target $(RUSTC_TARGET_NAME) \
		-Z target-applies-to-host
endef

define PORTAL_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 $(@D)/$(VULCAN_BIN_DIR)/portald $(TARGET_DIR)/usr/bin/portald
	$(INSTALL) -m 0755 $(@D)/$(VULCAN_BIN_DIR)/pgun $(TARGET_DIR)/usr/bin/pgun
endef

define PORTAL_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 $(BR2_EXTERNAL_VULCAN_PATH)/package/portal/portald.service \
		$(TARGET_DIR)/usr/lib/systemd/system/portald.service
endef

define PORTAL_INSTALL_CONFIG_FILE
	$(INSTALL) -D -m 644 $(BR2_EXTERNAL_VULCAN_PATH)/src/portal/extra/config.toml \
		$(TARGET_DIR)/etc/portald/config.toml
endef

PORTAL_POST_INSTALL_TARGET_HOOKS += PORTAL_INSTALL_CONFIG_FILE

$(eval $(cargo-package))