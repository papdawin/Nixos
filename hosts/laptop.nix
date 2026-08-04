{ localCerts, ... }:
{
  networking.hostName = "laptop";

  security.pki.certificateFiles = [
    (localCerts + "/mvmh_root_ca_2035.cer")
    (localCerts + "/mvmh_ca02_2035.cer")
    (localCerts + "/mvmh_op_ca01_2034.cer")
    (localCerts + "/mvmh_op_ca2_2026.cer")
  ];
}
