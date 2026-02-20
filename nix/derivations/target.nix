# generated from target.nix.handlebars using cargo (manual edits won't be persistent)
{ pkgs, cargo-0_88_0-b9aa49f38b781d3e, cargo-credential-0_4_8-04d496e2b8c4b2ba, cargo-credential-libsecret-0_4_13-9f8a917365498280, cargo-platform-0_2_0-9528fcbd58f1490b, cargo-util-0_2_20-ca8e56b3d4554315, cargo-util-schemas-0_8_1-a76d1978f9d187be, crates-io-0_40_10-114ba05d6d48e004, rustfix-0_9_0-f92d91d9c29999cf, cargo-0_88_0-bin-b4cc6eeacb818d24 }:

pkgs.writeShellScriptBin "create-symlinks" ''
  if [[ -f "${cargo-0_88_0-b9aa49f38b781d3e}/libcargo-b9aa49f38b781d3e.rlib" ]]; then
    ln -fs ${cargo-0_88_0-b9aa49f38b781d3e}/libcargo-b9aa49f38b781d3e.rlib target/release/libcargo.rlib
  fi
  if [[ -f "${cargo-0_88_0-b9aa49f38b781d3e}/libcargo-b9aa49f38b781d3e.so" ]]; then
    ln -fs ${cargo-0_88_0-b9aa49f38b781d3e}/libcargo-b9aa49f38b781d3e.so target/release/libcargo.so
  fi
  if [[ -f "${cargo-0_88_0-b9aa49f38b781d3e}/libcargo-b9aa49f38b781d3e.a" ]]; then
    ln -fs ${cargo-0_88_0-b9aa49f38b781d3e}/libcargo-b9aa49f38b781d3e.a target/release/libcargo.a
  fi
  if [[ -f "${cargo-0_88_0-b9aa49f38b781d3e}/libcargo-b9aa49f38b781d3e.rmeta" ]]; then
    ln -fs ${cargo-0_88_0-b9aa49f38b781d3e}/libcargo-b9aa49f38b781d3e.rmeta target/release/libcargo.rmeta
  fi
  if [[ -f "${cargo-0_88_0-b9aa49f38b781d3e}/libcargo-b9aa49f38b781d3e.d" ]]; then
    ln -fs ${cargo-0_88_0-b9aa49f38b781d3e}/libcargo-b9aa49f38b781d3e.d target/release/libcargo.d
  fi
  if [[ -f "${cargo-credential-0_4_8-04d496e2b8c4b2ba}/libcargo_credential-04d496e2b8c4b2ba.rlib" ]]; then
    ln -fs ${cargo-credential-0_4_8-04d496e2b8c4b2ba}/libcargo_credential-04d496e2b8c4b2ba.rlib target/release/libcargo_credential.rlib
  fi
  if [[ -f "${cargo-credential-0_4_8-04d496e2b8c4b2ba}/libcargo_credential-04d496e2b8c4b2ba.so" ]]; then
    ln -fs ${cargo-credential-0_4_8-04d496e2b8c4b2ba}/libcargo_credential-04d496e2b8c4b2ba.so target/release/libcargo_credential.so
  fi
  if [[ -f "${cargo-credential-0_4_8-04d496e2b8c4b2ba}/libcargo_credential-04d496e2b8c4b2ba.a" ]]; then
    ln -fs ${cargo-credential-0_4_8-04d496e2b8c4b2ba}/libcargo_credential-04d496e2b8c4b2ba.a target/release/libcargo_credential.a
  fi
  if [[ -f "${cargo-credential-0_4_8-04d496e2b8c4b2ba}/libcargo_credential-04d496e2b8c4b2ba.rmeta" ]]; then
    ln -fs ${cargo-credential-0_4_8-04d496e2b8c4b2ba}/libcargo_credential-04d496e2b8c4b2ba.rmeta target/release/libcargo_credential.rmeta
  fi
  if [[ -f "${cargo-credential-0_4_8-04d496e2b8c4b2ba}/libcargo_credential-04d496e2b8c4b2ba.d" ]]; then
    ln -fs ${cargo-credential-0_4_8-04d496e2b8c4b2ba}/libcargo_credential-04d496e2b8c4b2ba.d target/release/libcargo_credential.d
  fi
  if [[ -f "${cargo-credential-libsecret-0_4_13-9f8a917365498280}/libcargo_credential_libsecret-9f8a917365498280.rlib" ]]; then
    ln -fs ${cargo-credential-libsecret-0_4_13-9f8a917365498280}/libcargo_credential_libsecret-9f8a917365498280.rlib target/release/libcargo_credential_libsecret.rlib
  fi
  if [[ -f "${cargo-credential-libsecret-0_4_13-9f8a917365498280}/libcargo_credential_libsecret-9f8a917365498280.so" ]]; then
    ln -fs ${cargo-credential-libsecret-0_4_13-9f8a917365498280}/libcargo_credential_libsecret-9f8a917365498280.so target/release/libcargo_credential_libsecret.so
  fi
  if [[ -f "${cargo-credential-libsecret-0_4_13-9f8a917365498280}/libcargo_credential_libsecret-9f8a917365498280.a" ]]; then
    ln -fs ${cargo-credential-libsecret-0_4_13-9f8a917365498280}/libcargo_credential_libsecret-9f8a917365498280.a target/release/libcargo_credential_libsecret.a
  fi
  if [[ -f "${cargo-credential-libsecret-0_4_13-9f8a917365498280}/libcargo_credential_libsecret-9f8a917365498280.rmeta" ]]; then
    ln -fs ${cargo-credential-libsecret-0_4_13-9f8a917365498280}/libcargo_credential_libsecret-9f8a917365498280.rmeta target/release/libcargo_credential_libsecret.rmeta
  fi
  if [[ -f "${cargo-credential-libsecret-0_4_13-9f8a917365498280}/libcargo_credential_libsecret-9f8a917365498280.d" ]]; then
    ln -fs ${cargo-credential-libsecret-0_4_13-9f8a917365498280}/libcargo_credential_libsecret-9f8a917365498280.d target/release/libcargo_credential_libsecret.d
  fi
  if [[ -f "${cargo-platform-0_2_0-9528fcbd58f1490b}/libcargo_platform-9528fcbd58f1490b.rlib" ]]; then
    ln -fs ${cargo-platform-0_2_0-9528fcbd58f1490b}/libcargo_platform-9528fcbd58f1490b.rlib target/release/libcargo_platform.rlib
  fi
  if [[ -f "${cargo-platform-0_2_0-9528fcbd58f1490b}/libcargo_platform-9528fcbd58f1490b.so" ]]; then
    ln -fs ${cargo-platform-0_2_0-9528fcbd58f1490b}/libcargo_platform-9528fcbd58f1490b.so target/release/libcargo_platform.so
  fi
  if [[ -f "${cargo-platform-0_2_0-9528fcbd58f1490b}/libcargo_platform-9528fcbd58f1490b.a" ]]; then
    ln -fs ${cargo-platform-0_2_0-9528fcbd58f1490b}/libcargo_platform-9528fcbd58f1490b.a target/release/libcargo_platform.a
  fi
  if [[ -f "${cargo-platform-0_2_0-9528fcbd58f1490b}/libcargo_platform-9528fcbd58f1490b.rmeta" ]]; then
    ln -fs ${cargo-platform-0_2_0-9528fcbd58f1490b}/libcargo_platform-9528fcbd58f1490b.rmeta target/release/libcargo_platform.rmeta
  fi
  if [[ -f "${cargo-platform-0_2_0-9528fcbd58f1490b}/libcargo_platform-9528fcbd58f1490b.d" ]]; then
    ln -fs ${cargo-platform-0_2_0-9528fcbd58f1490b}/libcargo_platform-9528fcbd58f1490b.d target/release/libcargo_platform.d
  fi
  if [[ -f "${cargo-util-0_2_20-ca8e56b3d4554315}/libcargo_util-ca8e56b3d4554315.rlib" ]]; then
    ln -fs ${cargo-util-0_2_20-ca8e56b3d4554315}/libcargo_util-ca8e56b3d4554315.rlib target/release/libcargo_util.rlib
  fi
  if [[ -f "${cargo-util-0_2_20-ca8e56b3d4554315}/libcargo_util-ca8e56b3d4554315.so" ]]; then
    ln -fs ${cargo-util-0_2_20-ca8e56b3d4554315}/libcargo_util-ca8e56b3d4554315.so target/release/libcargo_util.so
  fi
  if [[ -f "${cargo-util-0_2_20-ca8e56b3d4554315}/libcargo_util-ca8e56b3d4554315.a" ]]; then
    ln -fs ${cargo-util-0_2_20-ca8e56b3d4554315}/libcargo_util-ca8e56b3d4554315.a target/release/libcargo_util.a
  fi
  if [[ -f "${cargo-util-0_2_20-ca8e56b3d4554315}/libcargo_util-ca8e56b3d4554315.rmeta" ]]; then
    ln -fs ${cargo-util-0_2_20-ca8e56b3d4554315}/libcargo_util-ca8e56b3d4554315.rmeta target/release/libcargo_util.rmeta
  fi
  if [[ -f "${cargo-util-0_2_20-ca8e56b3d4554315}/libcargo_util-ca8e56b3d4554315.d" ]]; then
    ln -fs ${cargo-util-0_2_20-ca8e56b3d4554315}/libcargo_util-ca8e56b3d4554315.d target/release/libcargo_util.d
  fi
  if [[ -f "${cargo-util-schemas-0_8_1-a76d1978f9d187be}/libcargo_util_schemas-a76d1978f9d187be.rlib" ]]; then
    ln -fs ${cargo-util-schemas-0_8_1-a76d1978f9d187be}/libcargo_util_schemas-a76d1978f9d187be.rlib target/release/libcargo_util_schemas.rlib
  fi
  if [[ -f "${cargo-util-schemas-0_8_1-a76d1978f9d187be}/libcargo_util_schemas-a76d1978f9d187be.so" ]]; then
    ln -fs ${cargo-util-schemas-0_8_1-a76d1978f9d187be}/libcargo_util_schemas-a76d1978f9d187be.so target/release/libcargo_util_schemas.so
  fi
  if [[ -f "${cargo-util-schemas-0_8_1-a76d1978f9d187be}/libcargo_util_schemas-a76d1978f9d187be.a" ]]; then
    ln -fs ${cargo-util-schemas-0_8_1-a76d1978f9d187be}/libcargo_util_schemas-a76d1978f9d187be.a target/release/libcargo_util_schemas.a
  fi
  if [[ -f "${cargo-util-schemas-0_8_1-a76d1978f9d187be}/libcargo_util_schemas-a76d1978f9d187be.rmeta" ]]; then
    ln -fs ${cargo-util-schemas-0_8_1-a76d1978f9d187be}/libcargo_util_schemas-a76d1978f9d187be.rmeta target/release/libcargo_util_schemas.rmeta
  fi
  if [[ -f "${cargo-util-schemas-0_8_1-a76d1978f9d187be}/libcargo_util_schemas-a76d1978f9d187be.d" ]]; then
    ln -fs ${cargo-util-schemas-0_8_1-a76d1978f9d187be}/libcargo_util_schemas-a76d1978f9d187be.d target/release/libcargo_util_schemas.d
  fi
  if [[ -f "${crates-io-0_40_10-114ba05d6d48e004}/libcrates_io-114ba05d6d48e004.rlib" ]]; then
    ln -fs ${crates-io-0_40_10-114ba05d6d48e004}/libcrates_io-114ba05d6d48e004.rlib target/release/libcrates_io.rlib
  fi
  if [[ -f "${crates-io-0_40_10-114ba05d6d48e004}/libcrates_io-114ba05d6d48e004.so" ]]; then
    ln -fs ${crates-io-0_40_10-114ba05d6d48e004}/libcrates_io-114ba05d6d48e004.so target/release/libcrates_io.so
  fi
  if [[ -f "${crates-io-0_40_10-114ba05d6d48e004}/libcrates_io-114ba05d6d48e004.a" ]]; then
    ln -fs ${crates-io-0_40_10-114ba05d6d48e004}/libcrates_io-114ba05d6d48e004.a target/release/libcrates_io.a
  fi
  if [[ -f "${crates-io-0_40_10-114ba05d6d48e004}/libcrates_io-114ba05d6d48e004.rmeta" ]]; then
    ln -fs ${crates-io-0_40_10-114ba05d6d48e004}/libcrates_io-114ba05d6d48e004.rmeta target/release/libcrates_io.rmeta
  fi
  if [[ -f "${crates-io-0_40_10-114ba05d6d48e004}/libcrates_io-114ba05d6d48e004.d" ]]; then
    ln -fs ${crates-io-0_40_10-114ba05d6d48e004}/libcrates_io-114ba05d6d48e004.d target/release/libcrates_io.d
  fi
  if [[ -f "${rustfix-0_9_0-f92d91d9c29999cf}/librustfix-f92d91d9c29999cf.rlib" ]]; then
    ln -fs ${rustfix-0_9_0-f92d91d9c29999cf}/librustfix-f92d91d9c29999cf.rlib target/release/librustfix.rlib
  fi
  if [[ -f "${rustfix-0_9_0-f92d91d9c29999cf}/librustfix-f92d91d9c29999cf.so" ]]; then
    ln -fs ${rustfix-0_9_0-f92d91d9c29999cf}/librustfix-f92d91d9c29999cf.so target/release/librustfix.so
  fi
  if [[ -f "${rustfix-0_9_0-f92d91d9c29999cf}/librustfix-f92d91d9c29999cf.a" ]]; then
    ln -fs ${rustfix-0_9_0-f92d91d9c29999cf}/librustfix-f92d91d9c29999cf.a target/release/librustfix.a
  fi
  if [[ -f "${rustfix-0_9_0-f92d91d9c29999cf}/librustfix-f92d91d9c29999cf.rmeta" ]]; then
    ln -fs ${rustfix-0_9_0-f92d91d9c29999cf}/librustfix-f92d91d9c29999cf.rmeta target/release/librustfix.rmeta
  fi
  if [[ -f "${rustfix-0_9_0-f92d91d9c29999cf}/librustfix-f92d91d9c29999cf.d" ]]; then
    ln -fs ${rustfix-0_9_0-f92d91d9c29999cf}/librustfix-f92d91d9c29999cf.d target/release/librustfix.d
  fi
  rm -f target/release/cargo
  ln -s ${cargo-0_88_0-bin-b4cc6eeacb818d24}/bin/cargo target/release/
''