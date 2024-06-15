{ super
, fetchFromGitHub
, ...
}@args:
(super.ibus-engines.table-chinese.overrideAttrs (old: {
  pname = "ibus-table-cangjie-lite";

  src = fetchFromGitHub {
    owner = "mike-fabian";
    repo = "ibus-table-chinese";
    rev = "cc4a17fde8904c6e60ded3558c551c90d9b72454";
    sha256 = "HbzJTYeb2VVXuH5r0Z7t2I1usU0Jzj3HkgKuiEUCCrg=";
  };

  cmakeFlags = [
    "-DENABLE_TABLE_PREPROCESS=1"
  ] ++ super.ibus-engines.table-chinese.cmakeFlags;

  patches = [
    ./limit-tables.patch
  ];

  version = "1.8.8";
}))
