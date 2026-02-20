# generated from target.nix.handlebars using cargo (manual edits won't be persistent)
{ pkgs, cargo-0_88_0-46cd318ceff9739d, cargo-credential-0_4_8-a5adc6ab9fe103b0, cargo-credential-libsecret-0_4_13-4e698a0b35f72d06, cargo-platform-0_2_0-c5f768769f22a333, cargo-util-0_2_20-7087e4a73afc7b23, cargo-util-schemas-0_8_1-bce7b79eff35b46a, crates-io-0_40_10-cb0425982b906266, rustfix-0_9_0-9f1c66820d29e14a, cargo-0_88_0-bin-25c525326f58ed30 }:

pkgs.writeShellScriptBin "create-symlinks" ''
  if [[ -f "${cargo-0_88_0-46cd318ceff9739d}/libcargo-46cd318ceff9739d.rlib" ]]; then
    ln -fs ${cargo-0_88_0-46cd318ceff9739d}/libcargo-46cd318ceff9739d.rlib target/debug/libcargo.rlib
  fi
  if [[ -f "${cargo-0_88_0-46cd318ceff9739d}/libcargo-46cd318ceff9739d.so" ]]; then
    ln -fs ${cargo-0_88_0-46cd318ceff9739d}/libcargo-46cd318ceff9739d.so target/debug/libcargo.so
  fi
  if [[ -f "${cargo-0_88_0-46cd318ceff9739d}/libcargo-46cd318ceff9739d.a" ]]; then
    ln -fs ${cargo-0_88_0-46cd318ceff9739d}/libcargo-46cd318ceff9739d.a target/debug/libcargo.a
  fi
  if [[ -f "${cargo-0_88_0-46cd318ceff9739d}/libcargo-46cd318ceff9739d.rmeta" ]]; then
    ln -fs ${cargo-0_88_0-46cd318ceff9739d}/libcargo-46cd318ceff9739d.rmeta target/debug/libcargo.rmeta
  fi
  if [[ -f "${cargo-0_88_0-46cd318ceff9739d}/libcargo-46cd318ceff9739d.d" ]]; then
    ln -fs ${cargo-0_88_0-46cd318ceff9739d}/libcargo-46cd318ceff9739d.d target/debug/libcargo.d
  fi
  if [[ -f "${cargo-credential-0_4_8-a5adc6ab9fe103b0}/libcargo_credential-a5adc6ab9fe103b0.rlib" ]]; then
    ln -fs ${cargo-credential-0_4_8-a5adc6ab9fe103b0}/libcargo_credential-a5adc6ab9fe103b0.rlib target/debug/libcargo_credential.rlib
  fi
  if [[ -f "${cargo-credential-0_4_8-a5adc6ab9fe103b0}/libcargo_credential-a5adc6ab9fe103b0.so" ]]; then
    ln -fs ${cargo-credential-0_4_8-a5adc6ab9fe103b0}/libcargo_credential-a5adc6ab9fe103b0.so target/debug/libcargo_credential.so
  fi
  if [[ -f "${cargo-credential-0_4_8-a5adc6ab9fe103b0}/libcargo_credential-a5adc6ab9fe103b0.a" ]]; then
    ln -fs ${cargo-credential-0_4_8-a5adc6ab9fe103b0}/libcargo_credential-a5adc6ab9fe103b0.a target/debug/libcargo_credential.a
  fi
  if [[ -f "${cargo-credential-0_4_8-a5adc6ab9fe103b0}/libcargo_credential-a5adc6ab9fe103b0.rmeta" ]]; then
    ln -fs ${cargo-credential-0_4_8-a5adc6ab9fe103b0}/libcargo_credential-a5adc6ab9fe103b0.rmeta target/debug/libcargo_credential.rmeta
  fi
  if [[ -f "${cargo-credential-0_4_8-a5adc6ab9fe103b0}/libcargo_credential-a5adc6ab9fe103b0.d" ]]; then
    ln -fs ${cargo-credential-0_4_8-a5adc6ab9fe103b0}/libcargo_credential-a5adc6ab9fe103b0.d target/debug/libcargo_credential.d
  fi
  if [[ -f "${cargo-credential-libsecret-0_4_13-4e698a0b35f72d06}/libcargo_credential_libsecret-4e698a0b35f72d06.rlib" ]]; then
    ln -fs ${cargo-credential-libsecret-0_4_13-4e698a0b35f72d06}/libcargo_credential_libsecret-4e698a0b35f72d06.rlib target/debug/libcargo_credential_libsecret.rlib
  fi
  if [[ -f "${cargo-credential-libsecret-0_4_13-4e698a0b35f72d06}/libcargo_credential_libsecret-4e698a0b35f72d06.so" ]]; then
    ln -fs ${cargo-credential-libsecret-0_4_13-4e698a0b35f72d06}/libcargo_credential_libsecret-4e698a0b35f72d06.so target/debug/libcargo_credential_libsecret.so
  fi
  if [[ -f "${cargo-credential-libsecret-0_4_13-4e698a0b35f72d06}/libcargo_credential_libsecret-4e698a0b35f72d06.a" ]]; then
    ln -fs ${cargo-credential-libsecret-0_4_13-4e698a0b35f72d06}/libcargo_credential_libsecret-4e698a0b35f72d06.a target/debug/libcargo_credential_libsecret.a
  fi
  if [[ -f "${cargo-credential-libsecret-0_4_13-4e698a0b35f72d06}/libcargo_credential_libsecret-4e698a0b35f72d06.rmeta" ]]; then
    ln -fs ${cargo-credential-libsecret-0_4_13-4e698a0b35f72d06}/libcargo_credential_libsecret-4e698a0b35f72d06.rmeta target/debug/libcargo_credential_libsecret.rmeta
  fi
  if [[ -f "${cargo-credential-libsecret-0_4_13-4e698a0b35f72d06}/libcargo_credential_libsecret-4e698a0b35f72d06.d" ]]; then
    ln -fs ${cargo-credential-libsecret-0_4_13-4e698a0b35f72d06}/libcargo_credential_libsecret-4e698a0b35f72d06.d target/debug/libcargo_credential_libsecret.d
  fi
  if [[ -f "${cargo-platform-0_2_0-c5f768769f22a333}/libcargo_platform-c5f768769f22a333.rlib" ]]; then
    ln -fs ${cargo-platform-0_2_0-c5f768769f22a333}/libcargo_platform-c5f768769f22a333.rlib target/debug/libcargo_platform.rlib
  fi
  if [[ -f "${cargo-platform-0_2_0-c5f768769f22a333}/libcargo_platform-c5f768769f22a333.so" ]]; then
    ln -fs ${cargo-platform-0_2_0-c5f768769f22a333}/libcargo_platform-c5f768769f22a333.so target/debug/libcargo_platform.so
  fi
  if [[ -f "${cargo-platform-0_2_0-c5f768769f22a333}/libcargo_platform-c5f768769f22a333.a" ]]; then
    ln -fs ${cargo-platform-0_2_0-c5f768769f22a333}/libcargo_platform-c5f768769f22a333.a target/debug/libcargo_platform.a
  fi
  if [[ -f "${cargo-platform-0_2_0-c5f768769f22a333}/libcargo_platform-c5f768769f22a333.rmeta" ]]; then
    ln -fs ${cargo-platform-0_2_0-c5f768769f22a333}/libcargo_platform-c5f768769f22a333.rmeta target/debug/libcargo_platform.rmeta
  fi
  if [[ -f "${cargo-platform-0_2_0-c5f768769f22a333}/libcargo_platform-c5f768769f22a333.d" ]]; then
    ln -fs ${cargo-platform-0_2_0-c5f768769f22a333}/libcargo_platform-c5f768769f22a333.d target/debug/libcargo_platform.d
  fi
  if [[ -f "${cargo-util-0_2_20-7087e4a73afc7b23}/libcargo_util-7087e4a73afc7b23.rlib" ]]; then
    ln -fs ${cargo-util-0_2_20-7087e4a73afc7b23}/libcargo_util-7087e4a73afc7b23.rlib target/debug/libcargo_util.rlib
  fi
  if [[ -f "${cargo-util-0_2_20-7087e4a73afc7b23}/libcargo_util-7087e4a73afc7b23.so" ]]; then
    ln -fs ${cargo-util-0_2_20-7087e4a73afc7b23}/libcargo_util-7087e4a73afc7b23.so target/debug/libcargo_util.so
  fi
  if [[ -f "${cargo-util-0_2_20-7087e4a73afc7b23}/libcargo_util-7087e4a73afc7b23.a" ]]; then
    ln -fs ${cargo-util-0_2_20-7087e4a73afc7b23}/libcargo_util-7087e4a73afc7b23.a target/debug/libcargo_util.a
  fi
  if [[ -f "${cargo-util-0_2_20-7087e4a73afc7b23}/libcargo_util-7087e4a73afc7b23.rmeta" ]]; then
    ln -fs ${cargo-util-0_2_20-7087e4a73afc7b23}/libcargo_util-7087e4a73afc7b23.rmeta target/debug/libcargo_util.rmeta
  fi
  if [[ -f "${cargo-util-0_2_20-7087e4a73afc7b23}/libcargo_util-7087e4a73afc7b23.d" ]]; then
    ln -fs ${cargo-util-0_2_20-7087e4a73afc7b23}/libcargo_util-7087e4a73afc7b23.d target/debug/libcargo_util.d
  fi
  if [[ -f "${cargo-util-schemas-0_8_1-bce7b79eff35b46a}/libcargo_util_schemas-bce7b79eff35b46a.rlib" ]]; then
    ln -fs ${cargo-util-schemas-0_8_1-bce7b79eff35b46a}/libcargo_util_schemas-bce7b79eff35b46a.rlib target/debug/libcargo_util_schemas.rlib
  fi
  if [[ -f "${cargo-util-schemas-0_8_1-bce7b79eff35b46a}/libcargo_util_schemas-bce7b79eff35b46a.so" ]]; then
    ln -fs ${cargo-util-schemas-0_8_1-bce7b79eff35b46a}/libcargo_util_schemas-bce7b79eff35b46a.so target/debug/libcargo_util_schemas.so
  fi
  if [[ -f "${cargo-util-schemas-0_8_1-bce7b79eff35b46a}/libcargo_util_schemas-bce7b79eff35b46a.a" ]]; then
    ln -fs ${cargo-util-schemas-0_8_1-bce7b79eff35b46a}/libcargo_util_schemas-bce7b79eff35b46a.a target/debug/libcargo_util_schemas.a
  fi
  if [[ -f "${cargo-util-schemas-0_8_1-bce7b79eff35b46a}/libcargo_util_schemas-bce7b79eff35b46a.rmeta" ]]; then
    ln -fs ${cargo-util-schemas-0_8_1-bce7b79eff35b46a}/libcargo_util_schemas-bce7b79eff35b46a.rmeta target/debug/libcargo_util_schemas.rmeta
  fi
  if [[ -f "${cargo-util-schemas-0_8_1-bce7b79eff35b46a}/libcargo_util_schemas-bce7b79eff35b46a.d" ]]; then
    ln -fs ${cargo-util-schemas-0_8_1-bce7b79eff35b46a}/libcargo_util_schemas-bce7b79eff35b46a.d target/debug/libcargo_util_schemas.d
  fi
  if [[ -f "${crates-io-0_40_10-cb0425982b906266}/libcrates_io-cb0425982b906266.rlib" ]]; then
    ln -fs ${crates-io-0_40_10-cb0425982b906266}/libcrates_io-cb0425982b906266.rlib target/debug/libcrates_io.rlib
  fi
  if [[ -f "${crates-io-0_40_10-cb0425982b906266}/libcrates_io-cb0425982b906266.so" ]]; then
    ln -fs ${crates-io-0_40_10-cb0425982b906266}/libcrates_io-cb0425982b906266.so target/debug/libcrates_io.so
  fi
  if [[ -f "${crates-io-0_40_10-cb0425982b906266}/libcrates_io-cb0425982b906266.a" ]]; then
    ln -fs ${crates-io-0_40_10-cb0425982b906266}/libcrates_io-cb0425982b906266.a target/debug/libcrates_io.a
  fi
  if [[ -f "${crates-io-0_40_10-cb0425982b906266}/libcrates_io-cb0425982b906266.rmeta" ]]; then
    ln -fs ${crates-io-0_40_10-cb0425982b906266}/libcrates_io-cb0425982b906266.rmeta target/debug/libcrates_io.rmeta
  fi
  if [[ -f "${crates-io-0_40_10-cb0425982b906266}/libcrates_io-cb0425982b906266.d" ]]; then
    ln -fs ${crates-io-0_40_10-cb0425982b906266}/libcrates_io-cb0425982b906266.d target/debug/libcrates_io.d
  fi
  if [[ -f "${rustfix-0_9_0-9f1c66820d29e14a}/librustfix-9f1c66820d29e14a.rlib" ]]; then
    ln -fs ${rustfix-0_9_0-9f1c66820d29e14a}/librustfix-9f1c66820d29e14a.rlib target/debug/librustfix.rlib
  fi
  if [[ -f "${rustfix-0_9_0-9f1c66820d29e14a}/librustfix-9f1c66820d29e14a.so" ]]; then
    ln -fs ${rustfix-0_9_0-9f1c66820d29e14a}/librustfix-9f1c66820d29e14a.so target/debug/librustfix.so
  fi
  if [[ -f "${rustfix-0_9_0-9f1c66820d29e14a}/librustfix-9f1c66820d29e14a.a" ]]; then
    ln -fs ${rustfix-0_9_0-9f1c66820d29e14a}/librustfix-9f1c66820d29e14a.a target/debug/librustfix.a
  fi
  if [[ -f "${rustfix-0_9_0-9f1c66820d29e14a}/librustfix-9f1c66820d29e14a.rmeta" ]]; then
    ln -fs ${rustfix-0_9_0-9f1c66820d29e14a}/librustfix-9f1c66820d29e14a.rmeta target/debug/librustfix.rmeta
  fi
  if [[ -f "${rustfix-0_9_0-9f1c66820d29e14a}/librustfix-9f1c66820d29e14a.d" ]]; then
    ln -fs ${rustfix-0_9_0-9f1c66820d29e14a}/librustfix-9f1c66820d29e14a.d target/debug/librustfix.d
  fi
  rm -f target/debug/cargo
  ln -s ${cargo-0_88_0-bin-25c525326f58ed30}/bin/cargo target/debug/
''